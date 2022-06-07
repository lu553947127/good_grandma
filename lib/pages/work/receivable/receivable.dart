import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/StoreModel.dart';
import 'package:good_grandma/pages/declaration_form/select_store_page.dart';
import 'package:good_grandma/pages/stock/select_customer_page.dart';
import 'package:good_grandma/pages/work/freezer_statistics/freezer_statistics_type.dart';

///应收明细页面
class ReceivableDetail extends StatefulWidget {
  const ReceivableDetail({Key key}) : super(key: key);

  @override
  State<ReceivableDetail> createState() => _ReceivableDetailState();
}

class _ReceivableDetailState extends State<ReceivableDetail> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  int _current = 1;
  int _pageSize = 10;

  String customerId = '';
  String customerName = '客户';
  String subId = '';
  String subName = '帐套';
  String time = '所有日期';
  String startDate = '';
  String endDate = '';

  List<Map> receivableList = [];

  // @override
  // void initState() {
  //   super.initState();
  //   _controller.callRefresh();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('应收明细账')),
        body: Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Column(
                children: [
                  FreezerStatisticsType(
                      areaName: customerName,
                      customerName: subName,
                      statusName: time,
                      onPressed: () async{
                        StoreModel result = await Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SelectStorePage(forOrder: true, orderType: 1)));
                        customerId = result.id;
                        customerName = result.name;
                        if (mounted) setState(() {});
                        if (subId.isNotEmpty){
                          _downloadData();
                        }else {
                          showToast('请选择帐套');
                        }
                      },
                      onPressed2: () async{
                        Map select = await showSelectSearchList(context, Api.subsidiaryList, '请选择帐套', 'name');
                        subId = select['id'];
                        subName = select['name'];
                        if (mounted) setState(() {});
                        if (customerId.isNotEmpty){
                          _downloadData();
                        }else {
                          showToast('请选择客户');
                        }
                      },
                      onPressed3: () async {
                        showPickerDateRangeNew(
                            context: Application.appContext,
                            callBack: (Map param){
                              time = '${param['startTime'] + '\n' + param['endTime']}';
                              startDate = param['startTime'];
                              endDate = param['endTime'];
                              if (mounted) setState(() {});
                              if (customerId.isNotEmpty && subId.isNotEmpty){
                                _downloadData();
                              }else {
                                showToast('请选择客户和帐套');
                              }
                            }
                        );
                      }
                  ),
                  receivableList.length != 0 ?
                  Expanded(
                      child: MyEasyRefreshSliverWidget(
                          controller: _controller,
                          scrollController: _scrollController,
                          dataCount: receivableList.length,
                          onRefresh: null,
                          onLoad: _onLoad,
                          slivers: [
                            SliverList(
                                delegate: SliverChildBuilderDelegate((context, index) {
                                  Map model = receivableList[index];
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
                                          mainAxisSize:MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('${model['partnerName']}',style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))),
                                                      SizedBox(height: 3),
                                                      Text('${model['voucherDate']}',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1)))
                                                    ]
                                                )
                                            ),
                                            Container(
                                                alignment: Alignment.centerLeft,
                                                width: double.infinity,
                                                padding: EdgeInsets.all(10.0),
                                                color: Color(0XFFEFEFF4),
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('单据类型/编号：${model['voucherTypeName']}/${model['voucherCode']}',
                                                          style: TextStyle(fontSize: 12, color: Color(0XFF959EB1)))
                                                    ]
                                                )
                                            ),
                                            //标题头部
                                            Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('应收: ${model['origAmount']}', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                                      SizedBox(height: 3),
                                                      Text('已收: ${model['origSettleAmount']}', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                                      SizedBox(height: 3),
                                                      Text('余额: ${model['origBalanceAmount']}', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                                      SizedBox(height: 3),
                                                      Text('备注: ${model['memo']}', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                                    ]
                                                )
                                            )
                                          ]
                                      )
                                  );
                                }, childCount: receivableList.length))
                          ]
                      )
                  ):
                  Center(
                      child: GestureDetector(
                          onTap: null,
                          child: Container(
                              margin: EdgeInsets.all(40),
                              child: Column(
                                  children: [
                                    Image.asset('assets/images/icon_empty_images.png', width: 150, height: 150),
                                    SizedBox(height: 10),
                                    Text('请先选择客户和帐套再查看明细')
                                  ]
                              )
                          )
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

  ///应收明细列表
  Future<void> _downloadData() async {
    try {
      Map<String, dynamic> map = {
        'id': customerId,
        'subId': subId,
        'periodBegin': startDate,
        'periodEnd': endDate,
        'current': _current,
        'size': _pageSize
      };
      LogUtil.d('请求结果---map----$map');
      final val = await requestPost(Api.receivableList, json: jsonEncode(map));
      var data = jsonDecode(val.toString());
      LogUtil.d('请求结果---receivableList----$data');
      if (_current == 1) receivableList.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        receivableList.add(map);
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
