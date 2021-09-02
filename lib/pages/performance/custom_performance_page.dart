import 'package:flutter/material.dart';
import 'package:good_grandma/widgets/bar_chart_widget.dart';
import 'package:good_grandma/widgets/line_chart_widget.dart';
import 'package:good_grandma/widgets/statistics_head_widget.dart';

class CustomPerformancePage extends StatefulWidget {
  const CustomPerformancePage(
      {Key key, @required this.id, @required this.name})
      : super(key: key);
  final String id;
  final String name;

  @override
  _CustomPerformancePageState createState() => _CustomPerformancePageState();
}

class _CustomPerformancePageState extends State<CustomPerformancePage> {
  String _position = '';
  double _target = 0;
  double _current = 0;
  /// !!Step1: prepare the data to plot. 月份为key，数值为金额
  Map<double, double> _data1 = <double, double>{};
  Map<double, double> _data2 = <double, double>{};
  Map<double, double> _data3 = <double, double>{};
  @override
  void initState() {
    super.initState();
    _refresh();
  }
  @override
  Widget build(BuildContext context) {
    Widget titleView = Text.rich(TextSpan(
        text: widget.name + '  ',
        style: const TextStyle(
            color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
        children: [
          TextSpan(
              text: _position,
              style: const TextStyle(fontSize: 12.0)
          )
        ]));
    bool showRightArrow = false;
    return Scaffold(
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            StatisticsHeadWidget(
                titleView: titleView,
                title: widget.name + '业绩',
                target: _target,
                current: _current,
                showRightArrow: showRightArrow),
            SliverToBoxAdapter(child: LineChartWidget(dataMap: _data1)),
            SliverToBoxAdapter(child: BarChartWidget(dataMap1: _data2, dataMap2: _data3)),
            SliverSafeArea(sliver: SliverToBoxAdapter())
          ],
        ),
      ),
    );
  }
  void _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _position = '业务经理';
    _target = 500000.0;
    _current = 50000.0;
    //月份为key，数值为金额的map
    _data1 = <double, double>{
      1: 10,
      2: 15,
      3: 20,
      4: 28,
      5: 34,
      6: 50,
      7: 53,
      8: 57,
      9: 60,
      10: 70,
      11: 80,
      12: 50
    };
    _data2 = <double, double>{2017: 90, 2018: 120, 2019: 170, 2020: 200, 2021: 140};
    _data3 = <double, double>{2017: 80, 2018: 15, 2019: 170, 2020: 110, 2021: 130};
    if (mounted) setState(() {});
  }
}
