import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/models/msg_list_model.dart';
import 'package:good_grandma/pages/regular_doc/regular_doc_detail_page.dart';
import 'package:good_grandma/widgets/msg_list_cell.dart';
import 'package:provider/provider.dart';

///规章文件
class RegularDocPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<RegularDocPage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  List _dataArray = [];
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
      appBar: AppBar(title: Text('规章文件')),
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
                          child: RegularDocDetailPage(),
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
    await _downloadData();
  }

  Future<void> _onLoad() async {
    _current++;
    await _downloadData();
  }

  Future<void> _downloadData() async {
    try {
      Map<String, dynamic> map = {'current': _current, 'size': _pageSize};
      final val = await requestGet(Api.regularDocList, param: map);
      var data = jsonDecode(val.toString());
      if (_current == 1) _dataArray.clear();
      final List<dynamic> list = data['data'];
      LogUtil.d(list.toString());
      list.forEach((map) {
        MsgListModel model = MsgListModel.fromJson(map);
        model.forRegularDoc = true;
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
