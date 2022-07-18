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

///通知公告审批
class NoticeExamine extends StatefulWidget {
  const NoticeExamine({Key key}) : super(key: key);

  @override
  State<NoticeExamine> createState() => _NoticeExamineState();
}

class _NoticeExamineState extends State<NoticeExamine> {

  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  List<MsgListModel> _dataArray = [];

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('公告审批'),
        leading: BackButton(onPressed: () => Navigator.pop(context, true)),
      ),
      body: MyEasyRefreshSliverWidget(
          controller: _controller,
          scrollController: _scrollController,
          dataCount: _dataArray.length,
          onRefresh: _refresh,
          onLoad: null,
          slivers: [
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  MsgListModel model = _dataArray[index];
                  return ChangeNotifierProvider<MsgListModel>.value(
                      value: model,
                      child: MsgListCell(
                        cellOnTap: () async {
                          bool needRefresh = await Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return ChangeNotifierProvider<MsgListModel>.value(
                                  value: model,
                                  child: MsgDetailPage(type: 'examine'),
                                );
                              }));
                          if(needRefresh != null && needRefresh){
                            _controller.callRefresh();
                          }
                        },
                        type: 'examine',
                      ));
                }, childCount: _dataArray.length)),
            SliverSafeArea(sliver: SliverToBoxAdapter()),
          ]),
    );
  }

  Future<void> _refresh() async {
    _downloadData();
  }

  Future<void> _downloadData() async {
    try {
      final val = await requestGet(Api.auditNoticeList);
      LogUtil.d('auditNoticeList = $val');
      var data = jsonDecode(val.toString());
      _dataArray.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        MsgListModel model = MsgListModel.fromJson(map);
        _dataArray.add(model);
      });
      _controller.finishRefresh(success: true);
      if (mounted) setState(() {});
    } catch (error) {
      _controller.finishRefresh(success: false);
    }
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _controller?.dispose();
    super.dispose();
  }
}
