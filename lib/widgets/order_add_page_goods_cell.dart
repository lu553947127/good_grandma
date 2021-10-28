import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/common/number_counter.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/goods_model.dart';

///订单添加页面商品列表cell
class AddPageGoodsCell extends StatelessWidget {
  const AddPageGoodsCell({
    Key key,
    @required this.model,
    this.middleman = false,
    @required TextEditingController editingController,
    @required FocusNode focusNode,
    @required this.deleteAction,
    @required this.numberChangeAction,
  })  : _editingController = editingController,
        _focusNode = focusNode,
        super(key: key);

  final GoodsModel model;
  ///是否是二级订单 二级订单使用二批价
  final bool middleman;
  final VoidCallback deleteAction;
  final TextEditingController _editingController;
  final FocusNode _focusNode;
  final VoidCallback numberChangeAction;

  @override
  Widget build(BuildContext context) {
    double price = model.invoice;
    double countPrice = model.countPrice;
    if(middleman) {
      price = model.middleman;
      countPrice = model.countMiddlemanPrice;
    }
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 9),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: MyCacheImageView(
                          imageURL: model.image, width: 90, height: 82)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                    model.name,
                    style: const TextStyle(
                        color: AppColors.FF2F4058, fontSize: 14.0),
                  ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Visibility(
                        visible: model.specs.isNotEmpty,
                        child: Text(
                          '规格：' + model.specs.first.spec,
                          style: const TextStyle(
                              color: AppColors.FF959EB1, fontSize: 12.0),
                        ),
                      ),
                    ),
                    Text.rich(TextSpan(
                        text: '¥',
                        style: const TextStyle(
                            color: AppColors.FFE45C26, fontSize: 12.0),
                        children: [
                          TextSpan(
                            text: countPrice.toStringAsFixed(2),
                            style: const TextStyle(fontSize: 18.0),
                          )
                        ])),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //删除按钮
                    GestureDetector(
                        onTap: deleteAction,
                        child: Icon(Icons.delete_forever_outlined)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        '¥' + price.toStringAsFixed(2),
                        style: const TextStyle(
                            color: AppColors.FF959EB1, fontSize: 12.0),
                      ),
                    ),
                    //修改数量
                    NumberCounter(
                      num: model.count,
                      subBtnOnTap: () {
                        if (model.count == 0) return;
                        model.count--;
                        if (numberChangeAction != null)
                          numberChangeAction();
                      },
                      addBtnOnTap: () {
                        model.count++;
                        if (numberChangeAction != null)
                          numberChangeAction();
                      },
                      numOnTap: () => AppUtil.showInputDialog(
                          context: context,
                          editingController: _editingController,
                          focusNode: _focusNode,
                          text: model.count.toString(),
                          hintText: '请输入数字',
                          keyboardType: TextInputType.number,
                          callBack: (num) {
                            if (num.isEmpty)
                              model.count = 0;
                            else
                              model.count = int.parse(num);
                            if (numberChangeAction != null)
                              numberChangeAction();
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
              color: AppColors.FFEFEFF4,
              thickness: 1,
              height: 1,
              indent: 15,
              endIndent: 15)
        ],
      ),
    );
  }
}
