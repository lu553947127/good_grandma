import 'package:flutter/material.dart';
import 'package:good_grandma/widgets/mine_bar_chart_widget.dart';
import 'package:good_grandma/widgets/mine_line_chart_widget.dart';

///我的业绩 我的页面跳转进来的 现在没有用处
class MinePerformancePage extends StatefulWidget {
  const MinePerformancePage({Key key}) : super(key: key);

  @override
  _MinePerformancePageState createState() => _MinePerformancePageState();
}

class _MinePerformancePageState extends State<MinePerformancePage> {
  /// !!Step1: prepare the data to plot. 月份为key，数值为金额
  /// 月度业绩
  Map<double, double> _data1 = <double, double>{};

  /// 季度业绩
  Map<double, double> _data2 = <double, double>{};

  /// 年度业绩
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
      body: ListView(
        children: [
          MineLineChartWidget(dataMap: _data1),
          SizedBox(height:10.0),
          MineBarChartWidget(dataMap1: _data2, dataMap2: _data3),
        ],
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
    _data2 = <double, double>{1: 9, 2: 12, 3: 10, 4: 20};
    _data3 = <double, double>{2017: 8, 2018: 15, 2019: 17, 2020: 11, 2021: 13};
    if (mounted) setState(() {});
  }
}