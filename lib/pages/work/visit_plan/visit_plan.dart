import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/pages/work/visit_plan/visit_plan_add.dart';
import 'package:good_grandma/pages/work/visit_plan/visit_plan_detail.dart';
import 'package:table_calendar/table_calendar.dart';

///拜访计划
class VisitPlan extends StatefulWidget {
  const VisitPlan({Key key}) : super(key: key);

  @override
  _VisitPlanState createState() => _VisitPlanState();
}

class _VisitPlanState extends State<VisitPlan> {

  DateTime _selectedDay;
  DateTime _focusedDay = DateTime.now();
  List<Map> visitPlanList = [];

  ///冰柜销量列表
  _visitPlanList(visitTime){
    LogUtil.d('请求结果---visitTime----$visitTime');
    Map<String, dynamic> map = {'visitTime': visitTime};
    requestGet(Api.visitPlanList, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---visitPlanList----$data');
      setState(() {
        visitPlanList = (data['data'] as List).cast();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _visitPlanList('${_focusedDay.year}-${_twoDigits(_focusedDay.month)}-${_focusedDay.day}');
    _selectedDay = _focusedDay;
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  ///点击日期刷新事件
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    print('_onDaySelected============${selectedDay.toString()}');
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }

    _visitPlanList('${selectedDay.year}-${_twoDigits(selectedDay.month)}-${selectedDay.day}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("拜访计划", style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
              child: TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                currentDay: DateTime.now(),
                locale: 'zh_CH',
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: _onDaySelected,
                // eventLoader: _getEventsForDay,
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                  print('focusedDay============${focusedDay.toString()}');
                },
                headerVisible: true,
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  leftChevronIcon: Image.asset('assets/images/icon_plan_left.png', width: 20, height: 20),
                  rightChevronIcon: Image.asset('assets/images/icon_plan_right.png', width: 20, height: 20),
                ),
                onFormatChanged: (format) {
                  print('onFormatChanged============${format.toString()}');
                },
                calendarStyle: CalendarStyle(
                  markersMaxCount: 1,
                  //选中的样式
                  selectedDecoration: const BoxDecoration(
                      color: AppColors.FFC68D3E, shape: BoxShape.circle),
                  //今天的样式
                  todayDecoration: const BoxDecoration(
                      color: AppColors.FFF2E8D7, shape: BoxShape.circle),
                  //今天文字的样式
                  todayTextStyle:
                  const TextStyle(color: AppColors.FFC68D3E, fontSize: 16.0),
                  //有事件的样式
                  markerDecoration: const BoxDecoration(
                      color: AppColors.FFC68D3E, shape: BoxShape.circle),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: const TextStyle(color: AppColors.FF959EB1),
                  weekendStyle: const TextStyle(color: AppColors.FF959EB1),
                ),
                availableCalendarFormats:{CalendarFormat.month: '',},
              ),
            ),
            Visibility(
              visible: visitPlanList.length > 0,
              child: const Divider(
                  color: AppColors.FFE7E7E7,
                  thickness: 0.5,
                  height: 10,
                  indent: 7.5,
                  endIndent: 7.5),
            ),
            visitPlanList.length > 0 ?
            ListView.builder(
              shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
              physics:NeverScrollableScrollPhysics(),//禁用滑动事件
              itemCount: visitPlanList.length,
              itemBuilder: (context, index){
                return Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ListTile(
                      title: Text(visitPlanList[index]['title'], style: const TextStyle(color: AppColors.FF2F4058,fontSize: 14.0)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(visitPlanList[index]['visitTime'], style: const TextStyle(color: AppColors.FF959EB1,fontSize: 12.0)),
                          SizedBox(height: 10),
                          Text(visitPlanList[index]['visitContent'], style: const TextStyle(color: AppColors.FF959EB1,fontSize: 12.0))
                        ],
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder:(context)=> VisitPlanDetail(
                          data: visitPlanList[index],
                        )));
                      },
                    )
                );
              },
            ) :
            Container(
                margin: EdgeInsets.all(40),
                child: Image.asset('assets/images/icon_empty_images.png', width: 150, height: 150)
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // FloatingActionButton(
            //   child: Text('今', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700)),
            //   backgroundColor: AppColors.FF959EB1,
            //   heroTag: 'other',
            //   onPressed: (){
            //
            //   }
            // ),
            // SizedBox(width: 10),
            FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: AppColors.FFC68D3E,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder:(context)=> VisitPlanAdd()));
              }
            )
          ]
        )
      )
    );
  }
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);