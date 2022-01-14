import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/stock/select_customer_page.dart';
import 'package:good_grandma/pages/work/freezer_statistics/freezer_statistics_list.dart';
import 'package:good_grandma/pages/work/freezer_statistics/freezer_statistics_type.dart';
import 'package:good_grandma/widgets/select_tree.dart';

///冰柜统计
class FreezerStatistics extends StatefulWidget {
  const FreezerStatistics({Key key}) : super(key: key);

  @override
  _FreezerStatisticsState createState() => _FreezerStatisticsState();
}

class _FreezerStatisticsState extends State<FreezerStatistics> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  int _current = 1;
  int _pageSize = 10;

  String deptId = '';
  String areaName = '区域';
  String customerId = '';
  String customerName = '客户';
  String status= '';
  String statusName = '状态';

  List<Map> freezerList = [];

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
        title: Text("冰柜统计",style: TextStyle(fontSize: 18, color: Colors.black)),
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            FreezerStatisticsType(
              areaName: areaName,
              customerName: customerName,
              statusName: statusName,
              onPressed: () async{
                Map area = await showSelectTreeList(context, '全国');
                deptId = area['deptId'];
                areaName = area['areaName'];
                _controller.callRefresh();
              },
              onPressed2: () async{
                Map select = await showSelectSearchList(context, Api.customerList, '请选择客户名称', 'corporateName');
                customerId = select['id'];
                customerName = select['corporateName'];
                _controller.callRefresh();
              },
              onPressed3: () async {
                String result = await showPicker(['所有状态', '未开柜', '已开柜'], context);
                switch(result){
                  case '所有状态':
                    status = '';
                    break;
                  case '未开柜':
                    status = '0';
                    break;
                  case '已开柜':
                    status = '1';
                    break;
                }
                statusName = result;
                _controller.callRefresh();
              }
            ),
            Expanded(
              child: MyEasyRefreshSliverWidget(
                  controller: _controller,
                  scrollController: _scrollController,
                  dataCount: freezerList.length,
                  onRefresh: _refresh,
                  onLoad: _onLoad,
                  slivers: [
                    SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return FreezerStatisticsList(data: freezerList[index]);
                        }, childCount: freezerList.length))
                  ]
              )
            )
          ]
        )
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

  ///冰柜统计列表
  Future<void> _downloadData() async {
    try {
      Map<String, dynamic> map = {
        'dealerId': customerId,
        'deptId': deptId,
        'openFreezer': status,
        'current': _current,
        'size': _pageSize
      };
      final val = await requestGet(Api.freezerList, param: map);
      var data = jsonDecode(val.toString());
      LogUtil.d('请求结果---freezerList----$data');
      if (_current == 1) freezerList.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        freezerList.add(map);
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
