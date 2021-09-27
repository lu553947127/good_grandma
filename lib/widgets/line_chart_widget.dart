import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///折线图
class LineChartWidget extends StatelessWidget {
  const LineChartWidget({
    Key key,
    @required this.totalMap,
    @required this.targetMap,
    this.title = '',
    this.height = 290,
    this.width = double.infinity,
  }) : super(key: key);

  ///月份为key，数值为金额的map
  final Map<double, double> totalMap;
  final Map<double, double> targetMap;
  final String title;
  final double height;
  final double width;
  final Color _color1 = AppColors.FFC1C8D7;
  final Color _color2 = AppColors.FFE45C26;

  @override
  Widget build(BuildContext context) {
    /// !!Step2: convert data into a list of [FlSpot].
    final spots1 = <FlSpot>[
      for (final entry in totalMap.entries) FlSpot(entry.key, entry.value)
    ];
    final spots2 = <FlSpot>[
      for (final entry in targetMap.entries) FlSpot(entry.key, entry.value)
    ];

    /// !!Step3: prepare LineChartData
    /// !here we can set styles and behavior of the chart.
    final lineChartData = LineChartData(
      // The data to show.
      lineBarsData: [
        // ! Here we can style each data line.
        LineChartBarData(
          spots: spots1,
          colors: [_color2],
          barWidth: 2,
          isCurved: true,
          dotData: FlDotData(
            //节点
            show: true,
            getDotPainter: (FlSpot spot, double xPercentage,
                LineChartBarData bar, int index,
                {double size}) {
              return FlDotCirclePainter(
                radius: 3.5,
                color: Colors.white,
                strokeColor: _color2,
                strokeWidth: 2,
              );
            },
          ),
          // belowBarData: BarAreaData(show: false, colors: [_color2.withOpacity(0.4)]),
        ),
        LineChartBarData(
          spots: spots2,
          colors: [_color1],
          barWidth: 2,
          isCurved: true,
          dotData: FlDotData(
            //节点
            show: true,
            getDotPainter: (FlSpot spot, double xPercentage,
                LineChartBarData bar, int index,
                {double size}) {
              return FlDotCirclePainter(
                radius: 3.5,
                color: Colors.white,
                strokeColor: _color1,
                strokeWidth: 2,
              );
            },
          ),
          // belowBarData: BarAreaData(show: false, colors: [_color2.withOpacity(0.4)]),
        ),
      ],
      // ! Behavior when touching the chart:
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.yellow.withOpacity(0.8)),
        touchCallback:
            (FlTouchEvent touchEvent, LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      // ! Borders:
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: AppColors.FFEFEFF4, width: 1),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: AppColors.FFEFEFF4, width: 1),
        ),
      ),
      // ! Grid behavior:
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (double value) => FlLine(
            color: AppColors.FFEFEFF4, strokeWidth: 1, dashArray: [8, 0]),
        drawVerticalLine: false,
      ),
      // ! Axis title
      axisTitleData: FlAxisTitleData(
        show: true,
        bottomTitle: AxisTitle(titleText: title + '年度业绩折线图', showTitle: true),
        // leftTitle: AxisTitle(titleText: '金额（万元）', showTitle: true),
      ),
      // ! Ticks in the axis
      titlesData: FlTitlesData(
        show: true,
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true, // this is false by-default.
          // ! Decides how to show bottom titles,
          // here we convert double to month names
          getTitles: (double val) {
            //横坐标显示月份
            return '${val.toInt()}';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          //纵坐标文本宽度
          reservedSize: 28,
          // ! Decides how to show left titles,
          // here we skip some values by returning ''.
          getTitles: (double val) {
            //横坐标显示金额
            if (val.toInt() % 5 != 0) return '';
            return '${val.toInt()}';
          },
        ),
      ),
    );
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(
          left: 15.0, right: 30.0, top: 15.0, bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('金额（万元）'),
              Spacer(),
              Container(width: 22, height: 2, color: _color1),
              Text('目标业绩'),
              SizedBox(width: 20),
              Container(width: 22, height: 2, color: _color2),
              Text('完成业绩'),
            ],
          ),
          Container(
            height: height,
            width: width,
            padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
            child: LineChart(lineChartData),
          ),
        ],
      ),
    );
  }
}
