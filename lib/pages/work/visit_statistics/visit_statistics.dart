import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/stock/select_customer_page.dart';
import 'package:good_grandma/pages/work/visit_statistics/visit_statistics_detail.dart';
import 'package:good_grandma/pages/work/visit_statistics/visit_statistics_list.dart';
import 'package:good_grandma/pages/work/visit_statistics/visit_statistics_select.dart';
import 'package:good_grandma/pages/work/visit_statistics/visit_statistics_type.dart';

///拜访统计
class VisitStatistics extends StatefulWidget {
  const VisitStatistics({Key key}) : super(key: key);

  @override
  _VisitStatisticsState createState() => _VisitStatisticsState();
}

class _VisitStatisticsState extends State<VisitStatistics> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  int _current = 1;
  int _pageSize = 10;

  ///拜访统计列表
  List<Map> customerVisitList = [];

  ///拜访统计类型中文名称
  String type = '员工统计';

  ///类型数组
  List<Map> listTitle = [
    {'name': '员工统计'},
    {'name': '客户统计'},
  ];

  ///类型id
  String typeId = '1';

  ///员工id
  String userId = '';

  ///客户id
  String customerId = '';

  ///客户中文名称
  String customerName = '所有人';

  ///时间显示文字
  String time = '所有日期';

  ///开始时间
  String startDate = '';

  ///结束时间
  String endDate = '';

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
        title: Text("拜访统计",style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          VisitStatisticsSelect(
            color: Colors.white,
            type: type,
            list: listTitle,
            onPressed: () {
              typeId = '1';
              userId = '';
              customerId = '';
              customerName = '所有人';
              type = listTitle[0]['name'];
              _controller.callRefresh();
            },
            onPressed2: () {
              typeId = '2';
              userId = '';
              customerId = '';
              customerName = '所有人';
              type = listTitle[1]['name'];
              _controller.callRefresh();
            }
          ),
          VisitStatisticsType(
            customerName: customerName,
            time: time,
            onPressed: () async {
              Map select = await showSelectSearchList(
                  context,
                  typeId == '1' ? Api.userList : Api.customerList,
                  typeId == '1' ? '请选择员工' : '请选择客户',
                  'corporateName'
              );
              typeId == '1' ? userId = select['id'] : customerId = select['id'];
              customerName = select['corporateName'];
              _controller.callRefresh();
            },
            onPressed2: () async {
              showPickerDateRange(
                  context: Application.appContext,
                  callBack: (Map param){
                    time = '${param['startTime'] + '\n' + param['endTime']}';
                    startDate = param['startTime'];
                    endDate = param['endTime'];
                    _controller.callRefresh();
                  }
              );
            }
          ),
          Expanded(
            child: MyEasyRefreshSliverWidget(
                controller: _controller,
                scrollController: _scrollController,
                dataCount: customerVisitList.length,
                onRefresh: _refresh,
                onLoad: _onLoad,
                slivers: [
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return VisitStatisticsList(
                            data: customerVisitList[index],
                            onTap: () async {
                              bool needRefresh = await Navigator.push(context, MaterialPageRoute(builder:(context)=> VisitStatisticsDetail(
                                data: customerVisitList[index],
                              )));
                              if(needRefresh != null && needRefresh){
                                _controller.callRefresh();
                              }
                            }
                        );
                      }, childCount: customerVisitList.length))
                ]
            )
          )
        ]
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

  ///拜访统计列表
  Future<void> _downloadData() async {
    try {
      Map<String, dynamic> map = {
        'type': typeId,
        'userId': userId,
        'customerId': customerId,
        'startDate': startDate,
        'endDate': endDate,
        'current': _current,
        'size': _pageSize
      };
      final val = await requestGet(Api.customerVisitList, param: map);
      var data = jsonDecode(val.toString());
      LogUtil.d('请求结果---customerVisitList----$data');
      if (_current == 1) customerVisitList.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        customerVisitList.add(map);
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
