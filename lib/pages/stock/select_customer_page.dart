import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/models/employee_model.dart';
import 'package:good_grandma/widgets/search_text_widget.dart';

///选择客户
class SelectCustomerPage extends StatefulWidget {
  const SelectCustomerPage({Key key}) : super(key: key);

  @override
  _SelectCustomerPageState createState() => _SelectCustomerPageState();
}

class _SelectCustomerPageState extends State<SelectCustomerPage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();
  List<EmployeeModel> _dataArray = [];
  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('选择客户')),
      body: MyEasyRefreshSliverWidget(
          controller: _controller,
          scrollController: _scrollController,
          dataCount: _dataArray.length,
          onRefresh: _refresh,
          onLoad: null,
          slivers: [
            //搜索
            SearchTextWidget(
                hintText: '请输入客户名称',
                editingController: _editingController,
                focusNode: _focusNode,
                onSearch: _searchAction),
            //列表
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              EmployeeModel model = _dataArray[index];
              return Column(
                children: [
                  ListTile(
                    title: Text(model.name),
                    onTap: () => Navigator.pop(context, model),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 1,
                  ),
                ],
              );
            }, childCount: _dataArray.length)),
            SliverSafeArea(sliver: SliverToBoxAdapter()),
          ]),
    );
  }

  _searchAction(String text) {
    if (text.isEmpty) {
      _controller.callRefresh();
      return;
    }
    List<EmployeeModel> tempList = [];
    tempList.addAll(_dataArray.where((element) => element.name.contains(text)));
    _dataArray.clear();
    _dataArray.addAll(tempList);
    setState(() {});
  }

  Future<void> _refresh() async {
    try {
      final val = await requestGet(Api.customerList);
      LogUtil.d('customerList value = $val');
      var data = jsonDecode(val.toString());
      final List<dynamic> list = data['data'];
      _dataArray.clear();
      list.forEach((map) {
        EmployeeModel model =
            EmployeeModel(name: map['name'] ?? '', id: map['id'] ?? '');
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
    super.dispose();
    _focusNode?.dispose();
    _editingController?.dispose();
    _controller?.dispose();
    _scrollController?.dispose();
  }
}
