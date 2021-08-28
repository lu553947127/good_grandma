import 'package:flutter/material.dart';
import 'package:good_grandma/pages/work/freezer_sales/freezer_sales_list.dart';
import 'package:good_grandma/pages/work/freezer_sales/freezer_sales_type.dart';

///冰柜销量
class FreezerSales extends StatefulWidget {
  const FreezerSales({Key key}) : super(key: key);

  @override
  _FreezerSalesState createState() => _FreezerSalesState();
}

class _FreezerSalesState extends State<FreezerSales> {

  List<Map> list = [
    {'title' : '冰柜编号: 11049901004577', 'region': '大区名称 / 山东省 / 济南市'
      ,'name' : '客户名称：高速石化济阳服务区', 'address' : '客户地址：济阳高速服务区','number' : '122223'},
    {'title' : '冰柜编号: 11049901004577', 'region': '大区名称 / 山东省 / 济南市'
      ,'name' : '客户名称：高速石化济阳服务区', 'address' : '客户地址：济阳高速服务区','number' : '123'},
    {'title' : '冰柜编号: 11049901004577', 'region': '大区名称 / 山东省 / 济南市'
      ,'name' : '客户名称：高速石化济阳服务区', 'address' : '客户地址：济阳高速服务区','number' : '123'},
    {'title' : '冰柜编号: 11049901004577', 'region': '大区名称 / 山东省 / 济南市'
      ,'name' : '客户名称：高速石化济阳服务区', 'address' : '客户地址：济阳高速服务区','number' : '123'},
    {'title' : '冰柜编号: 11049901004577', 'region': '大区名称 / 山东省 / 济南市'
      ,'name' : '客户名称：高速石化济阳服务区', 'address' : '客户地址：济阳高速服务区','number' : '123'},
   ];

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
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return FreezerSalesList(data: list[index]);
                }, childCount: list.length))
          ],
        ),
      ),
    );
  }
}
