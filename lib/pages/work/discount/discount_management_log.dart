import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';

///折扣详细日志
class DiscountManagementLog extends StatefulWidget {
  final dynamic data;
  const DiscountManagementLog({Key key, this.data}) : super(key: key);

  @override
  State<DiscountManagementLog> createState() => _DiscountManagementLogState();
}

class _DiscountManagementLogState extends State<DiscountManagementLog> {

  List<Map> amountLogs = [];

  @override
  void initState() {
    super.initState();
    _amountLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('日志')),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: Container(margin: EdgeInsets.all(15.0), child: Text('${widget.data['userName']}'))),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  Map model = amountLogs[index];
                  return Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(5.0),
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
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(model['createTime']),
                              Text(model['direction'] == 1 ? '入' : '出', style: TextStyle(fontSize: 12, color: model['direction'] == 1 ?
                              Color(0XFF12BD95) : Color(0XFFE45C26), fontWeight: FontWeight.w700)),
                            ]
                        ),
                        SizedBox(height: 10),
                        //分割线
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
                                  Text('费用来源: ',style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                                  SizedBox(width: 10),
                                  Text('${model['source'] == 1 ? 'OA' : model['source'] == 2 ? '手工' : '订单'}',style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                                ]
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 2),
                            child: Row(
                                children: [
                                  Text('费用类型: ',style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                                  SizedBox(width: 10),
                                  Text('${model['type']}',style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                                ]
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 2),
                            child: Row(
                                children: [
                                  Text('费用金额: ',style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                                  SizedBox(width: 10),
                                  Text('${model['total']}',style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                                ]
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 2),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('备注: ',style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                                  SizedBox(width: 10),
                                  Container(
                                      width: 280,
                                      child: Text('${model['remarks']}',style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                                  )
                                ]
                            )
                        ),
                      ],
                    ),
                  );
                }, childCount: amountLogs.length)),
          ],
        )
    );
  }

  ///获取补货金额明细日志
  Future<void> _amountLogs() async {
    Map<String, dynamic> map = {'userId': widget.data['userId']};
    requestPost(Api.amountLogs, formData: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---amountLogs----$data');
      amountLogs = (data['data'] as List).cast();
      if (mounted) setState(() {});
    });
  }
}
