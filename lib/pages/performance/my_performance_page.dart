import 'package:flutter/material.dart';
import 'package:good_grandma/widgets/bar_chart_widget.dart';
import 'package:good_grandma/widgets/line_chart_widget.dart';

///我的业绩
class MyPerformancePage extends StatefulWidget {
  const MyPerformancePage({Key key}) : super(key: key);

  @override
  _MyPerformancePageState createState() => _MyPerformancePageState();
}

class _MyPerformancePageState extends State<MyPerformancePage> {
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
    return Scaffold(
      appBar: AppBar(title: const Text('我的业绩')),
      body: Scrollbar(
        child: ListView(
          children: [
            LineChartWidget(dataMap: _data1),
            BarChartWidget(dataMap1: _data2, dataMap2: _data3),
          ],
        ),
      ),
    );
  }

  void _refresh() async {
    await Future.delayed(Duration(seconds: 1));
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
    _data2 = <double, double>{2017: 9, 2018: 12, 2019: 10, 2020: 20, 2021: 14};
    _data3 = <double, double>{2017: 8, 2018: 15, 2019: 17, 2020: 11, 2021: 13};
    if (mounted) setState(() {});
  }
}
