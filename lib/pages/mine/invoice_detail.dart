import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/mine/invoice_add.dart';
import 'package:good_grandma/widgets/submit_btn.dart';

///发票详情
class InvoiceDetail extends StatefulWidget {
  final dynamic data;
  const InvoiceDetail({Key key, this.data}) : super(key: key);

  @override
  State<InvoiceDetail> createState() => _InvoiceDetailState();
}

class _InvoiceDetailState extends State<InvoiceDetail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('发票详细'),
            actions: [
              TextButton(
                  child: Text("编辑", style: TextStyle(fontSize: 14, color: Color(0xFFC08A3F))),
                  onPressed: () async {
                    bool needRefresh = await Navigator.push(context,
                        MaterialPageRoute(builder:(context)=> InvoiceAddPage(userId: widget.data['userId'], data: widget.data)));
                    if(needRefresh != null && needRefresh){
                      Navigator.pop(context, true);
                    }
                  }
              )
            ]
        ),
        body: Container(
            child: SingleChildScrollView(
                child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                  children: [
                                    Image.asset('assets/images/icon_invoice.png', width: 25, height: 25),
                                    SizedBox(width: 10),
                                    Text('${widget.data['title']}',style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))),
                                  ]
                              ),
                              Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Color(0XFFFAEEEA), borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text('${widget.data['titleType']}', style: TextStyle(fontSize: 10, color: Color(0XFFE45C26)))
                              )
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
                                          Image.asset('assets/images/icon_invoice2.png', width: 15, height: 15),
                                          SizedBox(width: 3),
                                          Text('客户: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                          SizedBox(width: 3),
                                          Text('${widget.data['corporate']}',style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                        ]
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                        children: [
                                          Image.asset('assets/images/icon_invoice3.png', width: 15, height: 15),
                                          SizedBox(width: 3),
                                          Text('税号: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                          SizedBox(width: 3),
                                          Text('${widget.data['taxNo']}',style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
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
                          child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('收票人姓名',style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),
                                    Text('${widget.data['userName']}',style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                                  ]
                                ),
                                SizedBox(height: 15),
                                SizedBox(
                                    width: double.infinity,
                                    height: 1,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                                    )
                                ),
                                SizedBox(height: 15),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('收票人电话',style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),
                                      Text('${widget.data['phone']}',style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                                    ]
                                ),
                                SizedBox(height: 15),
                                SizedBox(
                                    width: double.infinity,
                                    height: 1,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                                    )
                                ),
                                SizedBox(height: 15),
                                Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('收票人地址',style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),
                                      Text('${widget.data['address']}',style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                                    ]
                                ),
                                SizedBox(height: 15),
                                SizedBox(
                                    width: double.infinity,
                                    height: 1,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                                    )
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('开户行',style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),
                                    Text('${widget.data['bank']}',style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                                  ]
                                ),
                                SizedBox(height: 15),
                                SizedBox(
                                    width: double.infinity,
                                    height: 1,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                                    )
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('开户行账号',style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),
                                    Text('${widget.data['card']}',style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                                  ]
                                ),
                              ]
                          )
                      ),
                      SubmitBtn(title: '删除', onPressed: () {
                        _invoiceRemove();
                      })
                    ]
                )
            )
        )
    );
  }

  ///发票信息删除
  Future<void> _invoiceRemove() async {
    Map<String, dynamic> map = {'id': widget.data['id']};
    final val = await requestGet(Api.invoiceRemove, param: map);
    var data = jsonDecode(val.toString());
    LogUtil.d('请求结果---invoiceRemove----$data');
    if (data['code'] == 200){
      Navigator.pop(context, true);
    }else {
      showToast(data['msg']);
    }
    if (mounted) setState(() {});
  }
}
