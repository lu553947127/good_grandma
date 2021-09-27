import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/day_post_add_model.dart';
import 'package:good_grandma/models/home_report_model.dart';
import 'package:good_grandma/models/month_post_add_new_model.dart';
import 'package:good_grandma/models/post_add_zn_model.dart';
import 'package:good_grandma/models/week_post_add_new_model.dart';
import 'package:good_grandma/pages/work/work_report/day_post_add_page.dart';
import 'package:good_grandma/pages/work/work_report/month_post_add_page.dart';
import 'package:good_grandma/pages/work/work_report/post_add_zn_page.dart';
import 'package:good_grandma/pages/work/work_report/week_post_add_page.dart';
import 'package:good_grandma/pages/work/work_report/work_select_type.dart';
import 'package:good_grandma/widgets/home_report_cell.dart';
import 'package:good_grandma/widgets/switch_type_title_widget.dart';
import 'package:provider/provider.dart';

///工作报告
class WorkReport extends StatefulWidget {
  const WorkReport({Key key}) : super(key: key);

  @override
  _WorkReportState createState() => _WorkReportState();
}

class _WorkReportState extends State<WorkReport> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  List<HomeReportModel> _reportList = [];
  int _selIndex = 1;
  int _current = 1;
  int _pageSize = 7;

  String type = '我收到的';
  List<Map> listTitle = [
    {'name': '我收到的'},
    {'name': '我提交的'},
    {'name': '我的草稿'},
  ];

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("工作报告",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w700)),
        ),
        body: Column(
          children: [
            SwitchTypeTitleWidget(
                backgroundColor: Colors.white,
                selIndex: _selIndex,
                list: listTitle,
                onTap: (index) {
                  //todo:"我收到的"接口待定，可能会报错
                  if (index == 0) AppUtil.showToastCenter('接口待定，可能会报错');
                  _selIndex = index;
                  _controller.callRefresh();
                }),
            //筛选
            WorkSelectType(
              selEmpBtnOnTap: (selEmployees) {},
            ),
            Expanded(
              child: MyEasyRefreshSliverWidget(
                  controller: _controller,
                  scrollController: _scrollController,
                  dataCount: _reportList.length,
                  onRefresh: _refresh,
                  onLoad: _onLoad,
                  slivers: [
                    SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                      HomeReportModel model = _reportList[index];
                      return HomeReportCell(model: model, isZN: Store.readUserType() == 'zn');
                    }, childCount: _reportList.length)),
                    SliverSafeArea(sliver: SliverToBoxAdapter()),
                  ]),
            ),
          ],
        ),
        floatingActionButton: PopupMenuButton<String>(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Image.asset('assets/images/ic_work_add.png',
              width: 70, height: 70),
          itemBuilder: (context) {
            return <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: '日报',
                child: Text('日报'),
              ),
              PopupMenuItem<String>(
                value: '周报',
                child: Text('周报'),
              ),
              PopupMenuItem<String>(
                value: '月报',
                child: Text('月报'),
              )
            ];
          },
          onSelected: (name) async {
            bool isZhiNeng = Store.readUserType() == 'zn';
            bool result;
            if (name == '日报') {
              DayPostAddModel model = DayPostAddModel();
              result =
                  await Navigator.push(context, MaterialPageRoute(builder: (_) {
                return ChangeNotifierProvider<DayPostAddModel>.value(
                    value: model, child: DayPostAddPage());
              }));
            } else if (name == '周报') {
              if (isZhiNeng) {
                PostAddZNModel model = PostAddZNModel();
                result = await Navigator.push(context,
                    MaterialPageRoute(builder: (_) {
                  return ChangeNotifierProvider<PostAddZNModel>.value(
                      value: model, child: PostAddZNPage());
                }));
              } else {
                WeekPostAddNewModel model = WeekPostAddNewModel();
                result = await Navigator.push(context,
                    MaterialPageRoute(builder: (_) {
                  return ChangeNotifierProvider<WeekPostAddNewModel>.value(
                      value: model, child: WeekPostAddPage());
                }));
              }
            } else if (name == '月报') {
              if (isZhiNeng) {
                PostAddZNModel model = PostAddZNModel();
                result = await Navigator.push(context,
                    MaterialPageRoute(builder: (_) {
                  return ChangeNotifierProvider<PostAddZNModel>.value(
                      value: model, child: PostAddZNPage(isWeek: false));
                }));
              } else {
                MonthPostAddNewModel model = MonthPostAddNewModel();
                result = await Navigator.push(context,
                    MaterialPageRoute(builder: (_) {
                  return ChangeNotifierProvider<MonthPostAddNewModel>.value(
                      value: model, child: MonthPostAddPage());
                }));
              }
            }
            if (result != null && result) _controller.callRefresh();
          },
        ));
  }

  Future<void> _refresh() async {
    _current = 1;
    _downloadData();
  }

  Future<void> _onLoad() async {
    _current++;
    _downloadData();
  }

  Future<void> _downloadData() async {
    //status 1:草稿 2：提交
    int status = 1;
    if (_selIndex == 0)
      status = 0;
    else if (_selIndex == 1)
      status = 2;
    else if (_selIndex == 2) status = 1;
    try {
      Map<String, dynamic> map = {
        'current': _current,
        'size': _pageSize,
        'status': status
      };
      // print('param = $map');
      final val = await requestPost(Api.reportList, json: jsonEncode(map));
      // LogUtil.d('reportList value = $val');
      var data = jsonDecode(val.toString());
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

  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
    _controller?.dispose();
  }
}
