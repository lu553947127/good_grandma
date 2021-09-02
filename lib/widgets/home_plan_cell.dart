import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:table_calendar/table_calendar.dart';

///拜访计划
class HomePlanCell extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlanCellState();
}

class _PlanCellState extends State<HomePlanCell> {
  DateTime _selectedDay;
  DateTime _focusedDay = DateTime.now();
  ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _refresh();
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
              eventLoader: _getEventsForDay,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
                _refresh();
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
              availableCalendarFormats:{CalendarFormat.week: '',},
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
                  list.add(ListTile(
                    leading: Text('${event.time.hour}:${event.time.minute}',style: const TextStyle(color: AppColors.FF959EB1,fontSize: 14.0)),
                    title: Text(event.title,style: const TextStyle(color: AppColors.FF2F4058,fontSize: 14.0)),
                    subtitle: Text(event.content,style: const TextStyle(color: AppColors.FF959EB1,fontSize: 12.0)),
                  ));
                }
                return Column(children: list);
              },
            ),
          ],
        ),
      ),
    );
  }
  void _refresh() {
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
    if(mounted)
      setState(() {});
  }

  List<Event> _getEventsForDay(DateTime day) {
    List<Event> valueList = List.generate(3, (index) {
      return Event(
          title: 'Today\'s Event 1',
          content: 'content ' * 30,
          time: DateTime.utc(kFirstDay.year, kFirstDay.month, 5, kToday.hour,
              kToday.minute, kToday.second));
    });
    Map<DateTime, List<Event>> map = {
      DateTime.utc(_selectedDay.year,_selectedDay.month,1):valueList,
      DateTime.utc(_selectedDay.year,_selectedDay.month,3):valueList,
      DateTime.utc(_selectedDay.year,_selectedDay.month,5):valueList,
      DateTime.utc(_selectedDay.year,_selectedDay.month,12):valueList,
      DateTime.utc(_selectedDay.year,_selectedDay.month,13):valueList,
      DateTime.utc(_selectedDay.year,_selectedDay.month,15):valueList,
      DateTime.utc(_selectedDay.year,_selectedDay.month,21):valueList,
      DateTime.utc(_selectedDay.year,_selectedDay.month,23):valueList,
      DateTime.utc(_selectedDay.year,_selectedDay.month,25):valueList,
    };
    final map1 = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(map);

    return map1[day] ?? [];
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
// final kEvents = LinkedHashMap<DateTime, List<Event>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(_kEventSource);

// final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
//     key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
//     value: (item) => List.generate(
//         item % 4 + 1,
//         (index) => Event(
//             title: 'Event $item | ${index + 1}',
//             content: 'content $item | ${index + 1}',
//             time: DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5,
//                 kToday.hour, kToday.minute, kToday.second))))
//   ..addAll({
//     kToday: [
//       Event(
//           title: 'Today\'s Event 1',
//           content: 'content ' * 30,
//           time: DateTime.utc(kFirstDay.year, kFirstDay.month, 5, kToday.hour,
//               kToday.minute, kToday.second)),
//       Event(
//           title: 'Today\'s Event 2',
//           content: 'content ' * 30,
//           time: DateTime.utc(kFirstDay.year, kFirstDay.month, 5, kToday.hour,
//               kToday.minute, kToday.second)),
//     ],
//   });
int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
