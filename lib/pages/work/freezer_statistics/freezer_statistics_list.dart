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
        case 0://正常
          return Color(0xFF12BD95);
          break;
        case 1://维修中
          return Color(0xFFC08A3F);
          break;
        case 2://报废
          return Color(0xFF999999);
          break;
      }
    }

    _setBgColor(status){
      switch(status){
        case 0://正常
          return Color(0xFFE4F2F1);
          break;
        case 1://维修中
          return Color(0xFFF1EEEA);
          break;
        case 2://报废
          return Color(0xFFEEEFF2);
          break;
      }
    }

    _setStatus(status){
      switch(status){
        case 0:
          return '正常';
          break;
        case 1:
          return '维修中';
          break;
        case 2:
          return '报废';
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
                              color: _setBgColor(data['status']), borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(_setStatus(data['status']), style: TextStyle(fontSize: 10, color: _setTextColor(data['status']))),
                          ),
                          SizedBox(height: 3),
                          Container(//openFreezer 0未开柜 1已开柜
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: data['useing'] == 0 ? Color(0xFFEEEFF2) : Color(0XFFFAEEEA), borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(data['useing'] == 0 ? '未开柜' : '已开柜', style: TextStyle(fontSize: 10, color: data['useing'] == 0 ? Color(0xFF999999) : Color(0XFFE45C26))),
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
        }
      )
    );
  }
}
