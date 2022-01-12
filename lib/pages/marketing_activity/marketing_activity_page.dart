import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/models/marketing_activity_model.dart';
import 'package:good_grandma/pages/marketing_activity/add_marketing_activity_page.dart';
import 'package:good_grandma/pages/work/work_report/work_type_title.dart';
import 'package:good_grandma/widgets/marketing_activity_cell.dart';
import 'package:good_grandma/widgets/marketing_plan_activity_cell.dart';
import 'package:provider/provider.dart';

///市场活动
class MarketingActivityPage extends StatefulWidget {
  const MarketingActivityPage({Key key}) : super(key: key);

  @override
  _MarketingActivityPageState createState() => _MarketingActivityPageState();
}

class _MarketingActivityPageState extends State<MarketingActivityPage> {
  final EasyRefreshController _controllerActivity = EasyRefreshController();
  final ScrollController _scrollControllerActivity = ScrollController();
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  int _currentActivity = 1;
  int _pageSizeActivity = 10;
  int _current = 1;
  int _pageSize = 10;

  ///市场活动/行销规划类型id
  String statusChild = '我发布的';

  ///活动列表
  List<MarketingActivityModel> activityList = [];

  ///行销规划列表
  List<Map> activityPlanList = [];

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
    _controllerActivity.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('市场活动')),
      body: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: (){
                  setState(() {
                    statusChild = '我发布的';
                  });
                }, child: Text('我发布的', style: TextStyle(color: statusChild == '我发布的' ? AppColors.FFC08A3F : AppColors.FF2F4058))),
                TextButton(onPressed: (){
                  setState(() {
                    statusChild = '行销规划';
                  });
                }, child: Text('行销规划', style: TextStyle(color: statusChild == '行销规划' ? AppColors.FFC08A3F : AppColors.FF2F4058))),
              ]
          ),
          Visibility(
            visible: statusChild == '我发布的' ? true : false,
            child: Expanded(
              child: MyEasyRefreshSliverWidget(
                controller: _controllerActivity,
                scrollController: _scrollControllerActivity,
                dataCount: activityList.length,
                onRefresh: _refreshActivity,
                onLoad: _onLoadActivity,
                slivers: [
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return MarketingActivityCell(
                            model: activityList[index]
                        );
                      }, childCount: activityList.length)
                  )
                ]
              )
            )
          ),
          Visibility(
            visible: statusChild == '行销规划' ? true : false,
            child: Expanded(
              child: MyEasyRefreshSliverWidget(
                  controller: _controller,
                  scrollController: _scrollController,
                  dataCount: activityPlanList.length,
                  onRefresh: _refresh,
                  onLoad: _onLoad,
                  slivers: [
                    SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return MarketingPlanActivityCell(
                              model: activityPlanList[index]
                          );
                        }, childCount: activityPlanList.length)
                    )
                  ]
              )
            )
          )
        ]
      )
    );
  }

  Future<void> _refreshActivity() async {
    _currentActivity = 1;
    await _downloadDataActivity();
  }

  Future<void> _onLoadActivity() async {
    _currentActivity++;
    await _downloadDataActivity();
  }

  ///市场活动列表
  Future<void> _downloadDataActivity() async {
    try {
      Map<String, dynamic> map = {'current': _currentActivity, 'size': _pageSizeActivity};
      final val = await requestGet(Api.activityList, param: map);
      var data = jsonDecode(val.toString());
      LogUtil.d('请求结果---activityList----$data');
      if (_currentActivity == 1) activityList.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        MarketingActivityModel model = MarketingActivityModel.fromJson(map);
        activityList.add(model);
      });
      bool noMore = false;
      if (list == null || list.isEmpty) noMore = true;
      _controllerActivity.finishRefresh(success: true);
      _controllerActivity.finishLoad(success: true, noMore: noMore);
      if (mounted) setState(() {});
    } catch (error) {
      _controllerActivity.finishRefresh(success: false);
      _controllerActivity.finishLoad(success: false, noMore: false);
    }
  }

  Future<void> _refresh() async {
    _current = 1;
    await _downloadData();
  }

  Future<void> _onLoad() async {
    _current++;
    await _downloadData();
  }

  ///行销规划列表
  Future<void> _downloadData() async {
    try {
      Map<String, dynamic> map = {'current': _current, 'size': _pageSize};
      final val = await requestGet(Api.activityPlanList, param: map);
      var data = jsonDecode(val.toString());
      LogUtil.d('请求结果---activityPlanList----$data');
      if (_current == 1) activityPlanList.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        activityPlanList.add(map);
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
    _scrollControllerActivity?.dispose();
    _controllerActivity?.dispose();
    super.dispose();
  }
}
