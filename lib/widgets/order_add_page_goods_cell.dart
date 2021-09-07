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
    @required TextEditingController editingController,
    @required FocusNode focusNode,
    @required this.deleteAction,
    @required this.numberChangeAction,
  })  : _editingController = editingController,
        _focusNode = focusNode,
        super(key: key);

  final GoodsModel model;
  final VoidCallback deleteAction;
  final TextEditingController _editingController;
  final FocusNode _focusNode;
  final VoidCallback numberChangeAction;

  @override
  Widget build(BuildContext context) {
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
                    Container(
                      constraints: BoxConstraints(maxWidth: 260),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              model.name,
                              style: const TextStyle(
                                  color: AppColors.FF2F4058, fontSize: 14.0),
                            ),
                          ),
                          //删除按钮
                          GestureDetector(
                              onTap: deleteAction,
                              child: Icon(Icons.delete_forever_outlined)),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      constraints: BoxConstraints(maxWidth: 260),
                      child: Row(
                        children: [
                          Text(
                            model.spec,
                            style: const TextStyle(
                                color: AppColors.FF959EB1, fontSize: 12.0),
                          ),
                          Spacer(),
                          Text(
                            '¥' + model.price.toStringAsFixed(2),
                            style: const TextStyle(
                                color: AppColors.FF959EB1, fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 260),
                      child: Row(
                        children: [
                          Text.rich(TextSpan(
                              text: '¥',
                              style: const TextStyle(
                                  color: AppColors.FFE45C26, fontSize: 12.0),
                              children: [
                                TextSpan(
                                  text: model.countPrice.toStringAsFixed(2),
                                  style: const TextStyle(fontSize: 18.0),
                                )
                              ])),
                          Spacer(),
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
