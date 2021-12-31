import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/order/material_order/material_order_model.dart';
import 'package:good_grandma/widgets/activity_add_text_cell.dart';
import 'package:good_grandma/widgets/select_form.dart';
import 'package:good_grandma/widgets/select_tree.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///添加物料订单页面
class MaterialOrderAddPage extends StatefulWidget {
  final String id;
  final dynamic data;
  final String newKey;
  const MaterialOrderAddPage({Key key, this.id, this.data, this.newKey}) : super(key: key);

  @override
  _MaterialOrderAddPageState createState() => _MaterialOrderAddPageState();
}

class _MaterialOrderAddPageState extends State<MaterialOrderAddPage> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isEdit = false;

  String title = '新增物料订单';

  ///编辑物料订单数据回显
  _materialEdit(MarketingOrderModel marketingOrderModel){
    _isEdit = true;
    title = '编辑物料订单';
    marketingOrderModel.setCompany(widget.data['company']);
    List<Map> materialDetailsList = (widget.data['materialDetailsVOS'] as List).cast();
    materialDetailsList.forEach((element) {
      List<Map> materialDetails = (element['materialDetails'] as List).cast();
      marketingOrderModel.addCustomerModel(CustomerModel(
          withGoods: element['withGoods'].toString(),
          deptId: element['deptId'],
          deptName: element['deptName'],
          customerId: element['customerId'],
          customerName: element['customerName'],
          address: element['address'],
          phone: element['phone']
      ), materialDetails);
    });
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
            child: ActivityAddTextCell(
                title: '公司',
                hintText: '请选择公司',
                value: marketingOrderModel.company,
                trailing: Icon(Icons.chevron_right),
                onTap: () async {
                  Map select = await showSelectList(context, Api.materialCompany, '请选择公司', 'name');
                  marketingOrderModel.setCompany(select['name']);
                }
            )
          ),
          SliverToBoxAdapter(
              child: Container(
                  height: 60,
                  color: Colors.white,
                  child: ListTile(
                    title: const Text('请添加客户信息',
                        style:
                        TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                    trailing: IconButton(
                        onPressed: () {
                          marketingOrderModel.addCustomerModel(CustomerModel(), null);
                        },
                        icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
                  )
              )
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                CustomerModel model = marketingOrderModel.customerList[index];
                return Column(
                    children: [
                      SizedBox(height: index == 0 ? 1 : 10),
                      Container(
                          height: 60,
                          color: Colors.white,
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('是否随货',style: TextStyle(fontSize: 14,color: Color(0XFF333333))),
                                Checkbox(
                                    value: model.withGoods == '1',
                                    activeColor: Color(0xFFC68D3E),
                                    onChanged: (value){
                                      if (value){
                                        model.withGoods = '1';
                                      }else{
                                        model.withGoods = '2';
                                      }
                                      marketingOrderModel.editCustomerModelWith(index, model);
                                    }
                                )
                              ]
                          )
                      ),
                      ActivityAddTextCell(
                          title: '区域',
                          hintText: '请选择区域',
                          value: model.deptName,
                          trailing: Icon(Icons.chevron_right),
                          onTap: () async {
                            Map area = await showSelectTreeList(context, '');
                            model.deptId = area['deptId'];
                            model.deptName = area['areaName'];
                            _materialBudget(marketingOrderModel, model,  index, area['deptId']);
                          }
                      ),
                      Visibility(
                          visible: model.deptId.isNotEmpty,
                          child: ActivityAddTextCell(
                              title: '预算',
                              hintText: '',
                              value: '${model.surplus}',
                              trailing: null,
                              onTap: null
                          )
                      ),
                      ActivityAddTextCell(
                          title: '经销商',
                          hintText: '请选择经销商',
                          value: model.customerName,
                          trailing: Icon(Icons.chevron_right),
                          onTap: () async {
                            if(model.deptId == ''){
                              showToast("请先选择区域，再选择经销商");
                              return;
                            }
                            Map<String, dynamic> map = {'deptId': model.deptId, 'type': 'material'};
                            Map select = await showSelectListParameter(context, Api.deptIdUser, '请选择经销商', 'corporateName', map);
                            model.customerId = select['id'];
                            model.customerName = select['corporateName'];
                            model.address = select['address'];
                            marketingOrderModel.editCustomerModelWith(index, model);
                          }
                      ),
                      ActivityAddTextCell(
                          title: '物料地址',
                          hintText: '请输入物料地址',
                          value: model.address,
                          trailing: null,
                          onTap: () => AppUtil.showInputDialog(
                              context: context,
                              editingController: _editingController,
                              focusNode: _focusNode,
                              text: model.address,
                              hintText: '请输入物料地址',
                              keyboardType: TextInputType.text,
                              callBack: (text) {
                                model.address = text;
                                marketingOrderModel.editCustomerModelWith(index, model);
                              })
                      ),
                      ActivityAddTextCell(
                          title: '联系电话',
                          hintText: '请输联系电话',
                          value: model.phone,
                          trailing: null,
                          onTap: () => AppUtil.showInputDialog(
                              context: context,
                              editingController: _editingController,
                              focusNode: _focusNode,
                              text: model.phone,
                              hintText: '请输联系电话',
                              keyboardType: TextInputType.number,
                              callBack: (text) {
                                model.phone = text;
                                marketingOrderModel.editCustomerModelWith(index, model);
                              })
                      ),
                      Container(
                          height: 60,
                          color: Colors.white,
                          child: ListTile(
                            title: const Text('请添加物料信息',
                                style:
                                TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                            trailing: IconButton(
                                onPressed: () {
                                  model.addModel(MarketingModel());
                                  marketingOrderModel.notifyListeners();
                                },
                                icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
                          )
                      ),
                      ListView.builder(
                          shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                          physics:NeverScrollableScrollPhysics(),//禁止滚动
                          itemCount: model.materList.length,
                          itemBuilder: (content, index){
                            MarketingModel marketingModel = model.materList[index];
                            return Container(
                                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                                child: Column(
                                    children: [
                                      SizedBox(height: index == 0 ? 1 : 10),
                                      ActivityAddTextCell(
                                          title: '物料',
                                          hintText: '请选择物料',
                                          value: marketingModel.materialName,
                                          trailing: Icon(Icons.chevron_right),
                                          onTap: () async {
                                            Map select = await showSelectList(context, Api.materialSelectList, '请选择物料', 'name');
                                            marketingModel.materialId = select['id'];
                                            marketingModel.materialName = select['name'];
                                            marketingModel.newQuantity = select['quantity'];
                                            marketingModel.unitPrice = select['unitPrice'];
                                            model.editModelWith(index, marketingModel);
                                            marketingOrderModel.notifyListeners();
                                          }
                                      ),
                                      ActivityAddTextCell(
                                          title: marketingModel.newQuantity == 0 ? '数量': '数量(${marketingModel.newQuantity})',
                                          hintText: '请输入数量',
                                          value: marketingModel.quantity,
                                          trailing: null,
                                          onTap: () => marketingModel.newQuantity == 0 ? showToast('请先选择物料后再输入哦') :
                                          AppUtil.showInputDialog(
                                              context: context,
                                              editingController: _editingController,
                                              focusNode: _focusNode,
                                              text: marketingModel.quantity,
                                              hintText: '请输入数量',
                                              keyboardType: TextInputType.number,
                                              callBack: (text) {
                                                if (int.parse(text) > marketingModel.newQuantity){
                                                  showToast('输入数量超出限制了哦');
                                                  return;
                                                }
                                                marketingModel.quantity = text;
                                                model.editModelWith(index, marketingModel);
                                                marketingOrderModel.notifyListeners();
                                              })
                                      ),
                                      ActivityAddTextCell(
                                          title: '单价',
                                          hintText: '',
                                          value: marketingModel.unitPrice,
                                          trailing: null,
                                          onTap: null
                                      ),
                                      Container(
                                          width: double.infinity,
                                          color: Colors.white,
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                              onPressed: (){
                                                model.deleteModelWith(index);
                                                marketingOrderModel.notifyListeners();
                                              },
                                              icon: Icon(Icons.delete, color: AppColors.FFDD0000)
                                          )
                                      )
                                    ]
                                )
                            );
                          }
                      ),
                      Container(
                          width: double.infinity,
                          color: Colors.white,
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              onPressed: (){
                                marketingOrderModel.deleteCustomerModelWith(index);
                              },
                              icon: Icon(Icons.delete, color: AppColors.FFDD0000)
                          )
                      )
                    ]
                );
              }, childCount: marketingOrderModel.customerList.length)),
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

  ///获取预算
  Future<void> _materialBudget(MarketingOrderModel marketingOrderModel, CustomerModel model,
      int index, String deptId) async{
    Map<String, dynamic> map = {'deptId': deptId};
    requestGet(Api.materialBudget, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---materialBudget----$data');
      model.surplus = double.parse(data['data']['surplus']) ?? 0;
      marketingOrderModel.editCustomerModelWith(index, model);
    });
  }

  ///新增/编辑物料订单
  void _submitAction(BuildContext context, MarketingOrderModel marketingOrderModel) async {

    if (marketingOrderModel.company == ''){
      showToast('请选择公司');
      return;
    }

    if (marketingOrderModel.customerList.length == 0){
      showToast('请添加客户信息');
      return;
    }

    for (CustomerModel model in marketingOrderModel.customerList) {
      if (model.deptId == ''){
        showToast('区域不能为空');
        return;
      }
      if (model.customerId == ''){
        showToast('经销商不能为空');
        return;
      }
      if (model.address == ''){
        showToast('物料地址不能为空');
        return;
      }

      if (model.materList.length == 0){
        showToast('请添加物料信息');
        return;
      }

      for (MarketingModel marketingModel in model.materList) {
        if (marketingModel.materialId == ''){
          showToast('物料不能为空');
          return;
        }
        if (marketingModel.quantity == ''){
          showToast('数量不能为空');
          return;
        }
      }
    }

    Map<String, dynamic> map = {
      'id': widget.id,
      'key': widget.newKey,
      'company': marketingOrderModel.company,
      'materialDetailsVOS': marketingOrderModel.customerMapList
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
