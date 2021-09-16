import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/models/msg_list_model.dart';
import 'package:good_grandma/pages/message/msg_duizhangdan_detail_page.dart';
import 'package:good_grandma/widgets/msg_list_cell.dart';
import 'package:provider/provider.dart';

///对账单列表
class MsgDuiZhangDanListPage extends StatefulWidget {
  final String noticeCategory;

  const MsgDuiZhangDanListPage({Key key, this.noticeCategory}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<MsgDuiZhangDanListPage> {
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
      appBar: AppBar(title: Text('对账单'),
          leading:
          BackButton(onPressed: () => Navigator.pop(context, true)),),
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
                          child: MsgDuiZhangDanDetailPage(),
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
  Future<void> _onLoad() async{
    _current ++;
    _downloadData();
  }
  Future<void> _downloadData() async{
    try {
      Map<String, dynamic> map = {'current': _current, 'size': _pageSize};
      final val = await requestGet(
          Api.getNoticeCategoryList + '/' + widget.noticeCategory,
          param: map);
      LogUtil.d('${widget.noticeCategory} value = $val');
      var data = jsonDecode(val.toString());
      if (_current == 1) _dataArray.clear();
      final List<dynamic> list = data['data'];
      // print(list.toString());
      list.forEach((map) {
        MsgListModel model = MsgListModel.fromJson(map);
        model.forDuiZhangDan = true;
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

    // try{
    //   await Future.delayed(Duration(seconds: 1));
    //   if(_current == 1)
    //     _dataArray.clear();
    //   List list = [];
    //   for (int i = 0; i < 13; i++) {
    //     MsgListModel model = MsgListModel(
    //       time: '12:00:00',
    //       title: '关于财务发出的返利对账单中的应扣',
    //       content:
    //           '各位经理： 财务发出的返利对账单中有一项是应扣返利，是指冰柜总数减掉系统录入数和上报库存之间的差是指冰柜总数减掉系统录入数和上报库存之间的差是指冰柜总数减掉系统录入数和上报库存之间的差是指冰柜总数减掉系统录入数和上报库存之间的差是指冰柜总数减掉系统录入数和上报库存之间的差',
    //       enclosureName: '附件名称',
    //       enclosureSize: '1.2M',
    //       enclosureURL:
    //           'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
    //       forDuiZhangDan: true,
    //     );
    //     list.add(model);
    //     if (i % 2 == 0) model.setSign(true);
    //     _dataArray.add(model);
    //   }
    //   bool noMore = false;
    //   if (list == null || list.isEmpty) noMore = true;
    //   _controller.finishRefresh(success: true);
    //   _controller.finishLoad(success: true, noMore: noMore);
    //   if (mounted) setState(() {});
    // } catch (error) {
    //   _controller.finishRefresh(success: false);
    //   _controller.finishLoad(success: false, noMore: false);
    // }
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _controller?.dispose();
    super.dispose();
  }
}
