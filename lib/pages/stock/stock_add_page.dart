import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/employee_model.dart';
import 'package:good_grandma/models/goods_model.dart';
import 'package:good_grandma/models/stock_add_model.dart';
import 'package:good_grandma/pages/stock/select_goods_page.dart';
import 'package:good_grandma/pages/work/work_report/select_employee_page.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///新增库存
class StockAddPage extends StatefulWidget {
  const StockAddPage({Key key}) : super(key: key);

  @override
  _StockAddPageState createState() => _StockAddPageState();
}

class _StockAddPageState extends State<StockAddPage> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final StockAddModel _model = Provider.of<StockAddModel>(context);
    String customerNames = '';
    int i = 0;
    _model.customers.forEach((customer) {
      customerNames += customer.name;
      if (i < _model.customers.length - 1) customerNames += ',';
      i++;
    });
    return Scaffold(
      appBar: AppBar(title: const Text('新增库存')),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            //客户名称
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: ListTile(
                  onTap: () async {
                    List<EmployeeModel> _selList = await Navigator.push(context,
                        MaterialPageRoute(builder: (_) {
                      return SelectEmployeePage(selEmployees: _model.customers);
                    }));
                    if (_selList != null) {
                      _model.setCustomers(_selList);
                    }
                  },
                  title: Row(
                    children: [
                      const Text('客户名称',
                          style: TextStyle(
                              color: AppColors.FF2F4058, fontSize: 14.0)),
                      Expanded(
                          child: Text(
                              customerNames != null && customerNames.isNotEmpty
                                  ? customerNames
                                  : '请选择客户',
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                  color: AppColors.FFC1C8D7, fontSize: 14.0))),
                    ],
                  ),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
            ),
            //商品名称
            SliverToBoxAdapter(
              child: ListTile(
                title: const Text('商品名称',
                    style:
                        TextStyle(color: AppColors.FF959EB1, fontSize: 12.0)),
                trailing: IconButton(
                    onPressed: () => _model.addToStockList(StockModel()),
                    icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
              ),
            ),
            //list
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              StockModel stockModel = _model.stockList[index];
              String goodsNames = '';
              int i = 0;
              stockModel.goodsList.forEach((goodsModel) {
                goodsNames += goodsModel.name;
                if (i < stockModel.goodsList.length - 1) goodsNames += ',';
                i++;
              });
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //请选择商品
                      ListTile(
                        title: Text(
                            goodsNames.isNotEmpty ? goodsNames : '请选择商品',
                            style: TextStyle(
                                color: goodsNames.isNotEmpty
                                    ? AppColors.FF2F4058
                                    : AppColors.FFC1C8D7,
                                fontSize: 14.0)),
                        trailing: Icon(Icons.chevron_right,
                            color: AppColors.FF2F4058),
                        contentPadding: const EdgeInsets.all(0),
                        onTap: () async {
                          List<GoodsModel> _selGoodsList = await Navigator.push(
                              context, MaterialPageRoute(builder: (_) {
                            return SelectGoodsPage(
                                selGoods: stockModel.goodsList);
                          }));
                          if (_selGoodsList != null) {
                            stockModel.goodsList.clear();
                            stockModel.goodsList.addAll(_selGoodsList);
                            _model.editStockListWith(index, stockModel);
                          }
                        },
                      ),
                      const Divider(
                          color: AppColors.FFF4F5F8, thickness: 1, height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _NumberCell(
                              title: '整箱(1*20)',
                              value: stockModel.tBoxNum,
                              onTap: () => AppUtil.showInputDialog(
                                  context: context,
                                  editingController: _editingController,
                                  focusNode: _focusNode,
                                  text: stockModel.tBoxNum,
                                  hintText: '请输入数量',
                                  keyboardType: TextInputType.number,
                                  callBack: (text) {
                                    stockModel.tBoxNum = text;
                                    _model.editStockListWith(index, stockModel);
                                  }),
                            ),
                            _NumberCell(
                              title: '整箱(1*40)',
                              value: stockModel.fBoxNum,
                              onTap: () => AppUtil.showInputDialog(
                                  context: context,
                                  editingController: _editingController,
                                  focusNode: _focusNode,
                                  text: stockModel.fBoxNum,
                                  hintText: '请输入数量',
                                  keyboardType: TextInputType.number,
                                  callBack: (text) {
                                    stockModel.fBoxNum = text;
                                    _model.editStockListWith(index, stockModel);
                                  }),
                            ),
                            _NumberCell(
                              title: '非整箱(支)',
                              value: stockModel.unboxNum,
                              onTap: () => AppUtil.showInputDialog(
                                  context: context,
                                  editingController: _editingController,
                                  focusNode: _focusNode,
                                  text: stockModel.unboxNum,
                                  hintText: '请输入数量',
                                  keyboardType: TextInputType.number,
                                  callBack: (text) {
                                    stockModel.unboxNum = text;
                                    _model.editStockListWith(index, stockModel);
                                  }),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                          color: AppColors.FFF4F5F8, thickness: 1, height: 1),
                      //生产日期
                      ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text('生产日期',
                              style: const TextStyle(
                                  color: AppColors.FF2F4058, fontSize: 12.0)),
                        ),
                        title: Text(
                            stockModel.time.isNotEmpty
                                ? stockModel.time
                                : '请选择生产日期',
                            style: TextStyle(
                                color: stockModel.time.isNotEmpty
                                    ? AppColors.FF2F4058
                                    : AppColors.FFC1C8D7,
                                fontSize: 12.0)),
                        trailing: IconButton(
                            onPressed: () => _model.deleteStockListWith(index),
                            icon: Icon(Icons.delete_forever_outlined,
                                color: Colors.black)),
                        contentPadding: const EdgeInsets.all(0),
                        onTap: () async {
                          String time = await showPickerDate(context);
                          if (time != null) {
                            stockModel.time = time;
                            _model.editStockListWith(index, stockModel);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            }, childCount: _model.stockList.length)),
            //submit button
            SliverToBoxAdapter(
              child: SubmitBtn(title: '提  交', onPressed: () {}),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _editingController?.dispose();
    _focusNode?.dispose();
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
