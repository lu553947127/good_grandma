import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/models/msg_list_model.dart';
import 'package:good_grandma/pages/message/msg_detail_page.dart';
import 'package:good_grandma/widgets/msg_list_cell.dart';
import 'package:provider/provider.dart';

///公告列表
class MsgPostListPage extends StatefulWidget {
  final String noticeCategory;
  final String noticeCategoryName;

  const MsgPostListPage(
      {Key key,
      @required this.noticeCategory,
      @required this.noticeCategoryName})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<MsgPostListPage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  List<MsgListModel> _dataArray = [];
  int _current = 1;
  int _pageSize = 15;

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noticeCategoryName),
        leading:
        BackButton(onPressed: () => Navigator.pop(context, true)),
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
                  MsgListModel model = _dataArray[index];
                  return ChangeNotifierProvider<MsgListModel>.value(
                      value: model,
                      child: MsgListCell(
                        cellOnTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return ChangeNotifierProvider<MsgListModel>.value(
                                  value: model,
                                  child: MsgDetailPage(),
                                );
                              }));
                        },
                      ));
                }, childCount: _dataArray.length)),
            SliverSafeArea(sliver: SliverToBoxAdapter()),
          ]),
    );
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
    try {
      Map<String, dynamic> map = {'current': _current, 'size': _pageSize};
      final val = await requestGet(
          Api.getNoticeCategoryList + '/' + widget.noticeCategory,
          param: map);
      LogUtil.d('value = $val');
      var data = jsonDecode(val.toString());
      if (_current == 1) _dataArray.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        MsgListModel model = MsgListModel.fromJson(map);
        _dataArray.add(model);
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
