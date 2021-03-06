import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/models/day_post_add_model.dart';
import 'package:good_grandma/models/employee_model.dart';
import 'package:good_grandma/models/home_report_model.dart';
import 'package:good_grandma/models/month_post_add_new_model.dart';
import 'package:good_grandma/models/post_add_zn_model.dart';
import 'package:good_grandma/models/week_post_add_new_model.dart';
import 'package:good_grandma/pages/draft/draft.dart';
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
  int _selIndex = 0;
  int _current = 1;
  int _pageSize = 7;

  /// type 1日报2周报3月报 ''全部
  String _type = '';

  ///选中的员工
  String _userIds = '';
  String _startTime = '';
  String _endTime = '';
  List<Map> _listTitle = [
    {'name': '我收到的'},
    {'name': '我提交的'},
    // {'name': '我的草稿'},
  ];
  bool _resetWorkSelectType = false;

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("工作报告"),
            actions: [
              TextButton(
                  child: Text("草稿", style: TextStyle(fontSize: 14, color: Color(0xFFC08A3F))),
                  onPressed: () async {
                    bool needRefresh = await Navigator.push(context,
                        MaterialPageRoute(builder:(context)=> DraftPage()));
                    if(needRefresh != null && needRefresh){
                      Navigator.pop(context, true);
                    }
                  }
              )
            ]
        ),
        body: Column(
          children: [
            SwitchTypeTitleWidget(
                backgroundColor: Colors.white,
                selIndex: _selIndex,
                list: _listTitle,
                onTap: (index) {
                  setState(() {
                    _selIndex = index;
                    _resetWorkSelectType = true;
                    _type = '';
                    _userIds = '';
                    _startTime = '';
                    _endTime = '';
                  });
                  _controller.callRefresh();
                }),
            //筛选
            WorkSelectType(selectAction: _workSelectTypeAction,reset: _resetWorkSelectType,showPeopleBtn: _selIndex == 0,),
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
                      return HomeReportCell(
                        model: model,
                        isCG: _selIndex == 2,
                        needRefreshAction: () => _controller.callRefresh(),
                      );
                    }, childCount: _reportList.length)),
                    SliverSafeArea(sliver: SliverToBoxAdapter()),
                  ]),
            ),
          ],
        ),
        floatingActionButton: _getFloatingActionButton(context));
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
    //status 1:草稿 2：提交 0收到的
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
        'status': status,
        'type': _type,
        'userids': _userIds,
        'startTime': _startTime,
        'endTime': _endTime,
      };
      // print('param = ${jsonEncode(map)}');
      final val = await requestPost(Api.reportList, json: jsonEncode(map));
      LogUtil.d('${Api.reportList} value = $val');
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
    _resetWorkSelectType = false;
  }

  void _workSelectTypeAction(List<EmployeeModel> selEmployees, String typeName,
      String startTime, String endTime) {
    if (selEmployees.isNotEmpty) {
      _userIds = '';
      int i = 0;
      selEmployees.forEach((empModel) {
        _userIds += empModel.id;
        if (i < selEmployees.length - 1) _userIds += ',';
        i++;
      });
    } else
      _userIds += '';
    switch (typeName) {
      case '所有类型':
        _type = '';
        break;
      case '日报':
        _type = '1';
        break;
      case '周报':
        _type = '2';
        break;
      case '月报':
        _type = '3';
        break;
    }
    _startTime = startTime;
    _endTime = endTime;
    _resetWorkSelectType = false;
    _controller.callRefresh();
  }

  Widget _getFloatingActionButton(BuildContext context) {
    bool zn = Store.readUserType() == 'zn';
    List<PopupMenuEntry<String>> list = [];
    if (!zn) list.add(PopupMenuItem<String>(value: '日报', child: Text('日报')));
    list.addAll([
      PopupMenuItem<String>(value: '周报', child: Text('周报')),
      PopupMenuItem<String>(value: '月报', child: Text('月报'))
    ]);
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child:
          Image.asset('assets/images/ic_work_add.png', width: 70, height: 70),
      itemBuilder: (context) {
        return list;
      },
      onSelected: (name) async {
        bool isZhiNeng = Store.readUserType() == 'zn';
        bool result;
        if (name == '日报') {
          _reportDraft('1', isZhiNeng, result);
        } else if (name == '周报') {
          _reportDraft('2', isZhiNeng, result);
        } else if (name == '月报') {
          _reportDraft('3', isZhiNeng, result);
        }
        if (result != null && result) _controller.callRefresh();
      },
    );
  }

  ///获取草稿
  _reportDraft(String type, bool isZhiNeng, bool result) async {
    requestPost(Api.reportDraftList, json: jsonEncode({'type': type})).then((value) async {
      LogUtil.d('reportDraftList value = $value');
      var data = jsonDecode(value.toString());
      List<Map> reportDraftList = [];
      final List<dynamic> list = data['data'];
      if (list.isNotEmpty) {
        list.forEach((map) {
          reportDraftList.add(map);
        });
        if(type == '1'){
          HomeReportModel model = HomeReportModel.fromJson(reportDraftList[0]);
          DayPostAddModel addModel = DayPostAddModel();
          addModel.id = model.id;
          addModel.setTarget(model.target.toString());
          addModel.setActual(model.actual.toString());
          addModel.setCumulative(model.cumulative.toString());
          addModel.setAchievementRate();
          addModel.setSummaries(model.summary);
          addModel.setPlans(model.plans);
          result = await Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ChangeNotifierProvider<DayPostAddModel>.value(
                value: addModel, child: DayPostAddPage(id: model.id));
          }));
        }else if (type == '2'){
          HomeReportModel model = HomeReportModel.fromJson(reportDraftList[0]);
          if (model.isZN) {
            //职能**
            PostAddZNModel addModel = PostAddZNModel();
            addModel.id = model.id;
            result =
            await Navigator.push(context, MaterialPageRoute(builder: (_) {
              return ChangeNotifierProvider<PostAddZNModel>.value(
                  value: addModel, child: PostAddZNPage(id: model.id));
            }));
          } else {
            WeekPostAddNewModel addModel = WeekPostAddNewModel();
            addModel.id = model.id;
            result =
            await Navigator.push(context, MaterialPageRoute(builder: (_) {
              return ChangeNotifierProvider<WeekPostAddNewModel>.value(
                  value: addModel, child: WeekPostAddPage(id: model.id));
            }));
          }
        }else if (type == '3'){
          HomeReportModel model = HomeReportModel.fromJson(reportDraftList[0]);
          if (model.isZN) {
            //职能**
            PostAddZNModel addModel = PostAddZNModel();
            addModel.id = model.id;
            result =
            await Navigator.push(context, MaterialPageRoute(builder: (_) {
              return ChangeNotifierProvider<PostAddZNModel>.value(
                  value: addModel,
                  child: PostAddZNPage(isWeek: false, id: model.id));
            }));
          } else {
            MonthPostAddNewModel addModel = MonthPostAddNewModel();
            addModel.id = model.id;
            result =
            await Navigator.push(context, MaterialPageRoute(builder: (_) {
              return ChangeNotifierProvider<MonthPostAddNewModel>.value(
                  value: addModel, child: MonthPostAddPage(id: model.id));
            }));
          }
        }
      }else {
        if(type == '1') {
          DayPostAddModel model = DayPostAddModel();
          result = await Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ChangeNotifierProvider<DayPostAddModel>.value(
                value: model, child: DayPostAddPage());
          }));
        }else if (type == '2'){
          if (isZhiNeng) {
            PostAddZNModel model = PostAddZNModel();
            result =
            await Navigator.push(context, MaterialPageRoute(builder: (_) {
              return ChangeNotifierProvider<PostAddZNModel>.value(
                  value: model, child: PostAddZNPage());
            }));
          } else {
            WeekPostAddNewModel model = WeekPostAddNewModel();
            result =
            await Navigator.push(context, MaterialPageRoute(builder: (_) {
              return ChangeNotifierProvider<WeekPostAddNewModel>.value(
                  value: model, child: WeekPostAddPage());
            }));
          }
        }else if (type == '3'){
          if (isZhiNeng) {
            PostAddZNModel model = PostAddZNModel();
            result =
            await Navigator.push(context, MaterialPageRoute(builder: (_) {
              return ChangeNotifierProvider<PostAddZNModel>.value(
                  value: model, child: PostAddZNPage(isWeek: false));
            }));
          } else {
            MonthPostAddNewModel model = MonthPostAddNewModel();
            result =
            await Navigator.push(context, MaterialPageRoute(builder: (_) {
              return ChangeNotifierProvider<MonthPostAddNewModel>.value(
                  value: model, child: MonthPostAddPage());
            }));
          }
        }
      }
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
    _controller?.dispose();
  }
}
