import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/marketing_activity_model.dart';
import 'package:good_grandma/widgets/activity_add_text_cell.dart';
import 'package:good_grandma/widgets/select_form.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///新增市场活动
class AddMarketingActivityPage extends StatefulWidget {
  final String id;
  const AddMarketingActivityPage({Key key, this.id}) : super(key: key);

  @override
  _AddMarketingActivityPageState createState() =>
      _AddMarketingActivityPageState();
}

class _AddMarketingActivityPageState extends State<AddMarketingActivityPage> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isEdit = false;
  String title = '新增市场活动';

  ///编辑市场活动数据回显
  _marketingActivityEdit(MarketingActivityModel activityModel){
    _isEdit = true;
    title = '编辑市场活动';

    Map<String, dynamic> map = {'id': widget.id};
    LogUtil.d('请求结果---activityDetail----$map');
    requestGet(Api.activityDetail, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---activityDetail----$data');
      activityModel.setName(data['data']['name']);
      activityModel.setStartTime(data['data']['starttime']);
      activityModel.setEndTime(data['data']['endtime']);
      activityModel.setCustomerName(data['data']['customerName']);
      activityModel.setSketch(data['data']['sketch']);
      activityModel.setPurchaseMoney(data['data']['purchasemoney']);

      List<Map> activityCosts = (data['data']['activityCosts'] as List).cast();
      activityCosts.forEach((element) {
        activityModel.addSampleModel(SampleModel(
            materialAreaId: element['materialAreaId'],
            materialAreaName: element['materialName'],
            sample: element['sample'],
            costDescribe: element['costDescribe']
        ));
      });

      List<Map> activityCostList = (data['data']['activityCostList'] as List).cast();
      activityCostList.forEach((element) {
        activityModel.addCostModel(CostModel(
            costType: element['costType'].toString(),
            costTypeName: element['costTypeName'],
            costCash: element['costCash'].toString(),
            costDescribe: element['costDescribe']
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final MarketingActivityModel activityModel = Provider.of<MarketingActivityModel>(context);
    if (_isEdit == false && widget.id != ''){
      _marketingActivityEdit(activityModel);
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Scrollbar(
          child: CustomScrollView(
            slivers: [
              //活动信息
              SliverToBoxAdapter(
                child: ListTile(
                    title: const Text('活动信息',
                        style: TextStyle(
                            color: AppColors.FF959EB1, fontSize: 12.0))),
              ),
              SliverToBoxAdapter(
                child: ActivityAddTextCell(
                  title: '活动名称',
                  hintText: '请输入活动名称',
                  value: activityModel.name,
                  trailing: null,
                  onTap: () => AppUtil.showInputDialog(
                      context: context,
                      editingController: _editingController,
                      focusNode: _focusNode,
                      text: activityModel.name,
                      hintText: '请输入活动名称',
                      keyboardType: null,
                      callBack: (text) {
                        activityModel.setName(text);
                      })
                )
              ),
              SliverToBoxAdapter(
                  child: ActivityAddTextCell(
                      title: '开始时间',
                      hintText: '请选择开始时间',
                      value: activityModel.startTime,
                      trailing: Icon(Icons.chevron_right),
                      onTap: () async{
                        //开始时间
                        String result = await showPickerDate(context);
                        if (result != null && result.isNotEmpty) {
                          activityModel.setStartTime(result);
                        }
                      }
                  )
              ),
              SliverToBoxAdapter(
                  child: ActivityAddTextCell(
                      title: '结束时间',
                      hintText: '请选择结束时间',
                      value: activityModel.endTime,
                      trailing: Icon(Icons.chevron_right),
                      onTap: () async{
                        //开始时间
                        String result = await showPickerDate(context);
                        if (result != null && result.isNotEmpty) {
                          activityModel.setEndTime(result);
                        }
                      }
                  )
              ),
              SliverToBoxAdapter(
                  child: ActivityAddTextCell(
                      title: '上级通路客户',
                      hintText: '请输入上级通路客户',
                      value: activityModel.customerName,
                      trailing: null,
                      onTap: () => AppUtil.showInputDialog(
                          context: context,
                          editingController: _editingController,
                          focusNode: _focusNode,
                          text: activityModel.customerName,
                          hintText: '请输入上级通路客户',
                          keyboardType: null,
                          callBack: (text) {
                            activityModel.setCustomerName(text);
                          })
                  )
              ),
              //活动简述
              SliverToBoxAdapter(
                  child: ActivityAddTextCell(
                      title: '活动简述',
                      hintText: '请输入活动简述',
                      value: activityModel.sketch,
                      trailing: null,
                      onTap: () => AppUtil.showInputDialog(
                          context: context,
                          editingController: _editingController,
                          focusNode: _focusNode,
                          text: activityModel.sketch,
                          hintText: '请输入活动简述',
                          keyboardType: TextInputType.text,
                          callBack: (text) {
                            activityModel.setSketch(text);
                          })

                  )
              ),
              SliverToBoxAdapter(
                child: ListTile(
                    title: const Text('试吃品',
                        style: TextStyle(
                            color: AppColors.FF959EB1, fontSize: 12.0))),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 60,
                  color: Colors.white,
                  child: ListTile(
                    title: const Text('请添加试吃品',
                        style:
                        TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                    trailing: IconButton(
                        onPressed: () async {
                          // Map select = await showSelectList(context, Api.materialSelectList, '请选择物料', 'materialName');
                          activityModel.addSampleModel(SampleModel());
                        },
                        icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
                  )
                )
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    SampleModel sampleModel = activityModel.sampleList[index];
                    return Column(
                      children: [
                        SizedBox(height: index == 0 ? 1 : 10),
                        ActivityAddTextCell(
                            title: '物料名称',
                            hintText: '请选择物料名称',
                            value: sampleModel.materialAreaName,
                            trailing: Icon(Icons.chevron_right),
                            onTap: () async {
                              Map<String, dynamic> map = {'type': '1'};
                              Map select = await showSelectListParameter(context, Api.materialNoPageList, '请选择物料名称', 'name', map);
                              sampleModel.materialAreaId = select['id'];
                              sampleModel.materialAreaName = select['name'];
                              sampleModel.newQuantity = select['stock'];
                              activityModel.editSampleModelWith(index, sampleModel);
                            }
                        ),
                        ActivityAddTextCell(
                            title: sampleModel.newQuantity == 0 ? '试吃品(箱)/数量': '试吃品(箱)/数量(${sampleModel.newQuantity})',
                            hintText: '请输入试吃品(箱)/数量',
                            value: sampleModel.sample.toString(),
                            trailing: null,
                            onTap: () => sampleModel.newQuantity == 0 ? showToast('请先选择物料后再输入哦') :
                            AppUtil.showInputDialog(
                                context: context,
                                editingController: _editingController,
                                focusNode: _focusNode,
                                text: sampleModel.sample.toString(),
                                hintText: '请输入数量',
                                keyboardType: TextInputType.number,
                                inputFormatters : [
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                callBack: (text) {
                                  if (int.parse(text) > sampleModel.newQuantity){
                                    showToast('输入数量超出限制了哦');
                                    return;
                                  }
                                  sampleModel.sample = int.parse(text);
                                  activityModel.editSampleModelWith(index, sampleModel);
                                })
                        ),
                        ActivityAddTextCell(
                            title: '费用描述',
                            hintText: '请输入费用描述',
                            value: sampleModel.costDescribe,
                            trailing: null,
                            onTap: () => AppUtil.showInputDialog(
                                context: context,
                                editingController: _editingController,
                                focusNode: _focusNode,
                                text: sampleModel.costDescribe,
                                hintText: '请输入费用描述',
                                keyboardType: TextInputType.text,
                                callBack: (text) {
                                  sampleModel.costDescribe = text;
                                  activityModel.editSampleModelWith(index, sampleModel);
                                })

                        ),
                        Container(
                            width: double.infinity,
                            color: Colors.white,
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                onPressed: (){
                                  activityModel.deleteSampleModelWith(index);
                                },
                                icon: Icon(Icons.delete, color: AppColors.FFDD0000)
                            )
                        )
                      ]
                    );
                  }, childCount: activityModel.sampleList.length)),
              SliverToBoxAdapter(
                child: ListTile(
                    title: const Text('费用信息',
                        style: TextStyle(
                            color: AppColors.FF959EB1, fontSize: 12.0))),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 60,
                  color: Colors.white,
                  child: ListTile(
                    title: const Text('请添加费用信息',
                        style:
                        TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                    trailing: IconButton(
                        onPressed: () async {
                          activityModel.addCostModel(CostModel(
                              costType: '4',
                              costTypeName: '其他费用',
                              costCash: '',
                              costDescribe: ''
                          ));
                        },
                        icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
                  )
                )
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    CostModel costModel = activityModel.costList[index];
                    return Column(
                      children: [
                        SizedBox(height: index == 0 ? 1 : 10),
                        ActivityAddTextCell(
                            title: '费用类别',
                            hintText: '',
                            value: costModel.costTypeName,
                            trailing: costModel.costTypeName == '其他费用' ?
                            IconButton(
                                onPressed: (){
                                  activityModel.deleteCostModelWith(index);
                                },
                                icon: Icon(Icons.delete, color: AppColors.FFDD0000)
                            ) : null,
                            onTap: null
                        ),
                        ActivityAddTextCell(
                            title: '现金',
                            hintText: '请输入现金',
                            value: costModel.costCash,
                            trailing: Text('元'),
                            onTap: () => AppUtil.showInputDialog(
                                context: context,
                                editingController: _editingController,
                                focusNode: _focusNode,
                                text: costModel.costCash,
                                hintText: '请输入现金',
                                keyboardType: TextInputType.number,
                                callBack: (text) {
                                  costModel.costCash = text;
                                  activityModel.editCostModelWith(index, costModel);
                                })
                        ),
                        ActivityAddTextCell(
                            title: '费用描述',
                            hintText: '请输入费用描述',
                            value: costModel.costDescribe,
                            trailing: null,
                            onTap: () => AppUtil.showInputDialog(
                                context: context,
                                editingController: _editingController,
                                focusNode: _focusNode,
                                text: costModel.costDescribe,
                                hintText: '请输入费用描述',
                                keyboardType: TextInputType.text,
                                callBack: (text) {
                                  costModel.costDescribe = text;
                                  activityModel.editCostModelWith(index, costModel);
                                })

                        )
                      ]
                    );
                  }, childCount: activityModel.costList.length)),
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
                      title: '预计进货额(元)',
                      hintText: '请输入预计进货额(元)',
                      value: activityModel.purchaseMoney,
                      trailing: null,
                      onTap: () => AppUtil.showInputDialog(
                          context: context,
                          editingController: _editingController,
                          focusNode: _focusNode,
                          text: activityModel.purchaseMoney,
                          hintText: '请输入预计进货额(元)',
                          keyboardType: TextInputType.number,
                          callBack: (text) {
                            activityModel.setPurchaseMoney(text);
                          })
                  )
              ),
              //提  交
              SliverSafeArea(
                sliver: SliverToBoxAdapter(
                  child: SubmitBtn(
                      title: '提  交',
                      onPressed: () {
                        _submitAction(context, activityModel);
                      })
                )
              )
            ]
          )
        )
      )
    );
  }

  ///添加/编辑市场活动
  void _submitAction(BuildContext context, MarketingActivityModel activityModel) async {

    if (activityModel.name == ''){
      showToast('活动名称不能为空');
      return;
    }

    if (activityModel.startTime == ''){
      showToast('开始时间不能为空');
      return;
    }

    if (activityModel.endTime == ''){
      showToast('结束时间不能为空');
      return;
    }

    if (activityModel.customerName == ''){
      showToast('上级通路客户不能为空');
      return;
    }

    if (activityModel.sketch == ''){
      showToast('活动简述不能为空');
      return;
    }

    if (activityModel.sampleList.length == 0){
      showToast('试吃品不能为空');
      return;
    }

    activityModel.sampleList.forEach((element) {
      if (element.materialAreaId == ''){
        showToast('试吃品物料名称不能为空');
        return;
      }
    });

    activityModel.costList.forEach((element) {
      if (element.costCash == ''){
        showToast('费用信息${element.costTypeName}现金不能为空');
        return;
      }
    });

    if (activityModel.purchaseMoney == ''){
      showToast('预计进货额不能为空');
      return;
    }

    Map<String, dynamic> map = {
      'id': widget.id,
      'name': activityModel.name,
      'starttime': widget.id != '' ? activityModel.startTime : activityModel.startTime + ' 00:00:00',
      'endtime': widget.id != '' ? activityModel.endTime : activityModel.endTime + ' 00:00:00',
      'customerName': activityModel.customerName,
      'sketch': activityModel.sketch,
      'activityCosts': activityModel.sampleMapList,
      'activityCostList': activityModel.costMapList,
      'purchasemoney': activityModel.purchaseMoney
    };

    String url = '';
    if (widget.id != ''){
      url = Api.activityEdit;
    }else {
      url = Api.activityAdd;
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


