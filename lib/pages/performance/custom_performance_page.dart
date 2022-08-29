import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/loading_widget.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/widgets/bar_chart_widget.dart';
import 'package:good_grandma/widgets/line_chart_widget.dart';
import 'package:good_grandma/widgets/statistics_head_widget.dart';

class CustomPerformancePage extends StatefulWidget {
  const CustomPerformancePage(
      {Key key, @required this.id, @required this.name,@required this.target,@required this.total})
      : super(key: key);
  final String id;
  final String name;
  final double target;
  final double total;

  @override
  _CustomPerformancePageState createState() => _CustomPerformancePageState();
}

class _CustomPerformancePageState extends State<CustomPerformancePage> {
  String _position = '';
  /// !!Step1: prepare the data to plot. 月份为key，数值为金额
  Map<double, double> _monthTotals = <double, double>{};
  Map<double, double> _monthTargets = <double, double>{};
  Map<double, double> _sessionTargets = <double, double>{};
  Map<double, double> _sessionTotals = <double, double>{};

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
      body: Column(
        children: [
          StatisticsHeadWidget(
              titleView: titleView,
              title: widget.name + '业绩',
              target: widget.target,
              current: widget.total,
              showRightArrow: showRightArrow),
          Expanded(
            child: Scrollbar(
              child: FutureBuilder(
                  future: requestGet(Api.selectMonthStatistics,param: {'customerId':widget.id,'type':'月'}),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = jsonDecode(snapshot.data.toString());
                      LogUtil.d('请求结果---selectMonthStatistics----${snapshot.data}');
                      final List<dynamic> list = data['data'];
                      if(list == null || list.isEmpty)
                        return NoDataWidget(emptyRetry: () => setState(() {}));
                      _monthTotals = <double, double>{};
                      _monthTargets = <double, double>{};
                      _sessionTotals = <double, double>{};
                      _sessionTargets = <double, double>{};
                      /// 按顺序保存月份名
                      List<String> monthNames = [];
                      /// 按顺序保存季节名
                      List<String> sessionNames = [];
                      double i = 0;
                      double j = 0;
                      list.forEach((element) {
                        String month = element['montht'] ?? '';
                        String targets = element['targetssum'] ?? '';
                        String total = element['totals'] ?? '';
                        if(month.contains('月')){
                          monthNames.add(month.replaceAll('月', ''));
                          _monthTotals[i] = AppUtil.stringToDouble(total);
                          _monthTargets[i] = AppUtil.stringToDouble(targets);
                          i++;
                        }
                        else if(month.contains('季度')){
                          sessionNames.add(month);
                          _sessionTotals[j] = AppUtil.stringToDouble(total);
                          _sessionTargets[j] = AppUtil.stringToDouble(targets);
                          j++;
                        }
                      });
                      // _sessionTargets = <double, double>{1: 9, 2: 12, 3: 10, 4: 20};
                      // _sessionTotals = <double, double>{1: 8, 2: 15, 3: 17, 4: 11};
                      return ListView(
                        padding: const EdgeInsets.all(0),
                        children: [
                          LineChartWidget(totalMap: _monthTotals,targetMap: _monthTargets,bottomNames: monthNames),
                          Visibility(
                              visible: _sessionTotals.isNotEmpty || _sessionTargets.isNotEmpty,
                              child: BarChartWidget(targetMap: _sessionTargets, totalMap: _sessionTotals,bottomNames: sessionNames,)),
                        ],
                      );
                    }
                    if (snapshot.hasError) return NoDataWidget(emptyRetry: () => setState(() {}));
                    return LoadingWidget();
                  }
              ),
            ),
          ),
        ],
      ),
    );
  }
}
