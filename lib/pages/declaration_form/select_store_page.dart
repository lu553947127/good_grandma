import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/models/StoreModel.dart';
import 'package:good_grandma/widgets/search_text_widget.dart';

///选择商户
class SelectStorePage extends StatefulWidget {
  const SelectStorePage({Key key, this.forOrder = false}) : super(key: key);

  ///是否是新建订单专用
  final bool forOrder;

  @override
  _SelectStorePageState createState() => _SelectStorePageState();
}

class _SelectStorePageState extends State<SelectStorePage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();
  List<StoreModel> _stores = [];

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final Divider divider = const Divider(
        color: AppColors.FFC1C8D7,
        thickness: 1,
        height: 1,
        indent: 15,
        endIndent: 15.0);
    return Scaffold(
      appBar: AppBar(title: Text('选择商户')),
      body: MyEasyRefreshSliverWidget(
          controller: _controller,
          scrollController: _scrollController,
          dataCount: _stores.length,
          onRefresh: _refresh,
          onLoad: null,
          slivers: [
            //搜索
            SearchTextWidget(
                hintText: '请输入商户名称',
                editingController: _editingController,
                focusNode: _focusNode,
                onSearch: _searchAction),
            //列表
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              StoreModel model = _stores[index];
              return Column(
                children: [
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(model.name ?? ''),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Visibility(
                            visible: model.phone.isNotEmpty,
                            child: Row(
                              children: [
                                Image.asset('assets/images/ic_login_phone.png',
                                    width: 12, height: 12),
                                Expanded(
                                    child: Text(' ' + model.phone,
                                        style: const TextStyle(
                                            color: AppColors.FF959EB1,
                                            fontSize: 12)))
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: model.address.isNotEmpty,
                          child: Row(
                            children: [
                              Image.asset('assets/images/sign_in_local2.png',
                                  width: 12, height: 12),
                              Expanded(
                                  child: Text(' ' + model.address,
                                      style: const TextStyle(
                                          color: AppColors.FF959EB1,
                                          fontSize: 12)))
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () => Navigator.pop(context, model),
                  ),
                  divider
                ],
              );
            }, childCount: _stores.length)),
            SliverSafeArea(sliver: SliverToBoxAdapter()),
          ]),
    );
  }

  _searchAction(String text) {
    if (text.isEmpty) {
      _controller.callRefresh();
      return;
    }
    List<StoreModel> tempList = [];
    tempList.addAll(_stores.where((element) => element.name.contains(text)));
    _stores.clear();
    _stores.addAll(tempList);
    setState(() {});
  }

  Future<void> _refresh() async {
    try {
      final val = widget.forOrder
          ? await requestPost(Api.cusList)
          : await requestGet(Api.customerList);
      // LogUtil.d('${widget.forOrder?Api.cusList:Api.customerList} value = $val');
      var data = jsonDecode(val.toString());
      final List<dynamic> list = data['data'];
      _stores.clear();
      list.forEach((map) {
        StoreModel model = StoreModel(
          name: map['name'] ?? '',
          id: map['id'] ?? '',
          phone: map['phone'] ?? '',
          address: map['address'] ?? '',
        );
        _stores.add(model);
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
