import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/work/visit_plan/visit_plan.dart';
import 'package:table_calendar/table_calendar.dart';

///签到统计
class SignInCensusPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<SignInCensusPage> {
  DateTime _selectedDay;
  DateTime _focusedDay = DateTime.now();
  ValueNotifier<List<Map>> _selectedMaps;
  int _count = 0;
  int _missing = 0;
  List<dynamic> _list = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('签到')),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          offset: Offset(2, 1),
                          blurRadius: 1.5)
                    ]),
                child: Column(
                  children: [
                    //顶部显示统计信息的视图
                    _TopCountWidget(
                      count: _count,
                      missing: _missing,
                      month: _focusedDay.month,
                    ),
                    TableCalendar(
                      focusedDay: _focusedDay,
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      currentDay: DateTime.now(),
                      locale: 'zh_CH',
                      calendarFormat: CalendarFormat.month,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      onDaySelected: _onDaySelected,
                      eventLoader: _getMapsForDay,
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                        _refresh();
                      },
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
                        todayTextStyle: const TextStyle(
                            color: AppColors.FFC68D3E, fontSize: 16.0),
                        //有事件的样式
                        markerDecoration: const BoxDecoration(
                            color: AppColors.FFC08A3F, shape: BoxShape.circle),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle:
                            const TextStyle(color: AppColors.FF959EB1),
                        weekendStyle:
                            const TextStyle(color: AppColors.FF959EB1),
                      ),
                      availableCalendarFormats: {
                        CalendarFormat.month: '',
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ValueListenableBuilder<List<Map>>(
                valueListenable: _selectedMaps,
                builder: (context, values, _) {
                  return Column(
                      children: List.generate(values.length, (index) {
                    Map event = values[index];
                    final time = event[
                        'time']; //'${event.time.hour < 10 ? '0' : ''}${event.time.hour}:${event.time.minute < 10 ? '0' : ''}${event.time.minute}:${event.time.second < 10 ? '0' : ''}${event.time.second}';
                    final address = event['address']; //event.title * 10;
                    return _SignInMapCell(time: time, address: address);
                  }));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _refresh() async {
    _selectedMaps = ValueNotifier(_getMapsForDay(_focusedDay));
    Map param = {
      'month': '${_focusedDay.year}-${AppUtil.dateForZero(_focusedDay.month)}'
    };
    try {
      final value = await requestPost(Api.signList, json: jsonEncode(param));
      LogUtil.d('value = $value');
      var result = jsonDecode(value.toString());
      var data = result['data'];
      int days = data['days'];
      _missing = data['wdays'];
      _count = days - _missing;
      List list = data['list'];
      // list.forEach((element) {
      //   _list.add(element);
      //   _list.add(element);
      // });
      _list = data['list'];
      if (mounted) setState(() {});
      _selectedMaps = ValueNotifier(_getMapsForDay(_focusedDay));
    } catch (error) {}
  }

  List<Map> _getMapsForDay(DateTime day) {
    if (_list.isEmpty) return [];
    List<String> dates = [];
    _list.forEach((map) {
      String createTime = map['signTime'];
      if (createTime != null && createTime.isNotEmpty) {
        List tl = createTime.split(' ');
        if (tl.isNotEmpty && !dates.contains(tl.first)) {
          dates.add(tl.first);
        }
      }
    });
    if (dates.isEmpty) return [];
    Map<DateTime, List<Map>> map1 = {};
    dates.forEach((date) {
      List events = _list
              .where((element) => element['signTime'].toString().contains(date))
              .toList() ??
          [];
      DateTime time = DateTime.parse(date);
      map1[time] = List.generate(events.length, (index) {
        Map map = events[index];
        String signTime = map['signTime'];
        DateTime time = DateTime.parse(signTime);
        return {
          'time':
              '${AppUtil.dateForZero(time.hour)}:${AppUtil.dateForZero(time.minute)}:${AppUtil.dateForZero(time.second)}',
          'address': map['address']
        };
      });
    });
    // _list.forEach((map) {
    //   String signTime = map['signTime'];
    //   DateTime time = DateTime.parse(signTime);
    //   map1[time] = [
    //     {
    //       'time':
    //           '${AppUtil.dateForZero(time.hour)}:${AppUtil.dateForZero(time.minute)}:${AppUtil.dateForZero(time.second)}',
    //       'address': map['address']
    //     }
    //   ];
    // });
    final map2 = LinkedHashMap<DateTime, List<Map>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(map1);
    return map2[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedMaps.value = _getMapsForDay(selectedDay);
    }
  }
}

///签到事件cell
class _SignInMapCell extends StatelessWidget {
  const _SignInMapCell({
    Key key,
    @required this.time,
    @required this.address,
  }) : super(key: key);

  final String time;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 15.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 10.0, top: 5),
              decoration: BoxDecoration(
                  color: AppColors.FFC68D3E,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.FFC68D3E.withOpacity(0.4),
                        offset: Offset(2, 1),
                        blurRadius: 1.5)
                  ]),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    '打卡时间 $time',
                    style: const TextStyle(
                        color: AppColors.FF2F4058, fontSize: 14.0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:5.0),
                      child: Image.asset('assets/images/sign_in_local2.png',
                          width: 12, height: 12),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: Text(address ?? '',
                          style: const TextStyle(
                              color: AppColors.FF959EB1, fontSize: 12.0)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

///顶部显示统计信息的视图
class _TopCountWidget extends StatelessWidget {
  const _TopCountWidget({
    Key key,
    @required int count,
    @required int missing,
    @required this.month,
  })  : _count = count,
        _missing = missing,
        super(key: key);

  final int _count;
  final int _missing;
  final int month;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: AppColors.FFCDA161,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: AppColors.FFC68D3E.withOpacity(0.3),
                offset: Offset(2, 1),
                blurRadius: 2.5)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$month月汇总',
              style: const TextStyle(color: Colors.white, fontSize: 16.0)),
          Padding(
            padding: const EdgeInsets.only(top: 18.0, bottom: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      _count.toString(),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 30.0),
                    ),
                    const Text(
                      '打卡(次)',
                      style: TextStyle(color: Colors.white, fontSize: 13.0),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      _missing.toString(),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 30.0),
                    ),
                    const Text(
                      '缺卡(次)',
                      style: TextStyle(color: Colors.white, fontSize: 13.0),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
