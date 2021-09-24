import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/pages/work/visit_plan/visit_plan_detail.dart';
import 'package:table_calendar/table_calendar.dart';

///拜访计划
class HomePlanCell extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlanCellState();
}

class _PlanCellState extends State<HomePlanCell> {
  DateTime _selectedDay;
  DateTime _focusedDay = DateTime.now();
  List<Map> visitPlanList = [];

  ///冰柜销量列表
  _visitPlanList(visitTime){
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 17.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                  offset: Offset(2, 1), //x,y轴
                  color: Colors.black.withOpacity(0.1), //投影颜色
                  blurRadius: 1 //投影距离
                  )
            ]),
        child: Column(
          children: [
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              currentDay: DateTime.now(),
              locale: 'zh_CH',
              calendarFormat: CalendarFormat.week,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: _onDaySelected,
              // eventLoader: _getEventsForDay,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              headerVisible: false,
              onFormatChanged: (format) {},
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
              availableCalendarFormats:{CalendarFormat.week: ''}
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
            visitPlanList.length >= 1 ?
            ListView.builder(
              shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
              physics:NeverScrollableScrollPhysics(),//禁用滑动事件
              itemCount: 1,
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
            Container()
          ]
        )
      )
    );
  }
}
