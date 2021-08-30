import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:good_grandma/pages/work/market_material/market_material_add.dart';
import 'package:good_grandma/widgets/post_progress_view.dart';

///物料详细
class MarketMaterialDetail extends StatefulWidget {
  const MarketMaterialDetail({Key key}) : super(key: key);

  @override
  _MarketMaterialDetailState createState() => _MarketMaterialDetailState();
}

class _MarketMaterialDetailState extends State<MarketMaterialDetail> {

  List<Map> list = [
    {'name' : '总量', 'number': '10000.0', 'current': '1'},
    {'name' : '已使用', 'number': '5000.0', 'current': '0.25'},
    {'name' : '库存', 'number': '4900.0', 'current': '0.22'},
    {'name' : '耗损', 'number': '100.0', 'current': '0.1'},
  ];

  _setTextColor(status){
    switch(status){
      case '总量':
        return Color(0xFFC08A3F);
        break;
      case '已使用':
        return Color(0xFF959EB1);
        break;
      case '库存':
        return Color(0xFF05A8C6);
        break;
      case '耗损':
        return Color(0xFFE45C26);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("物料详细",style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
        actions: [
          TextButton(
              child: Text("编辑", style: TextStyle(fontSize: 14, color: Color(0xFFC08A3F))),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder:(context)=> MarketMaterialAdd()));
              }
          )
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('地区1',style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                    SizedBox(height: 5),
                    Text('物料名称物料名称物料名称物料名称物料名称物料名称物料名称物料名称物料名称物料名称物料名称物料名称'
                        ,style: TextStyle(fontSize: 12, color: Color(0XFFC1C8D7))),
                  ]
                )
              ),
              ListView.builder(
                  shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                  physics:NeverScrollableScrollPhysics(),//禁止滚动
                  itemCount: list.length,
                  itemBuilder: (context, index){
                    return Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(list[index]['name'], style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),
                              Text('${list[index]['number']}',style: TextStyle(fontSize: 12, color: _setTextColor(list[index]['name'])))
                            ]
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: 5.0,
                            width: double.infinity,
                            // 圆角矩形剪裁（`ClipRRect`）组件，使用圆角矩形剪辑其子项的组件。
                            child: ClipRRect(
                              // 边界半径（`borderRadius`）属性，圆角的边界半径。
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              child: LinearProgressIndicator(
                                value: double.parse(list[index]['current']),
                                backgroundColor: _setTextColor(list[index]['name']).withOpacity(0.6),
                                valueColor: AlwaysStoppedAnimation<Color>(_setTextColor(list[index]['name'])),
                              ),
                            ),
                          )
                        ]
                      )
                    );
                  }
              )
            ]
          )
        )
      )
    );
  }
}
