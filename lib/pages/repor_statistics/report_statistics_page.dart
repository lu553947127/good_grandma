import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/pages/repor_statistics/report_statistics_detail_page.dart';
import 'package:good_grandma/widgets/search_text_widget.dart';

///报告统计
class ReportStatisticsPage extends StatefulWidget {
  const ReportStatisticsPage({Key key}) : super(key: key);

  @override
  _ReportStatisticsPageState createState() => _ReportStatisticsPageState();
}

class _ReportStatisticsPageState extends State<ReportStatisticsPage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();
  List<Map> _dataArray = [];
  int _current = 1;
  int _pageSize = 15;
  String keyword = '';

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('报告统计')),
      body: Column(
        children: [
          //搜索区域
          SearchTextWidget(
              hintText: '请输入员工姓名',
              editingController: _editingController,
              focusNode: _focusNode,
              onSearch: _searchAction,
              onChanged: (text){
                _searchAction(text);
              }
          ),
          Expanded(
            child: MyEasyRefreshSliverWidget(
                controller: _controller,
                scrollController: _scrollController,
                dataCount: _dataArray.length,
                onRefresh: _refresh,
                onLoad: null,
                slivers: [
                  //列表
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        Map map = _dataArray[index];
                        String avatar = map['avatar'];
                        String name = map['name'];
                        String day = map['day'];
                        String week = map['week'];
                        String month = map['month'];
                        String id = map['id'];
                        return _ReportStatisticsCell(
                          avatar: avatar,
                          name: name,
                          day: day,
                          week: week,
                          month: month,
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ReportStatisticsDetailPage(
                                    id: id,
                                    name: name,
                                    avatar: avatar,
                                  ))),
                        );
                      }, childCount: _dataArray.length)),
                  SliverSafeArea(sliver: SliverToBoxAdapter()),
                ])
          )
        ]
      )
    );
  }

  Future<void> _refresh() async {
    _current = 1;
    _downloadData();
  }

  // Future<void> _onLoad() async {
  //   _current++;
  //   _downloadData();
  // }

  Future<void> _downloadData() async {
    try {
      Map<String, dynamic> map = {
        'name': keyword,
        'current': _current,
        'size': _pageSize,
      };
      // print('param = ${jsonEncode(map)}');
      final val = await requestPost(Api.reportTj, json: jsonEncode(map));
      LogUtil.d('reportTj value = $val');
      final data = jsonDecode(val.toString());
      if (_current == 1) _dataArray.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        String avatar = map['avatar'] ?? '';
        String name = map['name'] ?? '';
        String day = map['day'].toString() ?? '';
        String week = map['week'].toString() ?? '';
        String month = map['month'].toString() ?? '';
        String id = map['userId'].toString() ?? '';
        _dataArray.add({
          'avatar': avatar,
          'name': name,
          'day': day,
          'week': week,
          'month': month,
          'id': id
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

  _searchAction(String text) {
    if (Platform.isAndroid){
      if (text.isEmpty) {
        _controller.callRefresh();
        return;
      }
      List<Map> tempList = [];
      tempList.addAll(_dataArray
          .where((element) => (element['name'] as String).contains(text)));
      _dataArray.clear();
      _dataArray.addAll(tempList);
      setState(() {});
    }else {
      if (text.isEmpty) {
        keyword = '';
        _controller.callRefresh();
        return;
      }
      keyword = text;
      _refresh();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode?.dispose();
    _editingController?.dispose();
    _controller?.dispose();
    _scrollController?.dispose();
  }
}

class _ReportStatisticsCell extends StatelessWidget {
  const _ReportStatisticsCell({
    Key key,
    @required this.avatar,
    @required this.name,
    @required this.day,
    @required this.week,
    @required this.month,
    @required this.onTap,
  }) : super(key: key);

  final String avatar;
  final String name;
  final String day;
  final String week;
  final String month;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipOval(
                    child: MyCacheImageView(
                  imageURL: avatar,
                  width: 30,
                  height: 30,
                  errorWidgetChild: Image.asset(
                      'assets/images/icon_empty_user.png',
                      width: 30,
                      height: 30),
                )),
              ),
              Expanded(
                  flex: 1,
                  child: Text(
                    name,
                    style: const TextStyle(
                        color: AppColors.FF2F4058, fontSize: 14.0),
                  )),
              Expanded(
                flex: 3,
                child: Text('日报:$day    周报:$week    月报:$month',
                    style: const TextStyle(
                        color: AppColors.FF959EB1, fontSize: 12.0),
                    textAlign: TextAlign.end),
              ),
              Icon(Icons.chevron_right, color: AppColors.FF959EB1),
            ],
          ),
        ),
      ),
    );
  }
}
