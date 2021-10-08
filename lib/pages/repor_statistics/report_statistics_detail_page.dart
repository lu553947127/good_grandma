import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/home_report_model.dart';
import 'package:good_grandma/pages/work/visit_plan/visit_plan.dart';
import 'package:good_grandma/widgets/home_report_cell.dart';
import 'package:table_calendar/table_calendar.dart';

///工作报告统计详细
class ReportStatisticsDetailPage extends StatefulWidget {
  const ReportStatisticsDetailPage(
      {Key key, @required this.id, @required this.name,this.avatar = ''})
      : super(key: key);
  final String id;
  final String name;
  final String avatar;

  @override
  _ReportStatisticsDetailPageState createState() =>
      _ReportStatisticsDetailPageState();
}

class _ReportStatisticsDetailPageState
    extends State<ReportStatisticsDetailPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  ValueNotifier<List<HomeReportModel>> _selectedMaps;
  List<dynamic> _list = [];
  CalendarFormat _currentFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name + '工作报告统计')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Scrollbar(
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
                  child: TableCalendar(
                    focusedDay: _focusedDay,
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    currentDay: DateTime.now(),
                    locale: 'zh_CH',
                    calendarFormat: _currentFormat,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: _onDaySelected,
                    eventLoader: _getHomeReportModelsForDay,
                    onPageChanged: (focusedDay) {
                      if(!isSameMonth(_focusedDay,focusedDay)) {
                        _focusedDay = focusedDay;
                        if(_currentFormat == CalendarFormat.twoWeeks)
                          _selectedDay = focusedDay;
                        // print('换月$_focusedDay');
                        _refresh();
                      }
                    },
                    // headerVisible: false,
                    onFormatChanged: (format) {
                      setState(() {
                        _currentFormat = format;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      //默认的样式
                      defaultDecoration: BoxDecoration(
                          border:
                              Border.all(color: AppColors.FFC1C8D7, width: 1),
                          borderRadius: BorderRadius.circular(4)),
                      //周末的样式
                      weekendDecoration: BoxDecoration(
                          border:
                              Border.all(color: AppColors.FFC1C8D7, width: 1),
                          borderRadius: BorderRadius.circular(4)),
                      //不可选中的样式
                      disabledDecoration: BoxDecoration(
                          border:
                              Border.all(color: AppColors.FFC1C8D7, width: 1),
                          borderRadius: BorderRadius.circular(4)),
                      //选中的样式
                      selectedDecoration: BoxDecoration(
                          border:
                              Border.all(color: AppColors.FFC68D3E, width: 1),
                          borderRadius: BorderRadius.circular(4)),
                      selectedTextStyle:
                          const TextStyle(color: AppColors.FFC68D3E),
                      outsideDecoration: BoxDecoration(
                          border:
                              Border.all(color: AppColors.FFC1C8D7, width: 1),
                          borderRadius: BorderRadius.circular(4)),
                      //今天的样式
                      todayDecoration: BoxDecoration(
                          border:
                              Border.all(color: AppColors.FFC1C8D7, width: 1),
                          borderRadius: BorderRadius.circular(4)),
                      //今天文字的样式
                      todayTextStyle:
                          const TextStyle(color: AppColors.FFC68D3E),
                      //有事件的样式
                      markerDecoration: const BoxDecoration(
                          color: AppColors.FFC08A3F, shape: BoxShape.circle),
                      markerSize: 4,
                      markersMaxCount: 3,
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: const TextStyle(color: AppColors.FF959EB1),
                      weekendStyle: const TextStyle(color: AppColors.FF959EB1),
                    ),
                    availableCalendarFormats: {
                      CalendarFormat.month: '显示月',
                      CalendarFormat.twoWeeks: '显示两周',
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ValueListenableBuilder<List<HomeReportModel>>(
                  valueListenable: _selectedMaps,
                  builder: (context, values, _) {
                    return Column(
                      children: List.generate(values.length, (index) {
                        HomeReportModel model = values[index];
                        return HomeReportCell(model: model);
                        // return ReportStatisticsDetailCell(model: model);
                      }),
                    );
                  },
                ),
              ),
              SliverSafeArea(sliver: SliverToBoxAdapter()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    _selectedMaps = ValueNotifier([]);
    try {
      _list = await _requestDataList('${_focusedDay.year}-${AppUtil.dateForZero(_focusedDay.month)}');
      if (mounted) setState(() {});
      _selectedMaps = ValueNotifier(_getHomeReportModelsForDay(_focusedDay));
    } catch (error) {}
  }

  List<HomeReportModel> _getHomeReportModelsForDay(DateTime day) {
    if (_list.isEmpty) return [];
    List<String> dates = [];
    _list.forEach((map) {
      String createTime = map['createTime'];
      if (createTime != null && createTime.isNotEmpty) {
        List tl = createTime.split(' ');
        if(tl.isNotEmpty && !dates.contains(tl.first)) {
          dates.add(tl.first);
        }
      }
    });
    if(dates.isEmpty) return [];
    Map<DateTime, List<HomeReportModel>> map1 = {};
    dates.forEach((date) {
      List events = _list.where((element) => element['createTime'].toString().contains(date)).toList() ?? [];
      DateTime time = DateTime.parse(date);
      map1[time] = List.generate(events.length, (index) {
        HomeReportModel model = HomeReportModel.fromJson(events[index]);
        if(widget.avatar.isNotEmpty)
          model.avatar = widget.avatar;
        return model;
      });
    });
    final map2 = LinkedHashMap<DateTime, List<HomeReportModel>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(map1);
    return map2[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async{
    if(!isSameMonth(_selectedDay,selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _refresh();
      return;
    }
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedMaps.value = _getHomeReportModelsForDay(selectedDay);
    }
  }

  bool isSameMonth(DateTime a, DateTime b) {
    if (a == null || b == null) {
      return false;
    }

    return a.year == b.year && a.month == b.month;
  }

  ///获取详情页数据
  /// "reportDate":"2021-09"查询当月 "reportDate":"2021-09-10"查询当日
  Future<List> _requestDataList(String date) async{
    Map param = {
      'reportDate': date,
      'createUser': widget.id
    };
    // print('param = ${jsonEncode(param)}');
    final value =
    await requestPost(Api.reportTjDetail, json: jsonEncode(param));
    LogUtil.d('reportTjDetail value = $value');
    var result = jsonDecode(value.toString());
    var data = result['data'];
    List list = data['list'] ?? [];
    return list;
  }
}
