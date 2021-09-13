import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/pages/work/freezer_sales/freezer_sales_list.dart';
import 'package:good_grandma/pages/work/freezer_sales/freezer_sales_type.dart';

///冰柜销量
class FreezerSales extends StatefulWidget {
  const FreezerSales({Key key}) : super(key: key);

  @override
  _FreezerSalesState createState() => _FreezerSalesState();
}

class _FreezerSalesState extends State<FreezerSales> {

  List<Map> freezerSalesList = [];

  ///冰柜销量列表
  _freezerSalesList(){
    Map<String, dynamic> map = {'current': '1', 'size': '999'};
    requestGet(Api.freezerSalesList, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---freezerSalesList----$data');
      setState(() {
        freezerSalesList = (data['data'] as List).cast();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _freezerSalesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("冰柜销量",style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: CustomScrollView(
          slivers: [
            FreezerSalesType(
              selEmpBtnOnTap: (selEmployees) {},
            ),
            freezerSalesList.length > 0 ?
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return FreezerSalesList(data: freezerSalesList[index]);
                }, childCount: freezerSalesList.length)) :
            SliverToBoxAdapter(
                child: Container(
                    margin: EdgeInsets.all(40),
                    child: Image.asset('assets/images/icon_empty_images.png', width: 150, height: 150)
                )
            )
          ],
        ),
      ),
    );
  }
}
