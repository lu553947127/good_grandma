import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/work/market_material/market_material_model.dart';
import 'package:good_grandma/widgets/activity_add_text_cell.dart';
import 'package:good_grandma/widgets/select_form.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///新增市场物料
class MarketMaterialAdd extends StatefulWidget {
  final String title;
  MarketMaterialAdd({Key key, this.title}) : super(key: key);

  @override
  _MarketMaterialAddState createState() => _MarketMaterialAddState();
}

class _MarketMaterialAddState extends State<MarketMaterialAdd> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final MarketMaterialModel marketMaterialModel = Provider.of<MarketMaterialModel>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(widget.title, style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: Container(
                  height: 60,
                  color: Colors.white,
                  child: ListTile(
                    title:  Text('请添加${widget.title}物料信息', style: TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                    trailing: IconButton(
                        onPressed: () {
                          if (widget.title == '入库'){
                            marketMaterialModel.addWarehousingModel(WarehousingModel());
                          }else {
                            marketMaterialModel.addWarehouseModel(WarehouseModel());
                          }
                        },
                        icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
                  )
              )
          ),
          SliverVisibility(
            visible: widget.title == '入库' ? true : false,
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  WarehousingModel model = marketMaterialModel.warehousingList[index];
                  return Column(
                      children: [
                        SizedBox(height: index == 0 ? 1 : 10),
                        ActivityAddTextCell(
                            title: '物料',
                            hintText: '请选择物料',
                            value: model.materialAreName,
                            trailing: Icon(Icons.chevron_right),
                            onTap: () async {
                              Map select = await showSelectList(context, Api.materialNoPageList, '请选择物料', 'name');
                              model.materialAreaId = select['id'];
                              model.materialAreName = select['name'];
                              marketMaterialModel.editWarehousingModelWith(index, model);
                            }
                        ),
                        ActivityAddTextCell(
                            title: '数量',
                            hintText: '请输入数量',
                            value: model.surplus,
                            trailing: null,
                            onTap: () => AppUtil.showInputDialog(
                                context: context,
                                editingController: _editingController,
                                focusNode: _focusNode,
                                text: model.surplus,
                                hintText: '请输入数量',
                                keyboardType: TextInputType.number,
                                callBack: (text) {
                                  model.surplus = text;
                                  marketMaterialModel.editWarehousingModelWith(index, model);
                                })

                        ),
                        ActivityAddTextCell(
                            title: '损耗',
                            hintText: '请输入损耗',
                            value: model.loss,
                            trailing: null,
                            onTap: () => AppUtil.showInputDialog(
                                context: context,
                                editingController: _editingController,
                                focusNode: _focusNode,
                                text: model.loss,
                                hintText: '请输入损耗',
                                keyboardType: TextInputType.number,
                                callBack: (text) {
                                  model.loss = text;
                                  marketMaterialModel.editWarehousingModelWith(index, model);
                                })

                        ),
                        Container(
                            width: double.infinity,
                            color: Colors.white,
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                onPressed: (){
                                  marketMaterialModel.deleteWarehousingModelWith(index);
                                },
                                icon: Icon(Icons.delete, color: AppColors.FFDD0000)
                            )
                        )
                      ]
                  );
                }, childCount: marketMaterialModel.warehousingList.length)),
          ),
          SliverVisibility(
            visible: widget.title == '出库' ? true : false,
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  WarehouseModel model = marketMaterialModel.warehouseList[index];
                  return Column(
                      children: [
                        SizedBox(height: index == 0 ? 1 : 10),
                        ActivityAddTextCell(
                            title: '物料',
                            hintText: '请选择物料',
                            value: model.materialAreName,
                            trailing: Icon(Icons.chevron_right),
                            onTap: () async {
                              Map select = await showSelectList(context, Api.materialNoPageList, '请选择物料', 'name');
                              model.materialAreaId = select['id'];
                              model.materialAreName = select['name'];
                              model.newQuantity = select['stock'];
                              marketMaterialModel.editWarehouseModelWith(index, model);
                            }
                        ),
                        ActivityAddTextCell(
                            title: model.newQuantity == 0 ? '数量': '数量(${model.newQuantity})',
                            hintText: '请输入数量',
                            value: model.exWarehouse,
                            trailing: null,
                            onTap: () => model.newQuantity == 0 ? showToast('请先选择物料后再输入哦') :
                            AppUtil.showInputDialog(
                                context: context,
                                editingController: _editingController,
                                focusNode: _focusNode,
                                text: model.exWarehouse,
                                hintText: '请输入数量',
                                keyboardType: TextInputType.number,
                                callBack: (text) {
                                  if (int.parse(text) > model.newQuantity){
                                    showToast('输入数量超出限制了哦');
                                    return;
                                  }
                                  model.exWarehouse = text;
                                  marketMaterialModel.editWarehouseModelWith(index, model);
                                })
                        ),
                        Container(
                            width: double.infinity,
                            color: Colors.white,
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                onPressed: (){
                                  if (widget.title == '入库'){
                                    marketMaterialModel.deleteWarehousingModelWith(index);
                                  }else {
                                    marketMaterialModel.deleteWarehouseModelWith(index);
                                  }
                                },
                                icon: Icon(Icons.delete, color: AppColors.FFDD0000)
                            )
                        )
                      ]
                  );
                }, childCount: marketMaterialModel.warehouseList.length)),
          ),
          SliverToBoxAdapter(
              child: SizedBox(
                  width: double.infinity,
                  height: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                  )
              )
          ),
          SliverToBoxAdapter(
              child: ActivityAddTextCell(
                  title: '备注',
                  hintText: '请输入备注',
                  value: marketMaterialModel.remarks,
                  trailing: null,
                  onTap: () => AppUtil.showInputDialog(
                      context: context,
                      editingController: _editingController,
                      focusNode: _focusNode,
                      text: marketMaterialModel.remarks,
                      hintText: '请输入备注',
                      keyboardType: TextInputType.text,
                      callBack: (text) {
                        marketMaterialModel.setRemarks(text);
                      })
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

  ///出入库
  void _submitAction(BuildContext context, MarketMaterialModel marketMaterialModel) async {

    if (widget.title == '入库' && marketMaterialModel.warehousingMapList.length == 0){
      showToast('请添加入库物料信息');
      return;
    }

    if (widget.title == '出库' && marketMaterialModel.warehouseMapList.length == 0){
      showToast('请添加出库物料信息');
      return;
    }

    if (marketMaterialModel.remarks == ''){
      showToast('备注不能为空');
      return;
    }

    Map<String, dynamic> map;

    if (widget.title == '入库'){
      map = {
        'state': '1',
        'warehousing': marketMaterialModel.warehousingMapList,
        'remarks': marketMaterialModel.remarks
      };
      LogUtil.d('请求结果---入库----$map');
    }else {
      map = {
        'state': '2',
        'exwarehouse': marketMaterialModel.warehouseMapList,
        'remarks': marketMaterialModel.remarks
      };
      LogUtil.d('请求结果---出库----$map');
    }

    requestPost(Api.materialAdd, formData: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---materialAdd----$data');
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
