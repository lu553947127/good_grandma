import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/pages/order/freezer_order/freezer_order_add.dart';
import 'package:good_grandma/pages/order/freezer_order/freezer_order_detail.dart';
import 'package:good_grandma/pages/order/freezer_order/freezer_order_model.dart';
import 'package:provider/provider.dart';

///冰柜订单页面
class FreezerOrderPage extends StatefulWidget {
  const FreezerOrderPage({Key key}) : super(key: key);

  @override
  _FreezerOrderPageState createState() => _FreezerOrderPageState();
}

class _FreezerOrderPageState extends State<FreezerOrderPage> {

  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();

  int _current = 1;
  int _pageSize = 10;
  List<Map> freezerOrderList = [];

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {

    _setTextStatus(status){
      switch(status){
        case 0:
          return '驳回';
          break;
        case 1:
          return '审批中';
          break;
        case 2:
          return '发货中';
          break;
        case 3:
          return '收货完成';
          break;
      }
    }

    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text("冰柜订单", style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700))
        ),
        body: MyEasyRefreshSliverWidget(
            controller: _controller,
            scrollController: _scrollController,
            dataCount: freezerOrderList.length,
            onRefresh: _refresh,
            onLoad: _onLoad,
            slivers: [
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Container(
                        margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                        padding: const EdgeInsets.all(5.0),
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
                        child: ListTile(
                            title: Column(
                                mainAxisSize:MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(freezerOrderList[index]['customerName'], style: TextStyle(fontSize: 14, color: Color(0XFFE45C26))),
                                              SizedBox(height: 10),
                                              Text(freezerOrderList[index]['createTime'], style: TextStyle(fontSize: 12, color: Color(0XFF959EB1)))
                                            ]
                                        ),
                                        Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFF1E1E2), borderRadius: BorderRadius.circular(3),
                                            ),
                                            child: Text(_setTextStatus(freezerOrderList[index]['status']),
                                                style: TextStyle(fontSize: 10, color: Color(0xFFDD0000)))
                                        )
                                      ]
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 1,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(color: Color(0xFFEFEFF4)),
                                      )
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                      margin: EdgeInsets.only(top: 2),
                                      child: Row(
                                          children: [
                                            Text('联系人: ',style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                                            SizedBox(width: 10),
                                            Text(freezerOrderList[index]['linkName'], style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                                          ]
                                      )
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: 2),
                                      child: Row(
                                          children: [
                                            Text('联系电话: ',style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                                            SizedBox(width: 10),
                                            Text(freezerOrderList[index]['linkPhone'], style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                                          ]
                                      )
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: 2),
                                      child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('收货地址: ',style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                                            SizedBox(width: 10),
                                            Container(
                                              width: 200,
                                              child: Text(freezerOrderList[index]['address'], style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                            )
                                          ]
                                      )
                                  )
                                ]
                            ),
                            onTap: () async {
                              bool needRefresh = await Navigator.push(context,
                                  MaterialPageRoute(builder:(context)=> FreezerOrderDetail(data: freezerOrderList[index])));
                              if(needRefresh != null && needRefresh){
                                _controller.callRefresh();
                              }
                            }
                        )
                    );
                  }, childCount: freezerOrderList.length)),
            ]
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: AppColors.FFC68D3E,
            onPressed: () async {
              FreezerOrderModel model = FreezerOrderModel();
              bool needRefresh = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                      ChangeNotifierProvider<FreezerOrderModel>.value(
                        value: model,
                        child: FreezerOrderAddPage(id: '', data: null),
                      )));
              if(needRefresh != null && needRefresh){
                _controller.callRefresh();
              }
            }
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

  ///冰柜订单列表
  Future<void> _downloadData() async {
    try {
      Map<String, dynamic> map = {'current': _current, 'size': _pageSize};
      final val = await requestGet(Api.freezerOrderList, param: map);
      var data = jsonDecode(val.toString());
      LogUtil.d('请求结果---freezerOrderList----$data');
      if (_current == 1) freezerOrderList.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        freezerOrderList.add(map);
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
