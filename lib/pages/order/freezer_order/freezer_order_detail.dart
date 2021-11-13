import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/order/freezer_order/freezer_order_add.dart';
import 'package:good_grandma/pages/order/freezer_order/freezer_order_model.dart';
import 'package:good_grandma/widgets/marketing_activity_msg_cell.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///冰柜订单详情
class FreezerOrderDetail extends StatelessWidget {
  final dynamic data;
  const FreezerOrderDetail({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Map> freezerOrderDetailList = (data['freezerOrderDetail'] as List).cast();

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
        case 4:
          return '取消订单';
          break;
      }
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("冰柜订单详细", style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
        ),
        body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                  child: Container(
                      padding: const EdgeInsets.all(15.0),
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
                      child: Column(
                          mainAxisSize:MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(data['customerName'], style: TextStyle(fontSize: 14, color: Color(0XFFE45C26))),
                                        SizedBox(height: 10),
                                        Text(data['createTime'], style: TextStyle(fontSize: 12, color: Color(0XFF959EB1)))
                                      ]
                                  ),
                                  Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF1E1E2), borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Text(_setTextStatus(data['status']),
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
                                      Text(data['linkName'], style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                                    ]
                                )
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 2),
                                child: Row(
                                    children: [
                                      Text('联系电话: ',style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                                      SizedBox(width: 10),
                                      Text(data['linkPhone'], style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
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
                                        child: Text(data['address'], style: TextStyle(fontSize: 12,color: Color(0XFF2F4058))),
                                      )
                                    ]
                                )
                            )
                          ]
                      )
                  )
              ),
              PostDetailGroupTitle(color: AppColors.FFC08A3F, name: '冰柜'),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(
                      margin: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            MarketingActivityMsgCell(title: '品牌', value: freezerOrderDetailList[index]['brandName']),
                            MarketingActivityMsgCell(title: '型号规格', value: freezerOrderDetailList[index]['modelName']),
                            MarketingActivityMsgCell(title: '长押数量', value: freezerOrderDetailList[index]['longCount'].toString()),
                            MarketingActivityMsgCell(title: '反押数量', value: freezerOrderDetailList[index]['returnCount'].toString())
                          ]
                      )
                  );
                }, childCount: freezerOrderDetailList.length),
              ),
              SliverSafeArea(
                  sliver: SliverToBoxAdapter(
                      child: Visibility(
                          visible: data['status'] == 2 ? true : false,
                          child: SubmitBtn(
                              vertical: 5.0,
                              title: '确认收货',
                              onPressed: () {
                                _freezerOrderOver(context);
                              }
                          )
                      )
                  )
              ),
              SliverSafeArea(
                  sliver: SliverToBoxAdapter(
                      child: Visibility(
                          visible: data['status'] == 0 ? true : false,
                          child: SubmitBtn(
                              vertical: 5.0,
                              title: '取消订单',
                              onPressed: () {
                                _freezerOrderCancel(context);
                              }
                          )
                      )
                  )
              ),
              SliverSafeArea(
                  sliver: SliverToBoxAdapter(
                      child: Visibility(
                          visible: data['status'] == 0 ? true : false,
                          child: SubmitBtn(
                              vertical: 5.0,
                              title: '编辑',
                              onPressed: () async {
                                FreezerOrderModel model = FreezerOrderModel();
                                bool needRefresh = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                        ChangeNotifierProvider<FreezerOrderModel>.value(
                                          value: model,
                                          child: FreezerOrderAddPage(id: data['id'], data: data),
                                        )));
                                if(needRefresh != null && needRefresh){
                                  Navigator.pop(context, true);
                                }
                              }
                          )
                      )
                  )
              )
            ]
        )
    );
  }

  ///确认收货
  void _freezerOrderOver(BuildContext context) async {
    Map<String, dynamic> map = {'id': data['id']};
    requestGet(Api.freezerOrderOver, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---freezerOrderOver----$data');
      if (data['code'] == 200){
        showToast("成功");
        Navigator.pop(context, true);
      }else {
        showToast(data['msg']);
      }
    });
  }

  ///取消订单
  void _freezerOrderCancel(BuildContext context) async {
    Map<String, dynamic> map = {'id': data['id']};
    requestGet(Api.freezerOrderCancel, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---freezerOrderCancel----$data');
      if (data['code'] == 200){
        showToast("成功");
        Navigator.pop(context, true);
      }else {
        showToast(data['msg']);
      }
    });
  }
}
