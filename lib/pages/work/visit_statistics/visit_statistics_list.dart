import 'package:flutter/material.dart';
import 'package:good_grandma/pages/work/visit_statistics/visit_statistics_detail.dart';

///拜访统计列表
class VisitStatisticsList extends StatelessWidget {
  var data;
  VisitStatisticsList({Key key, this.data}) : super(key: key);

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

    return Container(
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
      child: InkWell(
        child: Column(
          mainAxisSize:MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 0.5,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFEFEFF4)),
              ),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['name'], style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                SizedBox(height: 3),
                Text(data['time'], style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                SizedBox(height: 3),
                Text(data['customer'], style: TextStyle(fontSize: 12, color: Color(0XFF959EB1)))
              ],
            )
          ],
        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder:(context)=> VisitStatisticsDetail(
            data: data,
          )));
        },
      ),
    );
  }
}