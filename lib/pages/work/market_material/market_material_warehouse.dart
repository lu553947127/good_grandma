import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/work/market_material/market_material_model.dart';
import 'package:good_grandma/widgets/activity_add_text_cell.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///出库
class MarketMaterialWarehouse extends StatefulWidget {
  final List<Map> materialList;
  const MarketMaterialWarehouse({Key key, this.materialList}) : super(key: key);

  @override
  _MarketMaterialWarehouseState createState() => _MarketMaterialWarehouseState();
}

class _MarketMaterialWarehouseState extends State<MarketMaterialWarehouse> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  ///是否是初始化完成
  bool _isEdit = false;

  ///初始化出库物料数据
  void initData(MarketMaterialModel marketMaterialModel) {
    _isEdit = true;
    widget.materialList.forEach((element) {
      marketMaterialModel.addWarehouseModel(WarehouseModel(
        materialAreaId: element['id'],
        materialAreName: element['materialName'],
        stock: element['stock'],
        exWarehouse: '',
        remarks: ''
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final MarketMaterialModel marketMaterialModel = Provider.of<MarketMaterialModel>(context);
    if (_isEdit == false){
      initData(marketMaterialModel);
    }
    return Scaffold(
      appBar: AppBar(title: Text('出库')),
      body: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                WarehouseModel model = marketMaterialModel.warehouseList[index];
                return Column(
                    children: [
                      SizedBox(height: index == 0 ? 1 : 10),
                      ActivityAddTextCell(
                          title: '区域物料',
                          hintText: model.materialAreName,
                          value: model.materialAreName,
                          trailing: null,
                          onTap: null
                      ),
                      ActivityAddTextCell(
                          title: '可用数量',
                          hintText: '${model.stock}',
                          value: '${model.stock}',
                          trailing: null,
                          onTap: null
                      ),
                      ActivityAddTextCell(
                          title: '出库数量',
                          hintText: '请输入出库数量',
                          value: model.exWarehouse,
                          trailing: null,
                          onTap: () => AppUtil.showInputDialog(
                              context: context,
                              editingController: _editingController,
                              focusNode: _focusNode,
                              text: model.exWarehouse,
                              hintText: '请输入出库数量',
                              keyboardType: TextInputType.number,
                              callBack: (text) {
                                if (int.parse(text) > model.stock){
                                  showToast('输入数量超出限制了哦');
                                  return;
                                }
                                model.exWarehouse = text;
                                marketMaterialModel.editWarehouseModelWith(index, model);
                              })
                      ),
                      ActivityAddTextCell(
                          title: '备注',
                          hintText: '请输入备注',
                          value: model.remarks,
                          trailing: null,
                          onTap: () => AppUtil.showInputDialog(
                              context: context,
                              editingController: _editingController,
                              focusNode: _focusNode,
                              text: model.remarks,
                              hintText: '请输入备注',
                              keyboardType: TextInputType.text,
                              callBack: (text) {
                                model.remarks = text;
                                marketMaterialModel.editWarehouseModelWith(index, model);
                              })
                      )
                    ]
                );
              }, childCount: marketMaterialModel.warehouseList.length)),
          SliverToBoxAdapter(
              child: SizedBox(
                  width: double.infinity,
                  height: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                  )
              )
          ),
          SliverSafeArea(
              sliver: SliverToBoxAdapter(
                  child: SubmitBtn(
                      title: '提  交',
                      onPressed: () {
                        _submitAction(context, marketMaterialModel);
                      }
                  )
              )
          )
        ]
      )
    );
  }

  ///出库
  void _submitAction(BuildContext context, MarketMaterialModel marketMaterialModel) async {

    for (WarehouseModel model in marketMaterialModel.warehouseList) {
      if (model.exWarehouse == ''){
        showToast('出库数量不能为空');
        return;
      }
    }

    Map<String, dynamic> map= {
      'state': '2',
      'exwarehouse': marketMaterialModel.warehouseMapList
    };

    LogUtil.d('请求结果---出库----$map');

    requestPost(Api.materialAdd, formData: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---materialWarehouse----$data');
      if (data['code'] == 200){
        showToast("成功");
        Navigator.pop(context, true);
      }else {
        showToast(data['msg']);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _editingController.dispose();
  }
}
