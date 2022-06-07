import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/models/StoreModel.dart';
import 'package:good_grandma/pages/declaration_form/select_store_page.dart';
import 'package:good_grandma/pages/work/discount/discount_management_detail.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';

///折扣管理
class DiscountManagement extends StatefulWidget {
  const DiscountManagement({Key key}) : super(key: key);

  @override
  State<DiscountManagement> createState() => _DiscountManagementState();
}

class _DiscountManagementState extends State<DiscountManagement> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  List<Map> _dataArray = [];
  int _current = 1;
  int _pageSize = 15;
  String userId = '';
  String userName = '';

  // @override
  // void initState() {
  //   super.initState();
  //   _controller.callRefresh();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('折扣管理')),
        body: Column(
            children: [
              PostAddInputCell(
                  title: '客户',
                  value: userName,
                  hintText: '请选择客户',
                  endWidget: Icon(Icons.chevron_right),
                  onTap: () async {
                    StoreModel result = await Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SelectStorePage(forOrder: true, orderType: 1)));
                    userId = result.id;
                    userName = result.name;
                    _downloadData();
                  }
              ),
              _dataArray.length != 0 ?
              Expanded(
                  child: MyEasyRefreshSliverWidget(
                      controller: _controller,
                      scrollController: _scrollController,
                      dataCount: _dataArray.length,
                      onRefresh: null,
                      onLoad: _onLoad,
                      slivers: [
                        //列表
                        SliverList(
                            delegate: SliverChildBuilderDelegate((context, index) {
                              Map model = _dataArray[index];
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
                                  child: InkWell(
                                      child: Column(
                                          mainAxisSize:MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Row(
                                                    children: [
                                                      Image.asset('assets/images/icon_discount_management.png', width: 25, height: 25),
                                                      SizedBox(width: 10),
                                                      Text('${model['userName']}',style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))),
                                                    ]
                                                )
                                            ),
                                            SizedBox(height: 5),
                                            SizedBox(width: double.infinity, height: 1,
                                                child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFFF5F5F8)))),
                                            //标题头部
                                            Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('折扣总额: ${model['allTotal']}', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                                      SizedBox(height: 3),
                                                      Text('已兑付: ${model['already']}', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                                      SizedBox(height: 3),
                                                      Text('未兑付: ${model['total']}', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                                    ]
                                                )
                                            )
                                          ]
                                      ),
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder:(context)=> DiscountManagementDetail(data: model)));
                                      }
                                  )
                              );
                            }, childCount: _dataArray.length)),
                        SliverSafeArea(sliver: SliverToBoxAdapter()),
                      ])
              ):
              Visibility(
                visible: _dataArray.length == 0,
                child: Center(
                    child: GestureDetector(
                        onTap: () async {
                          StoreModel result = await Navigator.push(context,
                              MaterialPageRoute(builder: (_) => SelectStorePage(forOrder: true, orderType: 1)));
                          userId = result.id;
                          userName = result.name;
                          _downloadData();
                        },
                        child: Container(
                            margin: EdgeInsets.all(40),
                            child: Column(
                                children: [
                                  Image.asset('assets/images/icon_empty_images.png', width: 150, height: 150),
                                  SizedBox(height: 10),
                                  Text('请先选择客户后查看，请点击选择')
                                ]
                            )
                        )
                    )
                )
              )
            ]
        )
    );
  }

  Future<void> _refresh() async {
    _current = 1;
    _downloadData();
  }

  Future<void> _onLoad() async {
    _current++;
    _downloadData();
  }

  Future<void> _downloadData() async {
    try {
      Map<String, dynamic> map = {
        'userId': userId,
        'current': _current,
        'size': _pageSize
      };
      LogUtil.d(' map = $map');
      final val = await requestPost(Api.amountList, json: jsonEncode(map));
      LogUtil.d('amountList value = $val');
      var data = jsonDecode(val.toString());
      if (_current == 1) _dataArray.clear();
      final List<dynamic> list = data['data'];
      print(list.toString());
      list.forEach((map) {
        _dataArray.add(map as Map);
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
    super.dispose();
    _scrollController?.dispose();
    _controller?.dispose();
  }
}
