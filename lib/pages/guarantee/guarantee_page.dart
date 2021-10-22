import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/widgets/guarantee_cell.dart';
import 'package:good_grandma/widgets/switch_type_title_widget.dart';

///报修
class GuaranteePage extends StatefulWidget {
  const GuaranteePage({Key key}) : super(key: key);
  @override
  _GuaranteePageState createState() => _GuaranteePageState();
}

class _GuaranteePageState extends State<GuaranteePage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  List<Map> _dataArray = [];
  final List<Map> _typeTitles = [
    {'name': '全部', 'color': AppColors.FFE45C26},
    {'name': '待发送', 'color': AppColors.FFC08A3F},
    {'name': '维修中', 'color': AppColors.FFDD0000},
    {'name': '维修完成', 'color': AppColors.FF959EB1},
  ];
  int _selIndex = 0;
  int _current = 1;
  int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('报修'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 55),
          child: SwitchTypeTitleWidget(
            backgroundColor: AppColors.FFF4F5F8,
            selIndex: _selIndex,
            list: _typeTitles,
            onTap: (index) {
              _selIndex = index;
              _controller.callRefresh();
            },
          ),
        ),
      ),
      body: MyEasyRefreshSliverWidget(
          controller: _controller,
          scrollController: _scrollController,
          dataCount: _dataArray.length,
          onRefresh: _refresh,
          onLoad: _onLoad,
          slivers: [
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              Map map = _dataArray[index];
              String id = map['code'];
              String type = map['brand'] + map['model'];
              String shopName = (map['freezerLogsVO'] as Map)['shop'];
              String name = (map['freezerLogsVO'] as Map)['shopOwner'];
              String phone = (map['freezerLogsVO'] as Map)['shopPhone'];
              String location = (map['freezerLogsVO'] as Map)['address'];
              String time = map['createTime'];
              int state = map['status'];
              String stateName = _typeTitles[state]['name'] == '全部' ? '驳回' : _typeTitles[state]['name'];
              Color stateColor = _typeTitles[state]['color'];
              List<String> values = [
                id ?? '',
                type ?? '',
                shopName ?? '',
                name ?? '',
                phone ?? '',
                location ?? '',
                time ?? ''
              ];
              return GuaranteeCell(
                  values: values, stateName: stateName, stateColor: stateColor);
            }, childCount: _dataArray.length)),
            SliverSafeArea(sliver: SliverToBoxAdapter()),
          ]),
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

  Future<void> _downloadData() async {
    try {
      Map<String, dynamic> map = {
        'current': _current,
        'size': _pageSize,
        'status': _selIndex==0?'':_selIndex
      };
      final val = await requestGet(Api.getFreezerRepairList, param: map);
      var data = jsonDecode(val.toString());
      if (_current == 1) _dataArray.clear();
      final List<dynamic> list = data['data'];
      // print(list.toString());
      list.forEach((map) {
        _dataArray.add(map as Map);
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
