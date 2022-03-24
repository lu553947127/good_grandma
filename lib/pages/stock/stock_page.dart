import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/models/stock_add_model.dart';
import 'package:good_grandma/pages/stock/stock_add_page.dart';
import 'package:good_grandma/pages/stock/stock_detail_page.dart';
import 'package:good_grandma/widgets/search_text_widget.dart';
import 'package:provider/provider.dart';

///客户库存
class StockPage extends StatefulWidget {
  const StockPage({Key key}) : super(key: key);

  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  List<Map> _dataArray = [];
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
      appBar: AppBar(title: const Text('客户库存')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: AppColors.FFC68D3E,
        onPressed: () async {
          final StockAddModel _model = StockAddModel();
          final result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) {
            return ChangeNotifierProvider.value(
              value: _model,
              child: StockAddPage(),
            );
          }));
          if (result != null && result) {
            _controller.callRefresh();
          }
        },
      ),
      body: Column(
          children: [
            //搜索区域
            SearchTextWidget(
                hintText: '请输入客户名称',
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
                    onLoad: _onLoad,
                    slivers: [
                      //列表
                      SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            Map map = _dataArray[index];
                            String avatar = map['avatar'] ?? '';
                            String shopName = map['corporate'] ?? '商户名称';
                            String name = map['juridical'] ?? '';
                            String juridicalPhone = map['juridicalPhone'] ?? '';
                            String address = map['address'] ?? '';
                            int number = map['count'] ?? 0;
                            String id = map['userId'].toString() ?? '';
                            return _StockCell(
                              avatar: avatar,
                              name: shopName,
                              number: number.toString(),
                              id:id,
                              onTap: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => StockDetailPage(
                                    id: id,
                                    shopName: shopName,
                                    avatar: avatar,
                                    name: name,
                                    phone: juridicalPhone,
                                    address: address,
                                    boxNum: number.toString(),))),
                            );
                          }, childCount: _dataArray.length)),
                      SliverSafeArea(sliver: SliverToBoxAdapter()),
                    ])
            )
          ]
      )
    );
  }

  _searchAction(String text){
    if(text.isEmpty) {
      _controller.callRefresh();
      return;
    }
    List<Map> tempList = [];
    tempList.addAll(_dataArray.where((element) => (element['corporate'] as String).contains(text)));
    _dataArray.clear();
    _dataArray.addAll(tempList);
    setState(() {});
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
      final val = await requestGet(Api.customerStockList, param: map);
      LogUtil.d('customerStockList value = $val');
      var data = jsonDecode(val.toString());
      if (_current == 1) _dataArray.clear();
      final List<dynamic> list = data['data'];
      print(list.toString());
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
    super.dispose();
    _focusNode?.dispose();
    _editingController?.dispose();
    _scrollController?.dispose();
    _controller?.dispose();
  }
}

class _StockCell extends StatelessWidget {
  const _StockCell({
    Key key,
    @required this.avatar,
    @required this.name,
    @required this.number,
    @required this.id,
    @required this.onTap,
  }) : super(key: key);

  final String avatar;
  final String name;
  final String number;
  final String id;
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
                child: Hero(
                  tag: id,
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
              ),
              Expanded(
                  child: Text(
                name,
                style:
                    const TextStyle(color: AppColors.FF2F4058, fontSize: 14.0),
              )),
              Expanded(
                child: Text.rich(
                  TextSpan(
                      text: '当月库存：',
                      style: const TextStyle(
                          color: AppColors.FF959EB1, fontSize: 12.0),
                      children: [
                        TextSpan(
                          text: number,
                          style: const TextStyle(
                              color: AppColors.FFE45C26, fontSize: 14.0),
                        ),
                        TextSpan(text: '箱'),
                      ]),
                  textAlign: TextAlign.end,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.FF959EB1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
