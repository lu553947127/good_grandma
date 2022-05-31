import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/StoreModel.dart';
import 'package:good_grandma/pages/declaration_form/select_store_page.dart';
import 'package:good_grandma/pages/mine/invoice_add.dart';
import 'package:good_grandma/pages/mine/invoice_detail.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';

///发票管理
class InvoicePage extends StatefulWidget {
  final String userId;
  final int orderType;
  const InvoicePage({Key key, this.userId, this.orderType = 1}) : super(key: key);

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {

  List<dynamic> invoiceList = [];
  String userId = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    if (widget.userId.isNotEmpty){
      _invoiceList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('发票信息'),
            actions: [
              TextButton(
                  child: Text("添加", style: TextStyle(fontSize: 14, color: Color(0xFFC08A3F))),
                  onPressed: () async {
                    if (widget.userId.isEmpty && userId.isEmpty){
                      showToast('请先选择客户，再添加');
                      return;
                    }
                    bool needRefresh = await Navigator.push(context,
                        MaterialPageRoute(builder:(context)=> InvoiceAddPage(userId: widget.userId.isEmpty ? userId : widget.userId, data: null)));
                    if(needRefresh != null && needRefresh){
                      _invoiceList();
                    }
                  }
              )
            ]
        ),
        body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                  child: Visibility(
                      visible: widget.userId.isEmpty,
                      child: PostAddInputCell(
                          title: '客户',
                          value: userName,
                          hintText: '请选择客户',
                          endWidget: Icon(Icons.chevron_right),
                          onTap: () async {
                            StoreModel result = await Navigator.push(context,
                                MaterialPageRoute(builder: (_) => SelectStorePage(forOrder: true, orderType: widget.orderType)));
                            userId = result.id;
                            userName = result.name;
                            _invoiceList();
                          }
                      )
                  )
              ),
              invoiceList.length != 0 ?
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    Map model = invoiceList[index];
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset('assets/images/icon_invoice.png', width: 25, height: 25),
                                          SizedBox(width: 10),
                                          Text('${model['title']}',style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))),
                                        ]
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Color(0XFFFAEEEA), borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: Text('${model['titleType']}', style: TextStyle(fontSize: 10, color: Color(0XFFE45C26)))
                                      )
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
                                      Text('客户: ${model['corporate']}',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                      Text('税号: ${model['taxNo']}',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1)))
                                    ]
                                  )
                                ),
                                //标题头部
                                Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('收票人姓名: ${model['userName']}', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                          SizedBox(height: 3),
                                          Container(
                                            width: 200,
                                            child: Text('收票人电话: ${model['phone']}', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                          )
                                        ]
                                    )
                                )
                              ]
                            ),
                            onTap: () async{
                              if (widget.userId.isEmpty){
                                bool needRefresh = await Navigator.push(context,
                                    MaterialPageRoute(builder:(context)=> InvoiceDetail(data: model)));
                                if(needRefresh != null && needRefresh){
                                  _invoiceList();
                                }
                              }else {
                                Navigator.pop(context, model);
                              }
                            }
                        )
                    );
                  }, childCount: invoiceList.length)):
              SliverToBoxAdapter(
                  child: Center(
                      child: GestureDetector(
                          onTap: () async {
                            if (widget.userId.isEmpty && userId.isEmpty){
                              showToast('请先选择客户，再添加');
                              return;
                            }
                            bool needRefresh = await Navigator.push(context,
                                MaterialPageRoute(builder:(context)=> InvoiceAddPage(userId: widget.userId, data: null)));
                            if(needRefresh != null && needRefresh){
                              _invoiceList();
                            }
                          },
                          child: Container(
                              margin: EdgeInsets.all(40),
                              child: Column(
                                  children: [
                                    Image.asset('assets/images/icon_empty_images.png', width: 150, height: 150),
                                    SizedBox(height: 10),
                                    Text('还没有添加发票，请点击添加')
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

  ///发票信息列表
  Future<void> _invoiceList() async {
    Map<String, dynamic> map = {'userId': widget.userId.isEmpty ? userId : widget.userId};
    final val = await requestGet(Api.invoiceList, param: map);
    var data = jsonDecode(val.toString());
    LogUtil.d('请求结果---invoiceList----$data');
    invoiceList.clear();
    invoiceList = data['data'];
    if (mounted) setState(() {});
  }
}
