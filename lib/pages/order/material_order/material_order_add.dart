import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/order/material_order/material_order_model.dart';
import 'package:good_grandma/widgets/activity_add_text_cell.dart';
import 'package:good_grandma/widgets/add_text_select.dart';
import 'package:good_grandma/widgets/select_form.dart';
import 'package:good_grandma/widgets/select_tree.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///添加物料订单页面
class MaterialOrderAddPage extends StatefulWidget {
  final String id;
  final dynamic data;
  const MaterialOrderAddPage({Key key, this.id, this.data}) : super(key: key);

  @override
  _MaterialOrderAddPageState createState() => _MaterialOrderAddPageState();
}

class _MaterialOrderAddPageState extends State<MaterialOrderAddPage> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isWithGoods = false;//是否随货
  bool _isEdit = false;

  String title = '新增物料订单';

  ///编辑物料订单数据回显
  _materialEdit(MarketingOrderModel marketingOrderModel){
    _isEdit = true;
    title = '编辑物料订单';
    marketingOrderModel.setDeptId(widget.data['deptId']);
    marketingOrderModel.setDeptName(widget.data['deptName']);

    List<Map> materialDetailsList = (widget.data['materialDetailsVOS'] as List).cast();
    materialDetailsList.forEach((element) {
      marketingOrderModel.addModel(MarketingModel(
        materialId: element['materialId'],
        materialName: element['materialName'],
        quantity: element['quantity'].toString(),
        unitPrice: element['unitPrice'].toString()
      ));
    });

    if (widget.data['withGoods'] == 1){
      marketingOrderModel.setWithGoods('1');
      _isWithGoods = true;
    }else{
      marketingOrderModel.setWithGoods('2');
      _isWithGoods = false;
    }

    marketingOrderModel.setCustomerName(widget.data['customerName']);
    marketingOrderModel.setAddress(widget.data['address']);

    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final MarketingOrderModel marketingOrderModel = Provider.of<MarketingOrderModel>(context);
    if (_isEdit == false && widget.id != ''){
      _materialEdit(marketingOrderModel);
    }
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: TextSelectView(
                  leftTitle: '区域',
                  rightPlaceholder: '请选择区域',
                  value: marketingOrderModel.deptName,
                  onPressed: () async{
                    Map area = await showSelectTreeList(context, '');
                    marketingOrderModel.setDeptId(area['deptId']);
                    marketingOrderModel.setDeptName(area['areaName']);
                    return area['areaName'];
                  }
              )
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
            child: Container(
              height: 60,
              color: Colors.white,
              child: ListTile(
                title: const Text('请添加物料信息',
                    style:
                    TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                trailing: IconButton(
                    onPressed: () {
                      marketingOrderModel.addModel(MarketingModel());
                    },
                    icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
              )
            )
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                MarketingModel model = marketingOrderModel.materList[index];
                return Column(
                  children: [
                    SizedBox(height: index == 0 ? 1 : 10),
                    ActivityAddTextCell(
                        title: '物料',
                        hintText: '请选择物料',
                        value: model.materialName,
                        trailing: Icon(Icons.chevron_right),
                        onTap: () async {
                          Map select = await showSelectList(context, Api.materialSelectList, '请选择物料', 'name');
                          model.materialId = select['id'];
                          model.materialName = select['name'];
                          model.newQuantity = select['quantity'];
                          model.unitPrice = select['unitPrice'];
                          marketingOrderModel.editModelWith(index, model);
                        }
                    ),
                    ActivityAddTextCell(
                        title: model.newQuantity == 0 ? '数量': '数量(${model.newQuantity})',
                        hintText: '请输入数量',
                        value: model.quantity,
                        trailing: null,
                        onTap: () => model.newQuantity == 0 ? showToast('请先选择物料后再输入哦') :
                        AppUtil.showInputDialog(
                            context: context,
                            editingController: _editingController,
                            focusNode: _focusNode,
                            text: model.quantity,
                            hintText: '请输入数量',
                            keyboardType: TextInputType.number,
                            callBack: (text) {
                              if (int.parse(text) > model.newQuantity){
                                showToast('输入数量超出限制了哦');
                                return;
                              }
                              model.quantity = text;
                              marketingOrderModel.editModelWith(index, model);
                            })
                    ),
                    ActivityAddTextCell(
                        title: '单价',
                        hintText: '',
                        value: model.unitPrice,
                        trailing: null,
                        onTap: null
                    ),
                    Container(
                        width: double.infinity,
                        color: Colors.white,
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: (){
                              marketingOrderModel.deleteModelWith(index);
                            },
                            icon: Icon(Icons.delete, color: AppColors.FFDD0000)
                        )
                    )
                  ]
                );
              }, childCount: marketingOrderModel.materList.length)),
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
            child: Container(
                height: 60,
                color: Colors.white,
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('是否随货',style: TextStyle(fontSize: 14,color: Color(0XFF333333))),
                    Checkbox(
                        value: _isWithGoods,
                        activeColor: Color(0xFFC68D3E),
                        onChanged: (value){
                          if (value){
                            marketingOrderModel.setWithGoods('1');
                          }else{
                            marketingOrderModel.setWithGoods('2');
                          }
                          setState(() {
                            _isWithGoods = value;
                          });
                        }
                    )
                  ]
              )
            )
          ),
          SliverToBoxAdapter(
              child: SizedBox(
                  width: double.infinity,
                  height: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                  )
              )
          ),
          SliverToBoxAdapter(
              child: ActivityAddTextCell(
                  title: '经销商名称',
                  hintText: '请输入经销商名称',
                  value: marketingOrderModel.customerName,
                  trailing: null,
                  onTap: () => AppUtil.showInputDialog(
                      context: context,
                      editingController: _editingController,
                      focusNode: _focusNode,
                      text: marketingOrderModel.customerName,
                      hintText: '请输入经销商名称',
                      keyboardType: TextInputType.text,
                      callBack: (text) {
                        marketingOrderModel.setCustomerName(text);
                      })
              )
          ),
          SliverToBoxAdapter(
              child: ActivityAddTextCell(
                  title: '物料地址',
                  hintText: '请输入物料地址',
                  value: marketingOrderModel.address,
                  trailing: null,
                  onTap: () => AppUtil.showInputDialog(
                      context: context,
                      editingController: _editingController,
                      focusNode: _focusNode,
                      text: marketingOrderModel.address,
                      hintText: '请输入物料地址',
                      keyboardType: TextInputType.text,
                      callBack: (text) {
                        marketingOrderModel.setAddress(text);
                      })
              )
          ),
          SliverSafeArea(
              sliver: SliverToBoxAdapter(
                  child: SubmitBtn(
                      title: '提  交',
                      onPressed: () {
                        _submitAction(context, marketingOrderModel);
                      }
                  )
              )
          )
        ]
      )
    );
  }

  ///新增物料订单
  void _submitAction(BuildContext context, MarketingOrderModel marketingOrderModel) async {

    if (marketingOrderModel.deptId == ''){
      showToast('区域不能为空');
      return;
    }

    if (marketingOrderModel.materList.length == 0){
      showToast('请添加物料信息');
      return;
    }

    if (marketingOrderModel.customerName == ''){
      showToast('经销商名称不能为空');
      return;
    }

    if (marketingOrderModel.address == ''){
      showToast('地址不能为空');
      return;
    }

    Map<String, dynamic> map = {
      'id': widget.id,
      'deptId': marketingOrderModel.deptId,
      'materialDetails': marketingOrderModel.mapList,
      'withGoods': marketingOrderModel.withGoods,
      'customerName': marketingOrderModel.customerName,
      'address': marketingOrderModel.address
    };

    String url = '';
    if (widget.id != ''){
      url = Api.materialOrderEdit;
    }else {
      url = Api.materialOrderAdd;
    }

    LogUtil.d('请求结果---$url----$map');

    requestPost(url, formData: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---$url----$data');
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
