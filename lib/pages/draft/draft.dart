import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/models/home_report_model.dart';
import 'package:good_grandma/pages/work/work_report/work_type_title.dart';
import 'package:good_grandma/widgets/home_report_cell.dart';

///草稿
class DraftPage extends StatefulWidget {
  const DraftPage({Key key}) : super(key: key);

  @override
  _DraftPageState createState() => _DraftPageState();
}

class _DraftPageState extends State<DraftPage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  int _current = 1;
  int _pageSize = 10;
  String type = '1';
  String typeName = '日报';
  List<Map> listTitle = [
    {'name': '日报'},//1
    {'name': '周报'},//2
    {'name': '月报'},//3
  ];

  List<Map> reportDraftList = [];

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('草稿')),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WorkTypeTitle(
                  color: Colors.white,
                  type: typeName,
                  list: listTitle,
                  onPressed: () {
                    type = '1';
                    typeName = '日报';
                    _controller.callRefresh();
                  },
                  onPressed2: () {
                    type = '2';
                    typeName = '周报';
                    _controller.callRefresh();
                  },
                  onPressed3: () {
                    type = '3';
                    typeName = '月报';
                    _controller.callRefresh();
                  }
              ),
              Expanded(
                  child: MyEasyRefreshSliverWidget(
                      controller: _controller,
                      scrollController: _scrollController,
                      dataCount: reportDraftList.length,
                      onRefresh: _refresh,
                      onLoad: _onLoad,
                      slivers: [
                        SliverList(
                            delegate: SliverChildBuilderDelegate((context, index) {
                              HomeReportModel model = HomeReportModel.fromJson(reportDraftList[index]);
                              return HomeReportCell(
                                model: model,
                                isCG: true,
                                needRefreshAction: () => _controller.callRefresh(),
                              );
                            }, childCount: reportDraftList.length)),
                        SliverSafeArea(sliver: SliverToBoxAdapter()),
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

  ///工作报告草稿列表
  Future<void> _downloadData() async {
    try {
      Map<String, dynamic> map = {
        'type': type,
        'current': _current,
        'size': _pageSize
      };
      final val = await requestPost(Api.reportDraftList, formData: map);
      var data = jsonDecode(val.toString());
      LogUtil.d('请求结果---reportDraftList----$data');
      if (_current == 1) reportDraftList.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        reportDraftList.add(map);
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
