import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/widgets/stock_detail_cell.dart';

///库存详细
class StockDetailPage extends StatefulWidget {
  const StockDetailPage(
      {Key key,
      @required this.id,
      @required this.avatar,
      @required this.shopName,
      @required this.name,
      @required this.phone,
      @required this.address,
      @required this.boxNum})
      : super(key: key);
  final String id;
  final String avatar;
  final String shopName;
  final String name;
  final String phone;
  final String address;
  final String boxNum;

  @override
  _StockDetailPageState createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  List<Map> _dataArray = [];
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
      appBar: AppBar(title: const Text('库存详细')),
      body: Column(
        children: [
          //顶部显示信息的视图
          _StockDetailHeader(
            avatar: widget.avatar,
            shopName: widget.shopName,
            name: widget.name,
            phone: widget.phone,
            address: widget.address,
            id: widget.id,
          ),
          _GroupTitle(boxNum: widget.boxNum),
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
                  return StockDetailCell(map: map);
                }, childCount: _dataArray.length)),
                SliverSafeArea(sliver: SliverToBoxAdapter()),
              ],
            ),
          ),
        ],
      ),
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
    if (widget.id == null || widget.id.isEmpty) return;
    try {
      Map<String, dynamic> map = {
        'customerId': widget.id,
        'current': _current,
        'size': _pageSize
      };
      final val = await requestGet(Api.customerStockDetail, param: map);
      LogUtil.d('customerStockDetail value = ${jsonEncode(val)}');
      var data = jsonDecode(val.toString());
      if (_current == 1) _dataArray.clear();
      final List<dynamic> list = data['data'];
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
    _scrollController?.dispose();
    _controller?.dispose();
  }
}

class _GroupTitle extends StatelessWidget {
  const _GroupTitle({
    Key key,
    @required String boxNum,
  })  : _boxNum = boxNum,
        super(key: key);

  final String _boxNum;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Column(
        children: [
          Row(
            children: [
              Text('最近6个月库存',
                  style: const TextStyle(
                      color: AppColors.FF959EB1, fontSize: 12.0)),
              Expanded(
                child: Text.rich(
                  TextSpan(
                      text: '总库存(箱)：',
                      style: const TextStyle(
                          color: AppColors.FF2F4058, fontSize: 12.0),
                      children: [
                        TextSpan(
                          text: _boxNum,
                          style: const TextStyle(
                              color: AppColors.FFE45C26, fontSize: 14.0),
                        ),
                      ]),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 13.0),
            child: Container(
              width: double.infinity,
              color: AppColors.FFEFEFF4,
              padding: const EdgeInsets.all(10.0),
              child: const Text('时间    商品/存量',
                  style: TextStyle(color: AppColors.FF2F4058, fontSize: 12.0)),
            ),
          ),
        ],
      ),
    );
  }
}

///顶部显示信息的视图
class _StockDetailHeader extends StatelessWidget {
  const _StockDetailHeader({
    Key key,
    @required String avatar,
    @required String shopName,
    @required String name,
    @required String phone,
    @required String address,
    @required this.id,
  })  : _avatar = avatar,
        _shopName = shopName,
        _name = name,
        _phone = phone,
        _address = address,
        super(key: key);

  final String _avatar;
  final String _shopName;
  final String _name;
  final String _phone;
  final String _address;
  final String id;

  @override
  Widget build(BuildContext context) {
    List<Map> values = [
      {
        'image': 'assets/images/ic_login_name.png',
        'title': '  店主姓名：',
        'value': _name
      },
      {
        'image': 'assets/images/ic_login_phone.png',
        'title': '  联系电话：',
        'value': _phone
      },
      {
        'image': 'assets/images/sign_in_local2.png',
        'title': '  所在地址：',
        'value': _address
      },
    ];
    List<Widget> views = [];
    values.forEach((map) {
      String image = map['image'];
      String title = map['title'];
      String value = map['value'];
      views.add(Row(
        children: [
          Image.asset(image, width: 12, height: 12),
          Expanded(
              child: Text(title + value,
                  style:
                      const TextStyle(color: AppColors.FF959EB1, fontSize: 12)))
        ],
      ));
    });
    return Card(
      child: ListTile(
        leading: Hero(
          tag: id,
          child: ClipOval(
              child: MyCacheImageView(
            imageURL: _avatar,
            width: 50,
            height: 50,
            errorWidgetChild: Image.asset('assets/images/icon_empty_user.png',
                width: 50, height: 50),
          )),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 10),
          child: Text(_shopName,
              style: const TextStyle(color: AppColors.FF2F4058, fontSize: 14)),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: views),
        ),
      ),
    );
  }
}
