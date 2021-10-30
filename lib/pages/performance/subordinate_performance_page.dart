import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/performance/custom_performance_page.dart';
import 'package:good_grandma/widgets/statistics_cell.dart';
import 'package:good_grandma/widgets/statistics_head_widget.dart';

///下级业绩
class SubordinatePerformancePage extends StatefulWidget {
  const SubordinatePerformancePage(
      {Key key,
      @required this.id,
      @required this.name,
      @required this.target,
      @required this.total})
      : super(key: key);
  final String id;
  final String name;
  final double target;
  final double total;

  @override
  _SubordinatePerformancePageState createState() =>
      _SubordinatePerformancePageState();
}

class _SubordinatePerformancePageState
    extends State<SubordinatePerformancePage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  List<Map> _dataArray = [];
  String _position = '';
  int _current = 1;
  int _pageSize = 15;

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    Widget titleView = Text.rich(TextSpan(
        text: widget.name + '  ',
        style: const TextStyle(
            color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
        children: [
          TextSpan(text: _position, style: const TextStyle(fontSize: 12.0))
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
              child: MyEasyRefreshSliverWidget(
                  controller: _controller,
                  scrollController: _scrollController,
                  dataCount: _dataArray.length,
                  onRefresh: _refresh,
                  onLoad: _onLoad,
                  slivers: [
                SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    sliver: SliverToBoxAdapter(
                        child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(10.0),
                            child: const Text('客户业绩',
                                style: const TextStyle(
                                    color: AppColors.FFC1C8D7,
                                    fontSize: 12.0))))),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    Map map = _dataArray[index];
                    String avatar = map['avatar'];
                    String name = map['name'];
                    String target = map['target'];
                    String current = map['current'];
                    String id = map['id'];
                    return StatisticsCell(
                        avatar: avatar,
                        name: name,
                        target: target,
                        current: current,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CustomPerformancePage(
                                    id: id,
                                    name: name,
                                    target: AppUtil.stringToDouble(target),
                                    total: AppUtil.stringToDouble(current)))));
                  }, childCount: _dataArray.length)),
                ),
                SliverSafeArea(sliver: SliverToBoxAdapter()),
              ])),
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    _current = 1;
    _downloadData();
  }

  Future<void> _onLoad() async {
    _current++;
    _downloadData();
  }

  void _downloadData() async {
    try {
      Map<String, dynamic> param = {
        'current': _current,
        'size': _pageSize,
        'queryType': '2',
        'userId': widget.id
      };
      // print('param = $param');
      final val = await requestGet(Api.selectContractStatistics, param: param);
      // LogUtil.d('selectMonthStatistics value = $val');
      final data = jsonDecode(val.toString());
      if (_current == 1) _dataArray.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        String targetSum = map['targetssum'] ?? '0';
        String total = map['total'] ?? '0';
        String avatar = map['total'] ?? '';
        String name = map['customerName'] ?? '';
        String saleId = map['contract']['customerId'] ?? '';
        _dataArray.add({
          'avatar': avatar,
          'name': name,
          'target': targetSum,
          'current': total,
          'id': saleId
        });
      });

      bool noMore = false;
      if (list == null || list.isEmpty) noMore = true;
      _controller.finishRefresh(success: true);
      _controller.finishLoad(success: true, noMore: noMore);
      if (mounted) setState(() {});
    } catch (error) {
      _controller.finishRefresh(success: false);
      _controller.finishLoad(success: false, noMore: false);
    }
  }
}
