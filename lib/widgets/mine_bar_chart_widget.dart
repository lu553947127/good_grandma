import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///柱状图
class MineBarChartWidget extends StatelessWidget {
  const MineBarChartWidget({
    Key key,
    @required this.dataMap1,
    @required this.dataMap2,
    this.title = '',
    this.height = 300,
    this.width = double.infinity,
  }) : super(key: key);

  ///年份为key，数值为金额的map
  final Map<double, double> dataMap1;
  final Map<double, double> dataMap2;
  final String title;
  final double height;
  final double width;
  final Color _color1 = AppColors.FFE45C26;

  @override
  Widget build(BuildContext context) {
    final barChartData1 = _getNarChartDataWith(dataMap1,'季度');
    final barChartData2 = _getNarChartDataWith(dataMap2,'年');
    final _tabPages = <Widget>[
      Container(
          height: height,
          width: width,
          padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
          child: BarChart(barChartData1)),
      Container(
          height: height,
          width: width,
          padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
          child: BarChart(barChartData2)),
    ];
    final _tabs = <Tab>[
      Tab(text: '季度业绩'),
      Tab(text: '年度业绩'),
    ];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(
          left: 15.0, right: 30.0, top: 15.0, bottom: 15.0),
      child: DefaultTabController(
        length: _tabs.length,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('金额（万元）',
                    style: const TextStyle(
                        color: AppColors.FF959EB1, fontSize: 12.0)),
                Spacer(),
                Container(
                    width: 170,
                    height: 50,
                    child: TabBar(
                      tabs: _tabs,
                      indicatorColor: AppColors.FFE45C26,
                      indicatorPadding:
                          const EdgeInsets.symmetric(horizontal: 30.0),
                      indicatorWeight: 2.0,
                      unselectedLabelColor: AppColors.FF959EB1,
                      labelColor: AppColors.FFE45C26,
                      labelStyle: const TextStyle(fontSize: 12.0),
                      // indicatorSize: TabBarIndicatorSize(0,0),
                    )),
              ],
            ),
            Container(
                width: width,
                height: height,
                child: TabBarView(children: _tabPages)),
          ],
        ),
      ),
    );
  }

  BarChartData _getNarChartDataWith(Map<double, double> dataMap,String unit) {
    /// !!Step2: convert data into barGroups.
    final barGroups = <BarChartGroupData>[
      for (final entry in dataMap.entries)
        BarChartGroupData(
          x: entry.key.toInt(),
          barRods: [
            BarChartRodData(y: entry.value, colors: [_color1]),
          ],
        ),
    ];

    /// !!Step3: prepare barChartData
    final barChartData = BarChartData(
      // ! The data to show
      barGroups: barGroups,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.yellow.withOpacity(0.8),
        ),
      ),
      // ! Borders:
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: AppColors.FFC1C8D7, width: 1),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: AppColors.FFC1C8D7, width: 1),
        ),
      ),
      // ! Grid behavior:
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (double value) => FlLine(
            color: AppColors.FFC1C8D7, strokeWidth: 1, dashArray: [8, 0]),
        drawVerticalLine: false,
      ),
      // ! Axis title
      axisTitleData: FlAxisTitleData(show: false),
      // ! Ticks in the axis
      titlesData: FlTitlesData(
        show: true,
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true, // this is false by-default.
          //横坐标
          getTitles: (double val) {
            return '${val.toInt()}' + unit;
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          //纵坐标文本宽度
          reservedSize: 28,
          // ! Decides how to show left titles,
          // here we skip some values by returning ''.
          getTitles: (double val) {
            if (val.toInt() % 5 != 0) return '';
            return '${val.toInt()}';
          },
        ),
      ),
    );
    return barChartData;
  }
}
