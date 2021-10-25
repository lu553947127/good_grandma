import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/marketing_activity_model.dart';
import 'package:good_grandma/widgets/activity_add_text_cell.dart';
import 'package:good_grandma/widgets/add_content_input.dart';
import 'package:good_grandma/widgets/select_form.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///新增市场活动
class AddMarketingActivityPage extends StatefulWidget {
  const AddMarketingActivityPage({Key key}) : super(key: key);

  @override
  _AddMarketingActivityPageState createState() =>
      _AddMarketingActivityPageState();
}

class _AddMarketingActivityPageState extends State<AddMarketingActivityPage> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final MarketingActivityModel activityModel = Provider.of<MarketingActivityModel>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('新增市场活动')),
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
                  child: ContentInputView(
                      sizeHeight: 10,
                      color: Colors.white,
                      leftTitle: '活动简述',
                      rightPlaceholder: '请输入活动简述',
                      onChanged: (tex) {
                        activityModel.setSketch(tex);
                      }
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
                          Map select = await showSelectList(context, Api.materialListNoPage, '请选择物料', 'materialName');
                          activityModel.addSampleModel(select['id'], select['materialName']);
                        },
                        icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    Map sampleMap = activityModel.sampleList[index];
                    return Column(
                      children: [
                        SizedBox(height: 1),
                        ActivityAddTextCell(
                            title: '物料名称',
                            hintText: '',
                            value: sampleMap['name'],
                            trailing: IconButton(
                                onPressed: (){
                                  activityModel.deleteSampleModelWith(index);
                                },
                                icon: Icon(Icons.delete, color: AppColors.FFDD0000)
                            ),
                            onTap: null
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
                              sample: '',
                              costDescribe: ''
                          ));
                        },
                        icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
                  ),
                ),
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
                            title: '试吃品',
                            hintText: '请输入数量',
                            value: costModel.sample,
                            trailing: Text('箱'),
                            onTap: () => AppUtil.showInputDialog(
                                context: context,
                                editingController: _editingController,
                                focusNode: _focusNode,
                                text: costModel.sample,
                                hintText: '请输入数量',
                                keyboardType: TextInputType.number,
                                callBack: (text) {
                                  costModel.sample = text;
                                  activityModel.editCostModelWith(index, costModel);
                                })
                        ),
                        ContentInputView(
                            sizeHeight: 0,
                            color: Colors.white,
                            leftTitle: '费用描述',
                            rightPlaceholder: '请输入费用描述',
                            onChanged: (tex) {
                              costModel.costDescribe = tex;
                              activityModel.editCostModelWith(index, costModel);
                            }
                        ),
                      ],
                    );
                  }, childCount: activityModel.costList.length)),
              SliverToBoxAdapter(
                child: SizedBox(
                    width: double.infinity,
                    height: 10,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                    )
                ),
              ),
              SliverToBoxAdapter(
                  child: ActivityAddTextCell(
                      title: '预计进货额',
                      hintText: '请输入预计进货额',
                      value: activityModel.purchaseMoney,
                      trailing: null,
                      onTap: () => AppUtil.showInputDialog(
                          context: context,
                          editingController: _editingController,
                          focusNode: _focusNode,
                          text: activityModel.purchaseMoney,
                          hintText: '请输入预计进货额',
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

  ///添加市场活动
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

    if (activityModel.costList[0].costCash == ''){
      showToast('促销员费用现金不能为空');
      return;
    }

    if (activityModel.costList[0].sample == ''){
      showToast('促销员费用试吃品不能为空');
      return;
    }

    if (activityModel.costList[0].costDescribe == ''){
      showToast('促销员费用费用描述不能为空');
      return;
    }

    if (activityModel.costList[1].costCash == ''){
      showToast('生动化工具费现金不能为空');
      return;
    }

    if (activityModel.costList[1].sample == ''){
      showToast('生动化工具费试吃品不能为空');
      return;
    }

    if (activityModel.costList[1].costDescribe == ''){
      showToast('生动化工具费费用描述不能为空');
      return;
    }

    if (activityModel.purchaseMoney == ''){
      showToast('预计进货额不能为空');
      return;
    }

    List<String> materIdList = [];
    activityModel.sampleList.forEach((element) {
      materIdList.add(element['id']);
    });

    Map<String, dynamic> map = {
      'name': activityModel.name,
      'starttime': activityModel.startTime + ' 00:00:00',
      'endtime': activityModel.endTime + ' 00:00:00',
      'customerName': activityModel.customerName,
      'sketch': activityModel.sketch,
      'materialId': listToString(materIdList),
      'activityCostList': activityModel.mapList,
      'purchasemoney': activityModel.purchaseMoney
    };

    LogUtil.d('请求结果---activityAdd----$map');

    requestPost(Api.activityAdd, formData: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---activityAdd----$data');
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


