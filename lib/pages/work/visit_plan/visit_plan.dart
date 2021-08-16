import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
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
  ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
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
        title: Text("拜访计划",style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: Stack(
        children: [
          Column(
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
                  eventLoader: _getEventsForDay,
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
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
                visible: _getEventsForDay(_selectedDay).length > 0,
                child: const Divider(
                    color: AppColors.FFE7E7E7,
                    thickness: 0.5,
                    height: 10,
                    indent: 7.5,
                    endIndent: 7.5),
              ),
              ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, values, _) {
                  List<Widget> list = [];
                  for (Event event in values) {
                    list.add(Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Stack(
                        children: [
                          ListTile(
                            title: Text(event.title,style: const TextStyle(color: AppColors.FF2F4058,fontSize: 14.0)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text('${event.time.hour}:${event.time.minute}',style: const TextStyle(color: AppColors.FF959EB1,fontSize: 12.0)),
                                SizedBox(height: 10),
                                Text(event.content,style: const TextStyle(color: AppColors.FF959EB1,fontSize: 12.0))
                              ],
                            ),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder:(context)=> VisitPlanDetail()));
                            },
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              margin: EdgeInsets.all(5),
                              width: 37,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: AppColors.FF05A8C6,
                                  borderRadius: BorderRadius.circular(2.5),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(2, 1),
                                      color: AppColors.FF05A8C6.withOpacity(0.4),
                                      blurRadius: 1.5,
                                    ),
                                  ]),
                              child: Center(
                                  child: Text('进行中',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 11.0))),
                            ),
                          )
                        ],
                      ),
                    ));
                  }
                  return Column(children: list);
                },
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              margin: EdgeInsets.all(20),
              child: Row(
                children: [
                  FloatingActionButton(
                    child: Icon(Icons.add_task_rounded),
                    backgroundColor: AppColors.FF959EB1,
                    onPressed: (){

                    },
                  ),
                  SizedBox(width: 10),
                  FloatingActionButton(
                    child: Icon(Icons.add),
                    backgroundColor: AppColors.FFC68D3E,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder:(context)=> VisitPlanAdd()));
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// Example event class.
class Event {
  final String title;
  final String content;
  final DateTime time;

  const Event({this.title, this.content, this.time});

  @override
  String toString() => '{\"title\":$title,\"content\":$content,\"time\":$time}';
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(
        item % 4 + 1,
            (index) => Event(
            title: 'Event $item | ${index + 1}',
            content: 'content $item | ${index + 1}',
            time: DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5,
                kToday.hour, kToday.minute, kToday.second))))
  ..addAll({
    kToday: [
      Event(
          title: 'Today\'s Event 1',
          content: 'content ' * 30,
          time: DateTime.utc(kFirstDay.year, kFirstDay.month, 5, kToday.hour,
              kToday.minute, kToday.second)),
      Event(
          title: 'Today\'s Event 2',
          content: 'content ' * 30,
          time: DateTime.utc(kFirstDay.year, kFirstDay.month, 5, kToday.hour,
              kToday.minute, kToday.second)),
    ],
  });
int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);