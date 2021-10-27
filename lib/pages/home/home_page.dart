import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
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
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

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
    _getVersion();
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
                child: Image.asset('assets/images/home_scan.png',
                    width: 20.0, height: 20.0)),
          ]),
      body: MyEasyRefreshSliverWidget(
          controller: _controller,
          scrollController: _scrollController,
          dataCount: _reportList.length + 1,
          onRefresh: _refresh,
          onLoad: _onLoad,
          slivers: [
            //顶部按钮
            HomeTableHeader(onTap: (name) => _titleBtnOnTap(context, name)),
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
            _reportList.length > 0
                ? SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                    HomeReportModel model = _reportList[index];
                    return HomeReportCell(model: model);
                  }, childCount: _reportList.length))
                : SliverToBoxAdapter(
                    child: Container(
                        margin: EdgeInsets.all(40),
                        child: Image.asset(
                            'assets/images/icon_empty_images.png',
                            width: 150,
                            height: 150)))
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
          if (_msgTime.isEmpty) {
            String time = map['createTime'] ?? '';
            if (time.isNotEmpty) _msgTime = time;
          }
        });
        if (mounted) setState(() => _msgCount = count.toString());
      }
    });
  }

  ///启动相机开始扫码
  Future<void> getQrcodeState() async {
    String qrcode;
    try {
      var result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: const {
            "cancel": "取消",
            "flash_on": "打开闪光",
            "flash_off": "关闭闪光",
          }
        )
      );
      qrcode = result.rawContent;
    } on PlatformException {
      qrcode = 'Failed to get platform version.';
    }
    print('qrcode==========$qrcode');

    Map<String, dynamic> map = {'code': qrcode};

    ///扫码上传
    requestGet(Api.analysisCode, param: map).then((val) {
      var data = json.decode(val.toString());
      print('请求结果---analysisCode----$data');
      Fluttertoast.showToast(
          msg: '扫描成功: $qrcode', gravity: ToastGravity.CENTER);
    });
  }

  ///获取版本号，判断是否升级
  _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    ///版本号
    String buildNumber = packageInfo.buildNumber;
    print('版本号---buildNumber----$buildNumber');
    if (Platform.isAndroid) {
      // requestGet(Api.androidVersion).then((val) async{
      //   var data = json.decode(val.toString());
      //   print('请求结果---androidVersion----$data');
      //   if (int.parse(data['version']) > int.parse(buildNumber)){
      //     _versionDialog(data['update_url']);
      //   }
      // });
      _versionDialog('update_url');
    }else {

    }
  }

  ///版本升级弹窗
  _versionDialog(url) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return Future.value(false);//屏蔽返回键关闭弹窗
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              title: Text('温馨提示'),
              content: Text('检测到有新的版本，您是否要升级体验？'),
              actions: <Widget>[
                TextButton(child: Text('取消', style: TextStyle(color: Color(0xFF999999))), onPressed: (){
                  Navigator.of(context).pop('cancel');
                  Navigator.pop(context);
                }),
                TextButton(child: Text('确认', style: TextStyle(color: Color(0xFFC68D3E))), onPressed: (){
                  Navigator.of(context).pop('ok');
                  _launchURL(url);
                })
              ]
            )
          );
        });
  }

  ///用内置浏览器打开网页
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: 'Could not launch $url', gravity: ToastGravity.CENTER);
    }
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _controller?.dispose();
    super.dispose();
  }
}
