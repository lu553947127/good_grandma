import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///柱状图
class BarChartWidget extends StatelessWidget {
  const BarChartWidget({
    Key key,
    @required this.targetMap,
    @required this.totalMap,
    this.title = '',
    this.height = 300,
    this.width = double.infinity,
  }) : super(key: key);

  ///年份为key，数值为金额的map
  final Map<double, double> targetMap;
  final Map<double, double> totalMap;
  final String title;
  final double height;
  final double width;
  final Color _color1 = AppColors.FFC1C8D7;
  final Color _color2 = AppColors.FFE45C26;

  @override
  Widget build(BuildContext context) {
    /// !!Step2: convert data into barGroups.
    final barGroups = <BarChartGroupData>[
      for (final entry in targetMap.entries)
        BarChartGroupData(
          x: entry.key.toInt(),
          barRods: [
            BarChartRodData(y: entry.value, colors: [_color1]),
            BarChartRodData(y: totalMap[entry.key], colors: [_color2]),
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
      axisTitleData: FlAxisTitleData(
        show: true,
        bottomTitle: AxisTitle(titleText: '年度业绩柱状图', showTitle: true),
        // leftTitle: AxisTitle(titleText: 'Sales', showTitle: true),
      ),
      // ! Ticks in the axis
      titlesData: FlTitlesData(
        show: true,
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true, // this is false by-default.
          //横坐标 年
          getTitles: (double val) {
            return '${val.toInt()}' + '季度';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          //纵坐标文本宽度
          reservedSize:28,
          // ! Decides how to show left titles,
          // here we skip some values by returning ''.
          getTitles: (double val) {
            if (val.toInt() % 5 != 0) return '';
            return '${val.toInt()}';
          },
        ),
      ),
    );
    return Container(
      padding: const EdgeInsets.only(
          left: 15.0, right: 30.0, top: 15.0, bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('金额（万元）'),
              Spacer(),
              Container(
                width: 22,
                height: 12,
                decoration: BoxDecoration(
                    color: _color1,
                    borderRadius: BorderRadius.circular(12 / 2)),
              ),
              Text('目标业绩'),
              SizedBox(
                width: 20,
              ),
              Container(
                width: 22,
                height: 12,
                decoration: BoxDecoration(
                    color: _color2,
                    borderRadius: BorderRadius.circular(12 / 2)),
              ),
              Text('完成业绩'),
            ],
          ),
          Container(
            height: height,
            width: width,
            padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
            child: BarChart(barChartData),
          ),
        ],
      ),
    );
  }
}
