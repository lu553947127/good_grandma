import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/stock_add_model.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                    child: Row(
                      children: [
                        Text('≤6',
                            textAlign: TextAlign.end,
                            style: const TextStyle(fontSize: 14.0)),
                        SizedBox(width: 5),
                        Text(stockModel.oneToThree.isEmpty ? '请输入' : stockModel.oneToThree,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: stockModel.oneToThree.isEmpty ? AppColors.FFC1C8D7 : AppColors.FF2F4058, fontSize: 14.0))
                      ]
                    ),
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
                SizedBox(width: 95),
                InkWell(
                    child: Row(
                      children: [
                        Text('>6',
                            textAlign: TextAlign.end,
                            style: const TextStyle(fontSize: 14.0)),
                        SizedBox(width: 5),
                        Text(stockModel.fourToSix.isEmpty ? '请输入' : stockModel.fourToSix,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: stockModel.fourToSix.isEmpty ? AppColors.FFC1C8D7 : AppColors.FF2F4058, fontSize: 14.0))
                      ]
                    ),
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
                )
              ]
            ),
            SizedBox(height: 5)
          ]
        )
      )
    );
  }
}