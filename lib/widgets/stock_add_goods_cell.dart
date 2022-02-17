import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/stock_add_model.dart';
import 'package:good_grandma/widgets/activity_add_text_cell.dart';

///新增库存商品cell
class StockAddGoodsCell extends StatelessWidget {
  const StockAddGoodsCell({
    Key key,
    @required this.goodsNames,
    @required this.stockAddModel,
    @required this.stockModel,
    @required TextEditingController editingController,
    @required FocusNode focusNode,
    @required this.index
  })  : _editingController = editingController,
        _focusNode = focusNode,
        super(key: key);

  final String goodsNames;
  final StockAddModel stockAddModel;
  final StockModel stockModel;
  final TextEditingController _editingController;
  final FocusNode _focusNode;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //商品
            ListTile(
              title: Text(goodsNames.isNotEmpty ? goodsNames : '请选择商品',
                  style: TextStyle(
                      color: goodsNames.isNotEmpty
                          ? AppColors.FF2F4058
                          : AppColors.FFC1C8D7,
                      fontSize: 14.0)),
              trailing: null,
              contentPadding: const EdgeInsets.all(0),
            ),
            const Divider(color: AppColors.FFF4F5F8, thickness: 1, height: 1),
            ActivityAddTextCell(
                title: '1-3月存量（箱）',
                hintText: '请输入数量',
                value: stockModel.oneToThree,
                trailing: null,
                onTap: () => AppUtil.showInputDialog(
                    context: context,
                    editingController: _editingController,
                    focusNode: _focusNode,
                    text: stockModel.oneToThree,
                    hintText: '请输入数量',
                    keyboardType: TextInputType.number,
                    callBack: (text) {
                      if(text.contains('.') || int.tryParse(text) == null){
                        AppUtil.showToastCenter('请输入整数数量');
                        return;
                      }
                      stockModel.oneToThree = text;
                      stockAddModel.editStockListWith(index, stockModel);
                    })
            ),
            const Divider(color: AppColors.FFF4F5F8, thickness: 1, height: 1),
            ActivityAddTextCell(
                title: '4-6月存量（箱）',
                hintText: '请输入数量',
                value: stockModel.fourToSix,
                trailing: null,
                onTap: () => AppUtil.showInputDialog(
                    context: context,
                    editingController: _editingController,
                    focusNode: _focusNode,
                    text: stockModel.fourToSix,
                    hintText: '请输入数量',
                    keyboardType: TextInputType.number,
                    callBack: (text) {
                      if(text.contains('.') || int.tryParse(text) == null){
                        AppUtil.showToastCenter('请输入整数数量');
                        return;
                      }
                      stockModel.fourToSix = text;
                      stockAddModel.editStockListWith(index, stockModel);
                    })
            ),
            const Divider(color: AppColors.FFF4F5F8, thickness: 1, height: 1),
            ActivityAddTextCell(
                title: '7-9月存量（箱）',
                hintText: '请输入数量',
                value: stockModel.sevenToTwelve,
                trailing: null,
                onTap: () => AppUtil.showInputDialog(
                    context: context,
                    editingController: _editingController,
                    focusNode: _focusNode,
                    text: stockModel.sevenToTwelve,
                    hintText: '请输入数量',
                    keyboardType: TextInputType.number,
                    callBack: (text) {
                      if(text.contains('.') || int.tryParse(text) == null){
                        AppUtil.showToastCenter('请输入整数数量');
                        return;
                      }
                      stockModel.sevenToTwelve = text;
                      stockAddModel.editStockListWith(index, stockModel);
                    })
            ),
            const Divider(color: AppColors.FFF4F5F8, thickness: 1, height: 1),
            ActivityAddTextCell(
                title: '9月以上存量（箱）',
                hintText: '请输入数量',
                value: stockModel.eighteenToUp,
                trailing: null,
                onTap: () => AppUtil.showInputDialog(
                    context: context,
                    editingController: _editingController,
                    focusNode: _focusNode,
                    text: stockModel.eighteenToUp,
                    hintText: '请输入数量',
                    keyboardType: TextInputType.number,
                    callBack: (text) {
                      if(text.contains('.') || int.tryParse(text) == null){
                        AppUtil.showToastCenter('请输入整数数量');
                        return;
                      }
                      stockModel.eighteenToUp = text;
                      stockAddModel.editStockListWith(index, stockModel);
                    })
            ),
            const Divider(color: AppColors.FFF4F5F8, thickness: 1, height: 1),
            //删除
            Container(
                width: double.infinity,
                color: Colors.white,
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: (){
                      stockAddModel.deleteStockListWith(index);
                    },
                    icon: Icon(Icons.delete_forever_outlined, color: AppColors.FFDD0000)
                )
            )
          ]
        )
      )
    );
  }
}