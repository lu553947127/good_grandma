import 'package:flutter/material.dart';

class VisitStatisticsDetail extends StatelessWidget {
  var data;
  VisitStatisticsDetail({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    _setTextColor(status){
      switch(status){
        case '未开始':
          return Color(0xFFE45C26);
          break;
        case '进行中':
          return Color(0xFF05A8C6);
          break;
        case '已结束':
          return Color(0xFFC1C8D7);
          break;
      }
    }

    _setBgColor(status){
      switch(status){
        case '未开始':
          return Color(0xFFFAEEEA);
          break;
        case '进行中':
          return Color(0xFFE9F5F8);
          break;
        case '已结束':
          return Color(0xFFF4F5F7);
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("冰柜详细",style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/images/icon_visit_statistics.png', width: 25, height: 25),
                      SizedBox(width: 10),
                      Text(data['title'],style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: _setBgColor(data['status']), borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(data['status'], style: TextStyle(fontSize: 10, color: _setTextColor(data['status']))),
                  )
                ],
              ),
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
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset('assets/images/icon_visit_statistics_name.png', width: 15, height: 15),
                                    SizedBox(width: 3),
                                    Text('拜访人: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                    SizedBox(width: 3),
                                    Text('张三',style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Image.asset('assets/images/icon_visit_statistics_time.png', width: 15, height: 15),
                                    SizedBox(width: 3),
                                    Text('拜访日期: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                    SizedBox(width: 3),
                                    Text('2021年7月20日 周二 11：00 - 12：00',style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Image.asset('assets/images/icon_visit_statistics_custom.png', width: 15, height: 15),
                                    SizedBox(width: 3),
                                    Text('拜访客户: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                    SizedBox(width: 3),
                                    Text('客户名称',style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Image.asset('assets/images/icon_visit_statistics_address.png', width: 15, height: 15),
                                    SizedBox(width: 3),
                                    Text('客户地址: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                    SizedBox(width: 3),
                                    Text('山东省济南市历城区',style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                  ],
                                )
                              ]
                          )
                        ]
                    )
                )
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("备注", style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),
                  SizedBox(height: 10),
                  Text("拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内",
                      style: TextStyle(fontSize: 14, color: Color(0XFF2F4058)))
                ],
              ),
            )
          ]
        )
      )
    );
  }
}
