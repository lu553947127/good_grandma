import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/day_post_add_model.dart';
import 'package:good_grandma/pages/work/visit_plan/visit_plan.dart';
import 'package:good_grandma/widgets/report_statistics_detail_cell.dart';
import 'package:table_calendar/table_calendar.dart';

///工作报告统计详细
class ReportStatisticsDetailPage extends StatefulWidget {
  const ReportStatisticsDetailPage(
      {Key key, @required this.id, @required this.name})
      : super(key: key);
  final String id;
  final String name;

  @override
  _ReportStatisticsDetailPageState createState() =>
      _ReportStatisticsDetailPageState();
}

class _ReportStatisticsDetailPageState
    extends State<ReportStatisticsDetailPage> {
  DateTime _selectedDay;
  DateTime _focusedDay = DateTime.now();
  ValueNotifier<List<DayPostAddModel>> _selectedDayPostAddModels = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name + '工作报告统计')),
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
                child: TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  currentDay: DateTime.now(),
                  locale: 'zh_CH',
                  calendarFormat: CalendarFormat.month,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: _onDaySelected,
                  eventLoader: _getDayPostAddModelsForDay,
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                    // print('换月$_focusedDay');
                    _refresh();
                  },
                  // headerVisible: false,
                  onFormatChanged: (format) {},
                  calendarStyle: CalendarStyle(
                    //默认的样式
                    defaultDecoration: BoxDecoration(
                        border: Border.all(color: AppColors.FFC1C8D7, width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    //周末的样式
                    weekendDecoration: BoxDecoration(
                        border: Border.all(color: AppColors.FFC1C8D7, width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    //不可选中的样式
                    disabledDecoration: BoxDecoration(
                        border: Border.all(color: AppColors.FFC1C8D7, width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    //选中的样式
                    selectedDecoration: BoxDecoration(
                        border: Border.all(color: AppColors.FFC68D3E, width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    selectedTextStyle:
                        const TextStyle(color: AppColors.FFC68D3E),
                    outsideDecoration: BoxDecoration(
                        border: Border.all(color: AppColors.FFC1C8D7, width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    //今天的样式
                    todayDecoration: BoxDecoration(
                        border: Border.all(color: AppColors.FFC1C8D7, width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    //今天文字的样式
                    todayTextStyle: const TextStyle(color: AppColors.FFC68D3E),
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
                    CalendarFormat.month: '',
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ValueListenableBuilder<List<DayPostAddModel>>(
                valueListenable: _selectedDayPostAddModels,
                builder: (context, values, _) {
                  return Column(
                    children: List.generate(values.length, (index) {
                      DayPostAddModel model = values[index];
                      return ReportStatisticsDetailCell(model: model,);
                    }),
                  );
                },
              ),
            ),
            SliverSafeArea(sliver: SliverToBoxAdapter()),
          ],
        ),
      ),
    );
  }

  void _refresh() {
    _selectedDay = _focusedDay;
    _selectedDayPostAddModels = ValueNotifier(_getDayPostAddModelsForDay(_selectedDay));
    if(mounted)
      setState(() {});
  }

  List<DayPostAddModel> _getDayPostAddModelsForDay(DateTime day) {
    List<DayPostAddModel> valueList = List.generate(3, (index) {
      DayPostAddModel model = DayPostAddModel();
      model.type = index + 1;
      model.setSummaries([
        '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
        '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
        '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
        '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
      ]);
      model.setPlans([
        '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
        '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
        '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
        '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
      ]);
      model.setTarget('123456');
      model.setCumulative('12345');
      return model;
    });
    Map<DateTime, List<DayPostAddModel>> map = {
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
    final map1 = LinkedHashMap<DateTime, List<DayPostAddModel>>(
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

      _selectedDayPostAddModels.value = _getDayPostAddModelsForDay(selectedDay);
      // _selectedDayPostAddModels.clear();
      // _selectedDayPostAddModels.addAll(_getDayPostAddModelsForDay(selectedDay));
    }
  }
}
