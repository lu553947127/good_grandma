import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/order/freezer_order/freezer_order_model.dart';
import 'package:good_grandma/widgets/activity_add_text_cell.dart';
import 'package:good_grandma/widgets/select_form.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///冰柜订单添加
class FreezerOrderAddPage extends StatefulWidget {
  final String id;
  final dynamic data;
  const FreezerOrderAddPage({Key key, this.id, this.data}) : super(key: key);

  @override
  _FreezerOrderAddPageState createState() => _FreezerOrderAddPageState();
}

class _FreezerOrderAddPageState extends State<FreezerOrderAddPage> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  ///是否是编辑
  bool _isEdit = false;
  ///标题
  String title = '新增冰柜订单';
  ///防止点击记录时间
  DateTime lastPopTime;

  ///编辑冰柜订单数据回显
  _freezerEdit(FreezerOrderModel freezerOrderModel){
    _isEdit = true;
    title = '编辑冰柜订单';

    List<Map> freezerOrderDetailList = (widget.data['freezerOrderDetail'] as List).cast();
    freezerOrderDetailList.forEach((element) {
      freezerOrderModel.addModel(FreezerModel(
          brand: element['brand'],
          brandName: element['brandName'],
          model: element['model'],
          modelName: element['modelName'],
          longCount: element['longCount'],
          returnCount: element['returnCount']
      ));
    });

    freezerOrderModel.setLinkName(widget.data['linkName']);
    freezerOrderModel.setLinkPhone(widget.data['linkPhone']);
    freezerOrderModel.setCustomerId(widget.data['customerId']);
    freezerOrderModel.setCustomerName(widget.data['customerName']);
    freezerOrderModel.setProvinceCode(widget.data['province']);
    freezerOrderModel.setProvinceName(widget.data['provinceName']);
    freezerOrderModel.setCityCode(widget.data['city']);
    freezerOrderModel.setCityName(widget.data['cityName']);
    freezerOrderModel.setAddress(widget.data['address']);
  }

  @override
  Widget build(BuildContext context) {
    final FreezerOrderModel freezerOrderModel = Provider.of<FreezerOrderModel>(context);
    if (_isEdit == false && widget.id != ''){
      _freezerEdit(freezerOrderModel);
    }
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: Container(
                  height: 60,
                  color: Colors.white,
                  child: ListTile(
                    title: const Text('添加冰柜',
                        style:
                        TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                    trailing: IconButton(
                        onPressed: () {
                          freezerOrderModel.addModel(FreezerModel());
                        },
                        icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
                  )
              )
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                FreezerModel model = freezerOrderModel.freezerList[index];
                return Column(
                    children: [
                      SizedBox(height: index == 0 ? 1 : 10),
                      ActivityAddTextCell(
                          title: '品牌',
                          hintText: '请选择品牌',
                          value: model.brandName,
                          trailing: Icon(Icons.chevron_right),
                          onTap: () async {
                            Map select = await showSelectList(context, Api.freezer_brand, '请选择品牌', 'dictValue');
                            model.brand = select['id'];
                            model.brandName = select['dictValue'];
                            freezerOrderModel.editModelWith(index, model);
                          }
                      ),
                      ActivityAddTextCell(
                          title: '规格',
                          hintText: '请选择规格',
                          value: model.modelName,
                          trailing: Icon(Icons.chevron_right),
                          onTap: () async {
                            if (model.brand == ''){
                              EasyLoading.showToast('请先选择品牌哦');
                              return;
                            }
                            Map select = await showSelectList(context, Api.freezer_model + model.brand, '请选择规格', 'dictValue');
                            model.model = select['dictKey'];
                            model.modelName = select['dictValue'];
                            freezerOrderModel.editModelWith(index, model);
                          }
                      ),
                      ActivityAddTextCell(
                          title: '长押数量',
                          hintText: '请输入长押数量',
                          value: model.longCount.toString(),
                          trailing: null,
                          onTap: () => AppUtil.showInputDialog(
                              context: context,
                              editingController: _editingController,
                              focusNode: _focusNode,
                              text: model.longCount.toString(),
                              hintText: '请输入长押数量',
                              keyboardType: TextInputType.number,
                              inputFormatters : [
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              callBack: (text) {
                                model.longCount = int.parse(text);
                                freezerOrderModel.editModelWith(index, model);
                              })
                      ),
                      ActivityAddTextCell(
                          title: '反押数量',
                          hintText: '请输入反押数量',
                          value: model.returnCount.toString(),
                          trailing: null,
                          onTap: () => AppUtil.showInputDialog(
                              context: context,
                              editingController: _editingController,
                              focusNode: _focusNode,
                              text: model.returnCount.toString(),
                              hintText: '请输入反押数量',
                              keyboardType: TextInputType.number,
                              inputFormatters : [
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              callBack: (text) {
                                model.returnCount = int.parse(text);
                                freezerOrderModel.editModelWith(index, model);
                              })
                      ),
                      Container(
                          width: double.infinity,
                          color: Colors.white,
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              onPressed: (){
                                freezerOrderModel.deleteModelWith(index);
                              },
                              icon: Icon(Icons.delete, color: AppColors.FFDD0000)
                          )
                      )
                    ]
                );
              }, childCount: freezerOrderModel.freezerList.length)),
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
                  title: '联系人',
                  hintText: '请输入联系人',
                  value: freezerOrderModel.linkName,
                  trailing: null,
                  onTap: () => AppUtil.showInputDialog(
                      context: context,
                      editingController: _editingController,
                      focusNode: _focusNode,
                      text: freezerOrderModel.linkName,
                      hintText: '请输入联系人',
                      keyboardType: TextInputType.text,
                      callBack: (text) {
                        freezerOrderModel.setLinkName(text);
                      })
              )
          ),
          SliverToBoxAdapter(
              child: ActivityAddTextCell(
                  title: '联系电话',
                  hintText: '请输入联系电话',
                  value: freezerOrderModel.linkPhone,
                  trailing: null,
                  onTap: () => AppUtil.showInputDialog(
                      context: context,
                      editingController: _editingController,
                      focusNode: _focusNode,
                      text: freezerOrderModel.linkPhone,
                      hintText: '请输入联系电话',
                      keyboardType: TextInputType.number,
                      callBack: (text) {
                        freezerOrderModel.setLinkPhone(text);
                      })
              )
          ),
          SliverToBoxAdapter(
              child: ActivityAddTextCell(
                  title: '公司名称',
                  hintText: '请选择公司名称',
                  value: freezerOrderModel.customerName,
                  trailing: Icon(Icons.chevron_right),
                  onTap: () async {
                    Map select = await showSelectList(context, Api.customerList, '请选择公司名称', 'corporateName');
                    freezerOrderModel.setCustomerId(select['id']);
                    freezerOrderModel.setCustomerName(select['corporateName']);
                  }
              )
          ),
          SliverToBoxAdapter(
              child: ActivityAddTextCell(
                  title: '地区（省）',
                  hintText: '请选择省',
                  value: freezerOrderModel.provinceName,
                  trailing: Icon(Icons.chevron_right),
                  onTap: () async {
                    Map<String, dynamic> map = {'code': '00'};
                    Map select = await showSelectListParameter(context, Api.regionSelect, '请选择省', 'name', map);
                    freezerOrderModel.setProvinceCode(select['code']);
                    freezerOrderModel.setProvinceName(select['name']);
                    freezerOrderModel.setCityCode('');
                    freezerOrderModel.setCityName('');
                  }
              )
          ),
          SliverToBoxAdapter(
              child: ActivityAddTextCell(
                  title: '地区（市）',
                  hintText: '请选择市',
                  value: freezerOrderModel.cityName,
                  trailing: Icon(Icons.chevron_right),
                  onTap: () async {
                    if (freezerOrderModel.provinceCode.isEmpty){
                      showToast('请先选择省');
                      return;
                    }
                    Map<String, dynamic> map = {'code': freezerOrderModel.provinceCode};
                    Map select = await showSelectListParameter(context, Api.regionSelect, '请选择市', 'name', map);
                    freezerOrderModel.setCityCode(select['code']);
                    freezerOrderModel.setCityName(select['name']);
                  }
              )
          ),
          SliverToBoxAdapter(
              child: ActivityAddTextCell(
                  title: '收货地址',
                  hintText: '请输入收货地址',
                  value: freezerOrderModel.address,
                  trailing: null,
                  onTap: () => AppUtil.showInputDialog(
                      context: context,
                      editingController: _editingController,
                      focusNode: _focusNode,
                      text: freezerOrderModel.address,
                      hintText: '请输入收货地址',
                      keyboardType: TextInputType.text,
                      callBack: (text) {
                        freezerOrderModel.setAddress(text);
                      })
              )
          ),
          SliverSafeArea(
              sliver: SliverToBoxAdapter(
                  child: SubmitBtn(
                      title: '提  交',
                      onPressed: () {
                        _submitAction(context, freezerOrderModel);
                      }
                  )
              )
          )
        ]
      )
    );
  }

  ///新增物料订单
  void _submitAction(BuildContext context, FreezerOrderModel freezerOrderModel) async {
    // 防重复提交
    if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 3)){
      lastPopTime = DateTime.now();
      freezerOrderSave(context, freezerOrderModel);
    }else{
      lastPopTime = DateTime.now();
      EasyLoading.showToast('请勿重复点击');
    }
  }

  ///添加方法
  void freezerOrderSave(BuildContext context, FreezerOrderModel freezerOrderModel){
    if (freezerOrderModel.freezerList.length == 0){
      EasyLoading.showToast('请添加冰柜信息');
      return;
    }

    if (freezerOrderModel.linkName == ''){
      EasyLoading.showToast('联系人不能为空');
      return;
    }

    if (freezerOrderModel.linkPhone == ''){
      EasyLoading.showToast('联系电话不能为空');
      return;
    }

    if (freezerOrderModel.customerId == ''){
      EasyLoading.showToast('客户不能为空');
      return;
    }

    if (freezerOrderModel.provinceCode == ''){
      EasyLoading.showToast('地区不能为空');
      return;
    }

    if (freezerOrderModel.address == ''){
      EasyLoading.showToast('收货地址不能为空');
      return;
    }

    Map<String, dynamic> map = {
      'id': widget.id,
      'freezerOrderDetail': freezerOrderModel.freezerMapList,
      'linkName': freezerOrderModel.linkName,
      'linkPhone': freezerOrderModel.linkPhone,
      'customerId': freezerOrderModel.customerId,
      'province': freezerOrderModel.provinceCode,
      'city': freezerOrderModel.cityCode,
      'address': freezerOrderModel.address
    };

    LogUtil.d('请求结果---freezerOrderSave----$map');

    requestPost(Api.freezerOrderSave, formData: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---freezerOrderSave----$data');
      if (data['code'] == 200){
        EasyLoading.showToast("成功");
        Navigator.pop(context, true);
      }else {
        EasyLoading.showToast(data['msg']);
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
