import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/widgets/marketing_activity_msg_cell.dart';

///出入库日志
class MarketMaterialDetail extends StatefulWidget {
  final String materialAreaId;
  MarketMaterialDetail({Key key, this.materialAreaId}) : super(key: key);

  @override
  _MarketMaterialDetailState createState() => _MarketMaterialDetailState();
}

class _MarketMaterialDetailState extends State<MarketMaterialDetail> {

  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();

  int _current = 1;
  int _pageSize = 10;
  List<Map> materialDetailsList = [];

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("出入库日志",style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700))
      ),
      body: MyEasyRefreshSliverWidget(
        controller: _controller,
        scrollController: _scrollController,
        dataCount: materialDetailsList.length,
        onRefresh: _refresh,
        onLoad: _onLoad,
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          offset: Offset(2, 1),
                          blurRadius: 1.5,
                        )
                      ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
                          decoration: BoxDecoration(
                            color: materialDetailsList[index]['state'] == 1 ? Color(0xFFFCEEEB) : Color(0xFFE8EAED)
                              , borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(materialDetailsList[index]['state'] == 1 ? '入库' : '出库', style: TextStyle(fontSize: 10,
                                  color: materialDetailsList[index]['state'] == 1 ? Color(0xFFE4A382) : Color(0xFFB3B5B8)))
                      ),
                      MarketingActivityMsgCell(title: '物料数量', value: materialDetailsList[index]['quantity'].toString()),
                      Visibility(
                        visible: materialDetailsList[index]['state'] == 1 ? true : false,
                        child: MarketingActivityMsgCell(title: '损耗', value: materialDetailsList[index]['loss'].toString())
                      ),
                      MarketingActivityMsgCell(title: '申请人', value: materialDetailsList[index]['userName']),
                      MarketingActivityMsgCell(title: '备注', value: materialDetailsList[index]['remarks']),
                    ]
                  )
                );
              }, childCount: materialDetailsList.length)),
        ]
      )
    );
  }

  Future<void> _refresh() async {
    _current = 1;
    await _downloadData();
  }

  Future<void> _onLoad() async {
    _current++;
    await _downloadData();
  }

  ///市场物料出入库列表
  Future<void> _downloadData() async {
    try {
      Map<String, dynamic> map = {
        'materialAreaId': widget.materialAreaId,
        'current': _current,
        'size': _pageSize
      };
      final val = await requestGet(Api.materialDetailsList, param: map);
      var data = jsonDecode(val.toString());
      LogUtil.d('请求结果---materialDetailsList----$data');
      if (_current == 1) materialDetailsList.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        materialDetailsList.add(map);
      });
      bool noMore = false;
      if (list == null || list.isEmpty) noMore = true;
      _controller.finishRefresh(success: true);
      _controller.finishLoad(success: true, noMore: noMore);
      if (mounted) setState(() {});
    } catch (error) {
      _controller.finishRefresh(success: false);
      _controller.finishLoad(success: false, noMore: false);
    }
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _controller?.dispose();
    super.dispose();
  }
}
