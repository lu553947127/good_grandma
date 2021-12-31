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

///入库
class MarketMaterialAdd extends StatefulWidget {
  MarketMaterialAdd({Key key}) : super(key: key);

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
      appBar: AppBar(title: Text('入库')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: ActivityAddTextCell(
                  title: '经销商',
                  hintText: '请选择经销商',
                  value: marketMaterialModel.customerName,
                  trailing: Icon(Icons.chevron_right),
                  onTap: () async {
                    Map<String, dynamic> map = {'type': 'material'};
                    Map select = await showSelectListParameter(context, Api.deptIdUser, '请选择经销商', 'corporateName', map);
                    marketMaterialModel.setCustomerId(select['id']);
                    marketMaterialModel.setCustomerName(select['corporateName']);
                  }
              )
          ),
          SliverToBoxAdapter(
              child: Container(
                  height: 60,
                  color: Colors.white,
                  child: ListTile(
                    title:  Text('请添加入库物料信息', style: TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                    trailing: IconButton(
                        onPressed: () {
                          marketMaterialModel.addWarehousingModel(WarehousingModel());
                        },
                        icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
                  )
              )
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                WarehousingModel model = marketMaterialModel.warehousingList[index];
                return Column(
                    children: [
                      SizedBox(height: index == 0 ? 1 : 10),
                      ActivityAddTextCell(
                          title: '区域物料',
                          hintText: '请选择区域物料',
                          value: model.materialAreName,
                          trailing: Icon(Icons.chevron_right),
                          onTap: () async {
                            if(marketMaterialModel.customerId == ''){
                              showToast("请先选择经销商，再选择物料");
                              return;
                            }
                            Map<String, dynamic> map = {'customerId': marketMaterialModel.customerId};
                            Map select = await showSelectListParameter(context, Api.areaMaterial, '请选择区域物料', 'name', map);
                            model.materialAreaId = select['id'];
                            model.materialAreName = select['name'];
                            marketMaterialModel.editWarehousingModelWith(index, model);
                          }
                      ),
                      ActivityAddTextCell(
                          title: '入库数量',
                          hintText: '请输入入库数量',
                          value: model.surplus,
                          trailing: null,
                          onTap: () => AppUtil.showInputDialog(
                              context: context,
                              editingController: _editingController,
                              focusNode: _focusNode,
                              text: model.surplus,
                              hintText: '请输入入库数量',
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

  ///入库
  void _submitAction(BuildContext context, MarketMaterialModel marketMaterialModel) async {

    if (marketMaterialModel.customerId == ''){
      showToast('经销商不能为空');
      return;
    }

    if (marketMaterialModel.warehousingMapList.length == 0){
      showToast('请添加入库物料信息');
      return;
    }

    for (WarehousingModel model in marketMaterialModel.warehousingList) {
      if (model.materialAreaId == ''){
        showToast('区域物料不能为空');
        return;
      }
      if (model.surplus == ''){
        showToast('入库数量不能为空');
        return;
      }
      if (model.loss == ''){
        showToast('损耗不能为空');
        return;
      }
    }

    Map<String, dynamic>  map = {
      'state': '1',
      'customerId': marketMaterialModel.customerId,
      'warehousing': marketMaterialModel.warehousingMapList
    };

    LogUtil.d('请求结果---入库----$map');

    requestPost(Api.materialAdd, formData: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---materialWarehousing----$data');
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
