import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/pages/work/market_material/market_material_add.dart';
import 'package:good_grandma/pages/work/market_material/market_material_detail.dart';
import 'package:good_grandma/widgets/custom_progress_circle.dart';

///市场物料
class MarketMaterial extends StatefulWidget {
  const MarketMaterial({Key key}) : super(key: key);

  @override
  _MarketMaterialState createState() => _MarketMaterialState();
}

class _MarketMaterialState extends State<MarketMaterial> {

  List<Map> list = [
    {'area' : '地区1', 'name': '物料名称物料名称物料','use' : 1, 'use_total' : 10,'stock' : 2
      ,'stock_total' : 10,'wastage' : 5,'wastage_total' : 10},
    {'area' : '地区1', 'name': '物料名称物料名称物料','use' : 1, 'use_total' : 10,'stock' : 2
      ,'stock_total' : 10,'wastage' : 5,'wastage_total' : 10},
    {'area' : '地区1', 'name': '物料名称物料名称物料','use' : 1, 'use_total' : 10,'stock' : 2
      ,'stock_total' : 10,'wastage' : 5,'wastage_total' : 10},
    {'area' : '地区1', 'name': '物料名称物料名称物料','use' : 1, 'use_total' : 10,'stock' : 2
      ,'stock_total' : 10,'wastage' : 5,'wastage_total' : 10},
    {'area' : '地区1', 'name': '物料名称物料名称物料','use' : 1, 'use_total' : 10,'stock' : 2
      ,'stock_total' : 10,'wastage' : 5,'wastage_total' : 10},
    {'area' : '地区1', 'name': '物料名称物料名称物料','use' : 1, 'use_total' : 10,'stock' : 2
      ,'stock_total' : 10,'wastage' : 5,'wastage_total' : 10},
    {'area' : '地区1', 'name': '物料名称物料名称物料','use' : 1, 'use_total' : 10,'stock' : 2
      ,'stock_total' : 10,'wastage' : 5,'wastage_total' : 10},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("市场物料",style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: Container(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index){
              return InkWell(
                child: Container(
                    margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                    padding: EdgeInsets.all(10.0),
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
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(list[index]['area'], style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                                SizedBox(height: 3),
                                Text(list[index]['name'], style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                              ]
                          ),
                          Row(
                              children: [
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CustomProgressCircle(
                                        size: 25,
                                        ratio: list[index]['use'] / list[index]['use_total'],
                                        color: Color(0XFF959EB1),
                                        width: 30,
                                        height: 30,
                                      ),
                                      Container(
                                        width: 30,
                                        child: Text('使用', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                      )
                                    ]
                                ),
                                SizedBox(width: 10),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CustomProgressCircle(
                                        size: 25,
                                        ratio: list[index]['stock'] / list[index]['stock_total'],
                                        color: Color(0XFF05A8C6),
                                        width: 30,
                                        height: 30,
                                      ),
                                      Container(
                                          width: 30,
                                          child: Text('库存', style: TextStyle(fontSize: 12, color: Color(0XFF05A8C6)))
                                      )
                                    ]
                                ),
                                SizedBox(width: 10),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CustomProgressCircle(
                                        size: 25,
                                        ratio: list[index]['wastage'] / list[index]['wastage_total'],
                                        color: Color(0XFFE45C26),
                                        width: 30,
                                        height: 30,
                                      ),
                                      Container(
                                          width: 30,
                                          child: Text('耗损', style: TextStyle(fontSize: 12, color: Color(0XFFE45C26)))
                                      )
                                    ]
                                )
                              ]
                          )
                        ]
                    )
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder:(context)=> MarketMaterialDetail()));
                }
              );
            },
          ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: AppColors.FFC68D3E,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder:(context)=> MarketMaterialAdd()));
        }
      ),
    );
  }
}