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

///业绩统计
class PerformanceStatisticsPage extends StatefulWidget {
  const PerformanceStatisticsPage({Key key}) : super(key: key);

  @override
  _PerformanceStatisticsPageState createState() =>
      _PerformanceStatisticsPageState();
}

class _PerformanceStatisticsPageState extends State<PerformanceStatisticsPage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  List<Map> _dataArray = [];
  double _target = 0;
  double _total = 0;
  int _current = 1;
  int _pageSize = 15;

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    Widget titleView = Text('我的业绩(万元)',
        style: const TextStyle(
            color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold));
    return Scaffold(
      body: Column(
        children: [
          StatisticsHeadWidget(
            titleView: titleView,
            target: _target,
            current: _total,
            showRightArrow: false,
            // onTap: () => Navigator.push(context,
            //     MaterialPageRoute(builder: (_) => MyPerformancePage())),
          ),
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
                            child: const Text('下级业绩',
                                style: const TextStyle(
                                    color: AppColors.FFC1C8D7,
                                    fontSize: 12.0))))),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    Map map = _dataArray[index];
                    String avatar = map['avatar'] ?? '';
                    String name = map['name'] ?? '';
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
                                  total: AppUtil.stringToDouble(current)))),
                      // onTap: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => SubordinatePerformancePage(
                      //             id: id,
                      //             name: name,
                      //             target: AppUtil.stringToDouble(target),
                      //             total: AppUtil.stringToDouble(current))))
                    );
                  }, childCount: _dataArray.length)),
                ),
                SliverSafeArea(sliver: SliverToBoxAdapter()),
              ])),
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    _getHeaderData();
    _current = 1;
    _downloadData();
  }

  Future<void> _onLoad() async {
    _current++;
    _downloadData();
  }

  _getHeaderData() {
    requestGet(Api.selectSaleSubordinate).then((value) {
      // LogUtil.d('selectSaleSubordinate value = $value');
      final map = jsonDecode(value.toString());
      String targetSum = map['data']['targetssum'];
      String total = map['data']['totals'];
      _target = AppUtil.stringToDouble(targetSum);
      _total = AppUtil.stringToDouble(total);
      if (mounted) setState(() {});
    });
  }

  void _downloadData() async {
    try {
      Map<String, dynamic> param = {
        'current': _current,
        'size': _pageSize,
        // 'queryType': '1'
      };
      // print('param = $param');
      final val = await requestGet(Api.selectContractStatistics, param: param);
      LogUtil.d('selectContractStatistics value = $val');
      final data = jsonDecode(val.toString());
      if (_current == 1) _dataArray.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        String targetSum = map['targetssum'] ?? '0';
        String total = map['totals'] ?? '0';
        String avatar = map['avatar'] ?? '';
        String name = map['customerName'] ?? '';
        String saleId = map['customerId'] != null ? map['customerId'].toString() : '';
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

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _scrollController?.dispose();
  }
}
