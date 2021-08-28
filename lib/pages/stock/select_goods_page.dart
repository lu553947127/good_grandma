import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/models/stock_add_model.dart';
import 'package:good_grandma/widgets/search_text_widget.dart';
import 'package:good_grandma/widgets/submit_btn.dart';

class SelectGoodsPage extends StatefulWidget {
  const SelectGoodsPage({Key key, @required this.selGoods}) : super(key: key);
  final List<GoodsModel> selGoods;

  @override
  _SelectGoodsPageState createState() => _SelectGoodsPageState();
}

class _SelectGoodsPageState extends State<SelectGoodsPage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();
  List<GoodsModel> _goodsList = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('选择产品')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              //搜索区域
              SearchTextWidget(
                  editingController: _editingController,
                  focusNode: _focusNode,
                  hintText: '请输入商品名称',
                  onSearch: (text) {}),
              //列表
              SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    GoodsModel goodsModel = _goodsList[index];
                    return _GoodsGridCell(goodsModel: goodsModel);
                  }, childCount: _goodsList.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 0.9))
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SubmitBtn(
            title: '确定',
            onPressed: () {
              List<GoodsModel> _selList =
                  _goodsList.where((employee) => employee.isSelected).toList();
              if (_selList.isEmpty) {
                Fluttertoast.showToast(
                    msg: '至少选择一个产品', gravity: ToastGravity.CENTER);
                return;
              }
              // print('_selList = ${_selList.length}');
              Navigator.pop(context, _selList);
            }),
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _goodsList.clear();
    for (int i = 0; i < 15; i++) {
      _goodsList.add(GoodsModel(
        image:
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        name: '产品' + i.toString(),
        id: i.toString(),
      ));
    }
    if (widget.selGoods.isNotEmpty) {
      _goodsList.forEach((goods) {
        goods.isSelected = false;
        widget.selGoods.forEach((selEmployee) {
          if (selEmployee.id == goods.id) goods.isSelected = true;
        });
      });
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode?.dispose();
    _editingController?.dispose();
  }
}

class _GoodsGridCell extends StatefulWidget {
  const _GoodsGridCell({
    Key key,
    @required this.goodsModel,
  }) : super(key: key);

  final GoodsModel goodsModel;
  @override
  State<StatefulWidget> createState() => _GoodsGridCellState();
}

class _GoodsGridCellState extends State<_GoodsGridCell> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.goodsModel.isSelected = !widget.goodsModel.isSelected;
        });
      },
      child: Column(
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
                        child: Image.asset('assets/images/goods_sel.png',width: 30,height: 30,)),
                  ),
                ],
              ),
            ),
          ),
          Text(widget.goodsModel.name),
        ],
      ),
    );
  }
}
