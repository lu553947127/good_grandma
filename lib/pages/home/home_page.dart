import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/home_report_model.dart';
import 'package:good_grandma/pages/marketing_activity/marketing_activity_page.dart';
import 'package:good_grandma/pages/performance/performance_statistics_page.dart';
import 'package:good_grandma/pages/sign_in/sign_in_page.dart';
import 'package:good_grandma/pages/work/freezer_sales/freezer_sales.dart';
import 'package:good_grandma/pages/work/freezer_statistics/freezer_statistics.dart';
import 'package:good_grandma/pages/work/visit_plan/visit_plan.dart';
import 'package:good_grandma/pages/work/work_report/work_report.dart';
import 'package:good_grandma/widgets/home_group_title.dart';
import 'package:good_grandma/widgets/home_msg_title.dart';
import 'package:good_grandma/widgets/home_plan_cell.dart';
import 'package:good_grandma/widgets/home_report_cell.dart';
import 'package:good_grandma/widgets/home_table_header.dart';

///首页
class HomePage extends StatefulWidget {
  final Function(int index) switchTabbarIndex;

  const HomePage({Key key, @required this.switchTabbarIndex}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<HomePage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  String _msgTime = '';
  String _msgCount = '0';
  List<HomeReportModel> _reportList = [];
  int _current = 1;
  int _pageSize = 7;

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("好阿婆"),
          actions: [
            TextButton(
                onPressed: () {
                  getQrcodeState();
                },
                child: Image.asset('assets/images/home_scan.png', width: 20.0, height: 20.0)),
          ]
      ),
      body: MyEasyRefreshSliverWidget(
          controller: _controller,
          scrollController: _scrollController,
          dataCount: _reportList.length + 1,
          onRefresh: _refresh,
          onLoad: _onLoad,
          slivers: [
            //顶部按钮
            HomeTableHeader(
              onTap: (name) => _titleBtnOnTap(context, name),
            ),
            //消息通知
            SliverToBoxAdapter(
                child: Visibility(
                    visible: _msgCount != '0',
                    child: HomeGroupTitle(title: '消息通知', showMore: false))),
            //消息cell
            SliverToBoxAdapter(
                child: HomeMsgTitle(
              msgTime: _msgTime,
              msgCount: _msgCount,
              onTap: () {
                if (widget.switchTabbarIndex != null)
                  widget.switchTabbarIndex(1);
              },
            )),
            //拜访计划
            SliverToBoxAdapter(
                child: HomeGroupTitle(
                    title: '拜访计划',
                    showMoreBtnOnTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => VisitPlan()));
                    })),
            //日历和计划
            SliverToBoxAdapter(child: HomePlanCell()),
            //工作报告
            SliverToBoxAdapter(
                child: HomeGroupTitle(
                    title: '工作报告',
                    showMoreBtnOnTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WorkReport())))),
            //报告列表
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              HomeReportModel model = _reportList[index];
              return HomeReportCell(model: model);
            }, childCount: _reportList.length)),
          ]),
      // body: buildScrollbar(context),'
    );
  }

  ///按钮点击事件
  void _titleBtnOnTap(BuildContext context, String name) {
    switch (name) {
      case '工作报告':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WorkReport()));
        break;
      case '市场活动':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MarketingActivityPage()));
        break;
      case '审批申请':
        if (widget.switchTabbarIndex != null) widget.switchTabbarIndex(3);
        break;
      case '签到':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInPage()));
        break;
      case '业绩统计':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PerformanceStatisticsPage()));
        break;
      case '冰柜销量':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FreezerSales()));
        break;
      case '冰柜统计':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => FreezerStatistics()));
        break;
      case '更多':
        if (widget.switchTabbarIndex != null) widget.switchTabbarIndex(2);
        break;
    }
  }

  Future<void> _refresh() async {
    _getMsgCountRequest();
    _current = 1;
    _downloadData();
  }

  Future<void> _onLoad() async {
    _current++;
    _downloadData();
  }

  Future<void> _downloadData() async {
    try {
      Map<String, dynamic> map = {
        'current': _current,
        'size': _pageSize,
        'status': 2,
        'type': '',
        'userids': '',
        'startTime': '',
        'endTime': '',
      };
      // print('param = ${jsonEncode(map)}');
      final val = await requestPost(Api.reportList, json: jsonEncode(map));
      // LogUtil.d('reportList value = $val');
      final data = jsonDecode(val.toString());
      if (_current == 1) _reportList.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        HomeReportModel model = HomeReportModel.fromJson(map);
        _reportList.add(model);
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

  Future<void> _getMsgCountRequest() async {
    requestGet(Api.getCategoryCount).then((value) {
      var data = jsonDecode(value.toString());
      final List<dynamic> list = data['data'];
      if (list.isNotEmpty) {
        int count = 0;
        list.forEach((map) {
          String read = map['read'] ?? '0';
          count += int.parse(read);
        });
        if (mounted) setState(() => _msgCount = count.toString());
      }
    });
  }

  ///启动相机开始扫码
  Future<void> getQrcodeState() async {
    String qrcode;
    try {
      var result = await BarcodeScanner.scan();
      qrcode = result.rawContent;
    } on PlatformException {
      qrcode = 'Failed to get platform version.';
    }
    print('qrcode==========$qrcode');

    Fluttertoast.showToast(msg: qrcode,gravity: ToastGravity.CENTER);

    // ///扫码上传
    // requestPost(Api.scanCode,formData:{'id':qrcode}).then((val){
    //   var data = json.decode(val.toString());
    //   print('请求结果---scanCode----$data');
    //   showToast('扫码成功');
    // });
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _controller?.dispose();
    super.dispose();
  }
}
