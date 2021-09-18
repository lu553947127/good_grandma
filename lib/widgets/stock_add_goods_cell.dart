import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/goods_model.dart';
import 'package:good_grandma/models/stock_add_model.dart';

///新增库存商品cell
class StockAddGoodsCell extends StatelessWidget {
  const StockAddGoodsCell({
    Key key,
    @required this.goodsNames,
    @required this.stockModel,
    @required TextEditingController editingController,
    @required FocusNode focusNode,
    @required this.pickTimeAction,
    @required this.deleteAction,
    @required this.numberChangeAction,
  })  : _editingController = editingController,
        _focusNode = focusNode,
        super(key: key);

  final String goodsNames;
  final StockModel stockModel;
  final TextEditingController _editingController;
  final FocusNode _focusNode;
  final VoidCallback pickTimeAction;
  final VoidCallback deleteAction;
  final Function(SpecModel specModel) numberChangeAction;

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
              trailing: Icon(Icons.chevron_right, color: AppColors.FF2F4058),
              contentPadding: const EdgeInsets.all(0),
            ),
            const Divider(color: AppColors.FFF4F5F8, thickness: 1, height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                List.generate(stockModel.goodsModel.specs.length, (index) {
                  SpecModel specModel = stockModel.goodsModel.specs[index];
                  return Expanded(
                    child: _NumberCell(
                      key: UniqueKey(),
                      title: '整箱(1*${specModel.spec})',
                      value: specModel.number,
                      onTap: () => AppUtil.showInputDialog(
                          context: context,
                          editingController: _editingController,
                          focusNode: _focusNode,
                          text: specModel.number,
                          hintText: '请输入数量',
                          keyboardType: TextInputType.number,
                          callBack: (text) {
                            specModel.number = text;
                            if(numberChangeAction != null)
                              numberChangeAction(specModel);
                            // if(index > 0)
                            //   setState(() {});
                          }),
                    ),
                  );
                }),
              ),
            ),
            const Divider(color: AppColors.FFF4F5F8, thickness: 1, height: 1),
            //生产日期
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text('生产日期',
                    style: const TextStyle(
                        color: AppColors.FF2F4058, fontSize: 12.0)),
              ),
              title: Text(
                  stockModel.time.isNotEmpty ? stockModel.time : '请选择生产日期',
                  style: TextStyle(
                      color: stockModel.time.isNotEmpty
                          ? AppColors.FF2F4058
                          : AppColors.FFC1C8D7,
                      fontSize: 12.0)),
              trailing: IconButton(
                  onPressed: deleteAction,
                  icon:
                  Icon(Icons.delete_forever_outlined, color: Colors.black)),
              contentPadding: const EdgeInsets.all(0),
              onTap: pickTimeAction,
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberCell extends StatelessWidget {
  const _NumberCell({
    Key key,
    @required this.title,
    @required this.value,
    @required this.onTap,
  }) : super(key: key);

  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(title,
                style:
                const TextStyle(color: AppColors.FF2F4058, fontSize: 12.0)),
          ),
          Text(value.isNotEmpty ? value : '请输入数量',
              style: TextStyle(
                  color: value.isNotEmpty
                      ? AppColors.FF2F4058
                      : AppColors.FFC1C8D7,
                  fontSize: 12.0)),
        ],
      ),
    );
  }
}