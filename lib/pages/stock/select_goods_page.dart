import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/goods_model.dart';
import 'package:good_grandma/widgets/search_text_widget.dart';
import 'package:good_grandma/widgets/submit_btn.dart';

class SelectGoodsPage extends StatefulWidget {
  const SelectGoodsPage(
      {Key key,
      @required this.selGoods,
      @required this.customerId,
      this.selectSingle = false,
      this.forStock = true})
      : super(key: key);
  final List<GoodsModel> selGoods;
  final String customerId;

  /// 是否只选一个
  final bool selectSingle;

  /// 是否库存管理
  final bool forStock;

  @override
  _SelectGoodsPageState createState() => _SelectGoodsPageState();
}

class _SelectGoodsPageState extends State<SelectGoodsPage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();
  List<GoodsModel> _goodsList = [];
  int _current = 1;
  int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('选择产品')),
      body: MyEasyRefreshSliverWidget(
          controller: _controller,
          scrollController: _scrollController,
          dataCount: _goodsList.length,
          onRefresh: _refresh,
          onLoad: _onLoad,
          slivers: [
            //搜索
            SearchTextWidget(
                editingController: _editingController,
                focusNode: _focusNode,
                hintText: '请输入商品名称',
                onSearch: _searchAction),
            //列表
            SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  GoodsModel goodsModel = _goodsList[index];
                  return _GoodsGridCell(
                    goodsModel: goodsModel,
                    onTap: widget.selectSingle
                        ? () => Navigator.pop(context, [goodsModel])
                        : null,
                  );
                }, childCount: _goodsList.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 0.8)),
            SliverSafeArea(sliver: SliverToBoxAdapter()),
          ]),
      bottomNavigationBar: Visibility(
        visible: !widget.selectSingle,
        child: SafeArea(
          child: SubmitBtn(
              title: '确定',
              onPressed: () {
                List<GoodsModel> _selList = _goodsList
                    .where((employee) => employee.isSelected)
                    .toList();
                if (_selList.isEmpty) {
                  Fluttertoast.showToast(
                      msg: '至少选择一个产品', gravity: ToastGravity.CENTER);
                  return;
                }
                Navigator.pop(context, _selList);
              }),
        ),
      ),
    );
  }

  _searchAction(String text) {
    if (text.isEmpty) {
      _controller.callRefresh();
      return;
    }
    List<GoodsModel> tempList = [];
    tempList.addAll(_goodsList.where((element) => element.name.contains(text)));
    _goodsList.clear();
    _goodsList.addAll(tempList);
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
    if (widget.customerId == null || widget.customerId.isEmpty) {
      AppUtil.showToastCenter('用户ID不能为空');
      _controller.finishRefresh(success: false);
      _controller.finishLoad(success: false, noMore: false);
      return;
    }
    try {
      Map<String, dynamic> map = {
        'current': _current,
        'size': _pageSize,
        'customerId': widget.customerId
      };
      // print('map = $map');
      String url = Api.customerStockGoodsList;
      if (!widget.forStock) url = Api.goodsList;
      final val = await requestGet(url, param: map);
      // LogUtil.d('customerStockGoodsList value = $val');
      var data = jsonDecode(val.toString());
      if (_current == 1) _goodsList.clear();
      final List<dynamic> list = data['data'];
      int i = 0;
      list.forEach((map) {
        GoodsModel model;
        if (widget.forStock) {
          model = GoodsModel.fromJson((map as Map));
          model.id = i.toString();
        } else {
          double invoice = double.parse(map['invoice']) ?? 0;
          double middleman = double.parse(map['middleman']) ?? 0;
          double weight = map['weight'] != null
              ? double.parse(map['weight'].toString())
              : 0;
          model = GoodsModel(
            name: map['name'] ?? '',
            invoice: invoice,
            middleman: middleman,
            weight: weight,
            image: map['path'] ?? '',
            id: map['id'] ?? '',
          );
          String spec = map['spec'] ?? '';
          if (spec.isNotEmpty) {
            SpecModel specModel = SpecModel(spec: spec);
            model.specs.add(specModel);
          }
        }
        _goodsList.add(model);
        i++;
      });

      if (widget.selGoods.isNotEmpty && !widget.selectSingle) {
        _goodsList.forEach((goods) {
          goods.isSelected = false;
          widget.selGoods.forEach((selEmployee) {
            if (selEmployee.id == goods.id) goods.isSelected = true;
          });
        });
      }
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
    _controller?.dispose();
    _scrollController?.dispose();
  }
}

class _GoodsGridCell extends StatefulWidget {
  const _GoodsGridCell({
    Key key,
    @required this.goodsModel,
    this.onTap,
  }) : super(key: key);
  final GoodsModel goodsModel;
  final VoidCallback onTap;
  @override
  State<StatefulWidget> createState() => _GoodsGridCellState();
}

class _GoodsGridCellState extends State<_GoodsGridCell> {
  @override
  Widget build(BuildContext context) {
    String specStr = '';
    int i = 0;
    widget.goodsModel.specs.forEach((spec) {
      if (i == 0) specStr += '规格：';
      specStr += '1x${spec.spec}';
      if (i < widget.goodsModel.specs.length - 1) specStr += ',';
      i++;
    });
    return GestureDetector(
      onTap: () {
        setState(
            () => widget.goodsModel.isSelected = !widget.goodsModel.isSelected);
        if (widget.onTap != null) widget.onTap();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Stack(
                children: [
                  MyCacheImageView(
                      imageURL: widget.goodsModel.image,
                      width: 105.0,
                      height: 96.0),
                  Visibility(
                    visible: widget.goodsModel.isSelected,
                    child: Container(
                      width: 105.0,
                      height: 96.0,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border:
                              Border.all(color: AppColors.FFC08A3F, width: 4)),
                    ),
                  ),
                  Visibility(
                    visible: widget.goodsModel.isSelected,
                    child: Positioned(
                        bottom: 3,
                        right: 3,
                        child: Image.asset('assets/images/goods_sel.png',
                            width: 30, height: 30)),
                  ),
                ],
              ),
            ),
          ),
          Text(widget.goodsModel.name),
          Visibility(
            visible: widget.goodsModel.specs.isNotEmpty,
            child: Text(specStr,
                style:
                    const TextStyle(color: AppColors.FF959EB1, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
