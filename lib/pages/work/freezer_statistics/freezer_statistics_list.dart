import 'package:flutter/material.dart';
import 'package:good_grandma/pages/work/freezer_statistics/freezer_statistics_detail.dart';

///冰柜统计列表
class FreezerStatisticsList extends StatelessWidget {
  var data;
  FreezerStatisticsList({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    _setTextColor(status){
      switch(status){
        case '正常':
          return Color(0xFF12BD95);
          break;
        case '损坏':
          return Color(0xFFDD0000);
          break;
        case '维修中':
          return Color(0xFFC08A3F);
          break;
        case '报废':
          return Color(0xFF999999);
          break;
      }
    }

    _setBgColor(status){
      switch(status){
        case '正常':
          return Color(0xFFE4F2F1);
          break;
        case '损坏':
          return Color(0xFFF1E1E2);
          break;
        case '维修中':
          return Color(0xFFF1EEEA);
          break;
        case '报废':
          return Color(0xFFEEEFF2);
          break;
      }
    }

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
                children: [
                  Image.asset('assets/images/icon_freezer_statistics.png', width: 25, height: 25),
                  SizedBox(width: 10),
                  Text('冰柜编号: ${data['code']}',style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              padding: EdgeInsets.only(left: 10.0),
              height: 40,
              color: Color(0XFFEFEFF4),
              child: Text('品牌/型号: ${data['brand']}/${data['model']}',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
            ),
            //标题头部
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 200,
                          child: Text('区域: ${data['deptName']}', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1)), maxLines: 2),
                        ),
                        SizedBox(height: 3),
                        Text('城市经理: ${data['managerName']}', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1)))
                      ]
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: data['status'] == 0 ? Color(0xFFF1EEEA) : Color(0xFFE4F2F1), borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(data['status'] == 0 ? '维修中' : '正常', style: TextStyle(fontSize: 10, color: data['status'] == 0 ? Color(0xFFC08A3F) : Color(0xFF12BD95))),
                          ),
                          SizedBox(height: 3),
                          Container(//openFreezer 0未开柜 1已开柜
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: data['openFreezer'] == 0 ? Color(0xFFEEEFF2) : Color(0XFFFAEEEA), borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(data['openFreezer'] == 0 ? '未开柜' : '已开柜', style: TextStyle(fontSize: 10, color: data['openFreezer'] == 0 ? Color(0xFF999999) : Color(0XFFE45C26))),
                          )
                        ]
                    )
                  ],
                )
            )
          ],
        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder:(context)=> FreezerStatisticsDetail(
            data: data,
          )));
        },
      ),
    );
  }
}
