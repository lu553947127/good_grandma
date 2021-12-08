import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/pages/stock/select_customer_page.dart';
import 'package:good_grandma/pages/work/freezer_statistics/freezer_statistics_type.dart';
import 'package:good_grandma/widgets/sales_statistics_cell.dart';
import 'package:good_grandma/widgets/select_tree.dart';

///商品销量统计
class SalesStatisticsPage extends StatefulWidget {

  @override
  _SalesStatisticsPageState createState() => _SalesStatisticsPageState();
}

class _SalesStatisticsPageState extends State<SalesStatisticsPage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  int _current = 1;
  int _pageSize = 10;

  String deptId = '';
  String areaName = '所有区域';
  String userId= '';
  String userName = '所有员工';
  String customerId = '';
  String customerName = '所有客户';

  List<Map> commoditySalesList = [];

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('商品销量统计')),
      body: Scrollbar(
        child: Column(
          children: [
            //顶部筛选按钮
            FreezerStatisticsType(
                areaName: areaName,
                customerName: userName,
                statusName: customerName,
                onPressed: () async{
                  Map area = await showSelectTreeList(context, '');
                  deptId = area['deptId'];
                  areaName = area['areaName'];
                  _controller.callRefresh();
                },
                onPressed2: () async{
                  Map select = await showSelectSearchList(context, Api.userList, '请选择员工名称', 'realName');
                  userId = select['id'];
                  userName = select['realName'];
                  _controller.callRefresh();
                },
                onPressed3: () async {
                  Map select = await showSelectSearchList(context, Api.customerList, '请选择客户名称', 'realName');
                  customerId = select['id'];
                  customerName = select['realName'];
                  _controller.callRefresh();
                }
            ),
            Expanded(
                child: MyEasyRefreshSliverWidget(
                    controller: _controller,
                    scrollController: _scrollController,
                    dataCount: commoditySalesList.length,
                    onRefresh: _refresh,
                    onLoad: _onLoad,
                    slivers: [
                      SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            Map map = commoditySalesList[index];
                            String title = map['name'] + ' (规格: ${map['spec']})';
                            String salesCount = map['orderDetailed']['count'].toString();
                            String salesPrice = map['orderDetailed']['total'].toString();
                            return SalesStatisticsCell(
                              title: title,
                              salesCount: salesCount,
                              salesPrice: salesPrice,
                              onTap: null,
                            );
                          }, childCount: commoditySalesList.length))
                    ]
                )
            )
          ]
        )
      )
    );
  }

  Future<void> _refresh() async {
    _current = 1;
    await _downloadData();
  }

  Future<void> _onLoad() async {
    _current++;
    await _downloadData();
  }

  ///商品销量统计列表
  Future<void> _downloadData() async {
    try {
      Map<String, dynamic> map = {
        'deptId': deptId,
        'userId': userId,
        'customerId': customerId,
        'current': _current,
        'size': _pageSize
      };
      final val = await requestGet(Api.commoditySalesList, param: map);
      var data = jsonDecode(val.toString());
      LogUtil.d('请求结果---commoditySalesList----$data');
      if (_current == 1) commoditySalesList.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        commoditySalesList.add(map);
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
    _scrollController?.dispose();
    _controller?.dispose();
    super.dispose();
  }
}
