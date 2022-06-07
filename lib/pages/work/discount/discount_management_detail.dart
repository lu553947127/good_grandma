import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/pages/work/discount/discount_management_log.dart';
import 'package:good_grandma/widgets/submit_btn.dart';

///折扣管理详情
class DiscountManagementDetail extends StatefulWidget {
  final dynamic data;
  const DiscountManagementDetail({Key key, this.data}) : super(key: key);

  @override
  State<DiscountManagementDetail> createState() => _DiscountManagementDetailState();
}

class _DiscountManagementDetailState extends State<DiscountManagementDetail> {

  List<Map> amountDetailsList = [];

  @override
  void initState() {
    super.initState();
    _orderAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('折扣详细')),
        body: Container(
            child: SingleChildScrollView(
                child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                              children: [
                                Image.asset('assets/images/icon_discount_management.png', width: 25, height: 25),
                                SizedBox(width: 10),
                                Text('${widget.data['userName']}',style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))),
                              ]
                          )
                      ),
                      Container(
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
                                    Row(
                                        children: [
                                          Image.asset('assets/images/icon_discount_management2.png', width: 15, height: 15),
                                          SizedBox(width: 3),
                                          Text('折扣总额: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                          SizedBox(width: 3),
                                          Text('${widget.data['allTotal']}',style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                        ]
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                        children: [
                                          Image.asset('assets/images/icon_discount_management3.png', width: 15, height: 15),
                                          SizedBox(width: 3),
                                          Text('已兑付: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                          SizedBox(width: 3),
                                          Text('${widget.data['already']}',style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                        ]
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                        children: [
                                          Image.asset('assets/images/icon_discount_management4.png', width: 15, height: 15),
                                          SizedBox(width: 3),
                                          Text('未兑付: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                          SizedBox(width: 3),
                                          Text('${widget.data['total']}',style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                        ]
                                    )
                                  ]
                              )
                          )
                      ),
                      Container(
                          margin: EdgeInsets.all(20),
                          padding:EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(15.0))),
                          child: ListView.builder(
                            shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                            physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                            itemCount: amountDetailsList.length,
                            itemBuilder: (context, index){
                              Map model = amountDetailsList[index];
                              return Column(
                                children: [
                                  SizedBox(height: 15),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(model['typeStr'].toString().isEmpty ? '暂无' : model['typeStr'].toString(),
                                            style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),
                                        Text('${model['total']}',style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                                      ]
                                  ),
                                  SizedBox(height: 15),
                                  SizedBox(width: double.infinity, height: 1,
                                      child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFFF5F5F8))))
                                ]
                              );
                            }
                          )
                      ),
                      SubmitBtn(title: '日志', onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder:(context)=> DiscountManagementLog(data: widget.data)));
                      })
                    ]
                )
            )
        )
    );
  }

  ///补货金额明细
  Future<void> _orderAmount() async{
    Map<String, dynamic> map = {'userId': widget.data['userId']};
    requestPost(Api.amountDetails, formData: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---amountDetails----$data');
      amountDetailsList = (data['data'] as List).cast();
      if (mounted) setState(() {});
    });
  }
}
