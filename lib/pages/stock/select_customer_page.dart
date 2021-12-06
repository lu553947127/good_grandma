import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/widgets/search_text_widget.dart';

///选择客户
///customerList区域下所有客户 allUser全部客户
class SelectCustomerPage extends StatefulWidget {
  final String url;
  final String title;
  final String name;
  const SelectCustomerPage({Key key, this.url, this.title, this.name}) : super(key: key);

  @override
  _SelectCustomerPageState createState() => _SelectCustomerPageState();
}

class _SelectCustomerPageState extends State<SelectCustomerPage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();
  List<Map> _dataArray = [];

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: MyEasyRefreshSliverWidget(
          controller: _controller,
          scrollController: _scrollController,
          dataCount: _dataArray.length,
          onRefresh: _refresh,
          onLoad: null,
          slivers: [
            //搜索
            SearchTextWidget(
                hintText: '请输入搜索关键字',
                editingController: _editingController,
                focusNode: _focusNode,
                onSearch: _searchAction),
            //列表
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              Map model = _dataArray[index];
              return Column(
                children: [
                  ListTile(
                    title: Text(model[widget.name]),
                    onTap: () => Navigator.pop(context, model)
                  ),
                  const Divider(thickness: 1, height: 1),
                ]
              );
            }, childCount: _dataArray.length)),
            SliverSafeArea(sliver: SliverToBoxAdapter()),
          ])
    );
  }

  _searchAction(String text) {
    if (text.isEmpty) {
      _controller.callRefresh();
      return;
    }
    List<Map> tempList = [];
    tempList.addAll(_dataArray.where((element) => element[widget.name].contains(text)));
    _dataArray.clear();
    _dataArray.addAll(tempList);
    setState(() {});
  }

  Future<void> _refresh() async {
    try {
      final val = await requestGet(widget.url);
      LogUtil.d('customerList value = $val');
      var data = jsonDecode(val.toString());
      final List<dynamic> list = data['data'];
      _dataArray.clear();
      list.forEach((map) {
        _dataArray.add(map);
      });
      _controller.finishRefresh(success: true);
      if (mounted) setState(() {});
    } catch (error) {
      _controller.finishRefresh(success: false);
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

///选择返回回调
Future<Map> showSelectSearchList(BuildContext context, url, title, name) async {
  Map result;
  result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SelectCustomerPage(
              url: url,
              title: title,
              name: name
          )
      )
  );
  return result ?? "";
}