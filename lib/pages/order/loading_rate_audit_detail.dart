import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/widgets/marketing_activity_msg_cell.dart';

///装车率审核详情
class LoadingRateAuditDetail extends StatefulWidget {
  final String id;
  const LoadingRateAuditDetail({Key key, this.id}) : super(key: key);

  @override
  State<LoadingRateAuditDetail> createState() => _LoadingRateAuditDetailState();
}

class _LoadingRateAuditDetailState extends State<LoadingRateAuditDetail> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  ///是否显示审核按钮
  bool financeFlag = false;
  ///标题
  String title = '';
  ///警告信息
  String warning = '';
  ///订单列表
  List<dynamic> orderList = [];

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('装车率审核')),
      body: Stack(
        children: [
          MyEasyRefreshSliverWidget(
              controller: _controller,
              scrollController: _scrollController,
              dataCount: orderList.length,
              onRefresh: _orderFinanceCarDetails,
              onLoad: null,
              slivers: [
                SliverToBoxAdapter(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(2, 1), //x,y轴
                                  color: Colors.black.withOpacity(0.1), //投影颜色
                                  blurRadius: 1 //投影距离
                              )
                            ]),
                        child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('$title',style: TextStyle(fontSize: 14, color: Color(0XFF333333))),
                                  SizedBox(height: 5),
                                  Visibility(
                                    visible: warning.isNotEmpty,
                                    child: Text('$warning',style: TextStyle(fontSize: 12, color: Color(0xFFDD0000))),
                                  )
                                ]
                            )
                        )
                    )
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      Map model = orderList[index];
                      List<dynamic> amountList = orderList[index]['amountArr'];
                      List<dynamic> detailList = orderList[index]['detailedArr'];
                      List<dynamic> moneyList = orderList[index]['moneyArr'];
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(width: 280, child: Text('${model['title']}', style: TextStyle(fontSize: 15))),
                                          SizedBox(height: 5.0),
                                          Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(color: Color(0xFFFAEEEA), borderRadius: BorderRadius.circular(3)),
                                              child: Text('${model['status']}', style: TextStyle(fontSize: 10, color: Color(0xFFE45C26)))
                                          )
                                        ]
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          if (orderList[index]['opened'] == 'true'){
                                            model['opened'] = 'false';
                                            orderList.setAll(index, [model]);
                                          }else {
                                            model['opened'] = 'true';
                                            orderList.setAll(index, [model]);
                                          }
                                          setState(() {});
                                        },
                                        icon: Icon(orderList[index]['opened'] == 'true'
                                            ? Icons.keyboard_arrow_up_outlined
                                            : Icons.keyboard_arrow_down_outlined))
                                  ],
                                )
                            ),
                            Visibility(
                                visible: orderList[index]['opened'] == 'true',
                                child: Container(
                                    margin: EdgeInsets.all(15.0),
                                    child: Column(
                                        children: [
                                          MarketingActivityMsgCell(title: '订单编号', value: '${model['code']}'),
                                          MarketingActivityMsgCell(title: '下单人员', value: '${model['createUser']}'),
                                          MarketingActivityMsgCell(title: '订单日期', value: '${model['createTime']}'),
                                          MarketingActivityMsgCell(title: '业务经理', value: '${model['cityUser']}'),
                                          MarketingActivityMsgCell(title: '发票类型', value: '${model['invoiceType']}'),
                                          MarketingActivityMsgCell(title: '开票信息', value: '${model['invoiceStr']}'),
                                          MarketingActivityMsgCell(title: '所属大区', value: '${model['area']}'),
                                          MarketingActivityMsgCell(title: '所属省', value: '${model['pro']}'),
                                          MarketingActivityMsgCell(title: '所属城市', value: '${model['city']}'),
                                          MarketingActivityMsgCell(title: '客户名称', value: '${model['cusName']}'),
                                          MarketingActivityMsgCell(title: '联系电话', value: '${model['cusPhone']}'),
                                          MarketingActivityMsgCell(title: '收货地址', value: '${model['address']}'),
                                          MarketingActivityMsgCell(title: '订单类型', value: '${model['orderType']}'),
                                          MarketingActivityMsgCell(title: '配送方式', value: '${model['selfMentionStr']}'),
                                          MarketingActivityMsgCell(title: '是否拼车', value: '${model['carpool']}'),
                                          MarketingActivityMsgCell(title: '拼车码', value: '${model['carpoolCode']}'),
                                          MarketingActivityMsgCell(title: '子公司', value: '${model['company']}'),
                                          Container(
                                              margin: EdgeInsets.only(top: 10.0),
                                              padding: EdgeInsets.only(top: 10.0),
                                              decoration: new BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: new BorderRadius.circular((5.0))
                                              ),
                                            child: GridView.builder(
                                                shrinkWrap: true,//为true可以解决子控件必须设置高度的问题
                                                physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                                                padding: EdgeInsets.zero,
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    childAspectRatio: 3.0,
                                                    crossAxisSpacing: 2,
                                                    mainAxisSpacing: 2),
                                                itemCount: amountList.length,
                                                itemBuilder: (context, index) {
                                                  Map model = amountList[index];
                                                  return Center(
                                                      child: Column(
                                                          children: [
                                                            Text(model['name'].toString().isEmpty ? '暂无' : model['name'].toString()),
                                                            SizedBox(height: 5),
                                                            Text('${model['total']}',
                                                                style: TextStyle(fontSize: 13, color: Color(0XFFE45C26)))
                                                          ]
                                                      )
                                                  );
                                                }
                                            )
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(top: 10.0),
                                              padding: EdgeInsets.only(top: 10.0, bottom: 25.0),
                                              decoration: new BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: new BorderRadius.circular((5.0))
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                      margin: EdgeInsets.only(top: 15.0),
                                                      child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            Text('商品名称/规格', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                                            Text('单价', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                                            Text('数量', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                                            Text('商品总价', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1)))
                                                          ]
                                                      )
                                                  ),
                                                  ListView.builder(
                                                      shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                                                      physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                                                      itemCount: detailList.length,
                                                      itemBuilder: (context, index){
                                                        return Container(
                                                            margin: EdgeInsets.only(top: 15.0),
                                                            child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  Text('${detailList[index]['name']}', style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                                                  Text('${detailList[index]['retail']}', style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                                                  Text('${detailList[index]['count']}', style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                                                  Text('${detailList[index]['total']}', style: TextStyle(fontSize: 12, color: Color(0XFF2F4058)))
                                                                ]
                                                            )
                                                        );
                                                      }
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                                                      padding: EdgeInsets.only(top: 10.0),
                                                      decoration: new BoxDecoration(
                                                          color: Color(0XFFF8F9FC),
                                                          borderRadius: new BorderRadius.circular((5.0))
                                                      ),
                                                      child: GridView.builder(
                                                          shrinkWrap: true,//为true可以解决子控件必须设置高度的问题
                                                          physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                                                          padding: EdgeInsets.zero,
                                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 2,
                                                              childAspectRatio: 3.0,
                                                              crossAxisSpacing: 2,
                                                              mainAxisSpacing: 2),
                                                          itemCount: moneyList.length,
                                                          itemBuilder: (context, index) {
                                                            Map model = moneyList[index];
                                                            return Center(
                                                                child: Column(
                                                                    children: [
                                                                      Text(model['name'].toString().isEmpty ? '暂无' : model['name'].toString()),
                                                                      SizedBox(height: 5),
                                                                      Text('${model['total']}',
                                                                          style: TextStyle(fontSize: 13, color: Color(0XFFE45C26)))
                                                                    ]
                                                                )
                                                            );
                                                          }
                                                      )
                                                  )
                                                ]
                                              )
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(top: 10.0),
                                              padding: EdgeInsets.all(10.0),
                                              decoration: new BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: new BorderRadius.circular((5.0))
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('商品数量'), Text('${model['count']}件')]),
                                                  SizedBox(height: 5.0),
                                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('销售净额'), Text('${model['total']}元')]),
                                                  SizedBox(height: 5.0),
                                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('订单总额'), Text('${model['allTotal']}元')])
                                                ]
                                              )
                                          )
                                        ]
                                    )
                                )
                            )
                          ]
                      );
                    }, childCount: orderList.length)
                ),
                SliverToBoxAdapter(child:  SizedBox(height: 55))
              ]
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Visibility(
                visible: financeFlag,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(2, 1), //x,y轴
                              color: Colors.black.withOpacity(0.1), //投影颜色
                              blurRadius: 1 //投影距离
                          )
                        ]),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              child: Column(
                                  children: [
                                    Image.asset('assets/images/icon_examine_reject.png', width: 15, height: 15),
                                    SizedBox(height: 3),
                                    Text('驳回', style: TextStyle(fontSize: 13, color: Color(0XFFDD0000)))
                                  ]
                              ),
                              onPressed: () async {
                                _orderFinanceCar(context, '8');
                              }
                          ),
                          TextButton(
                              child: Column(
                                  children: [
                                    Image.asset('assets/images/icon_examine_adopt.png', width: 15, height: 15),
                                    SizedBox(height: 3),
                                    Text('通过', style: TextStyle(fontSize: 13, color: Color(0XFF12BD95)))
                                  ]
                              ),
                              onPressed: () async{
                                _orderFinanceCar(context, '3');
                              }
                          )
                        ]
                    )
                )
              )
          )
        ]
      )
    );
  }

  ///装车率审核详情
  Future<void> _orderFinanceCarDetails() async{
    try {
      Map<String, dynamic> map = {'id': widget.id};
      requestPost(Api.orderFinanceCarDetails, formData: map).then((val) async{
        var data = json.decode(val.toString());
        LogUtil.d('请求结果---orderFinanceCarDetails----$data');
        financeFlag = data['data']['financeFlag'];
        title = data['data']['title'];
        warning = data['data']['warning'];
        orderList = (data['data']['orderArr'] as List).cast();
        _controller.finishRefresh(success: true);
        if (mounted) setState(() {});
      });
    } catch (error) {
      _controller.finishRefresh(success: false);
    }
  }

  ///装车率审核或驳回
  void _orderFinanceCar(BuildContext context, String status) async {
    Map<String, dynamic> map = {'id': widget.id, 'status': status};
    LogUtil.d('orderFinanceCar map = $map');
    requestPost(Api.orderFinanceCar, formData: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---orderFinanceCar----$data');
      if (data['code'] == 200){
        showToast('成功');
        Navigator.pop(context, true);
      }else {
        showToast(data['msg']);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
    _controller?.dispose();
  }
}
