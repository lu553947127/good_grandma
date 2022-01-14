import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/examine/model/time_select_provider.dart';
import 'package:good_grandma/widgets/activity_add_text_cell.dart';
import 'package:good_grandma/widgets/select_form.dart';

///活动试吃品子表单
class shichipinFrom extends StatefulWidget {
  final dynamic data;
  final TimeSelectProvider timeSelectProvider;
  const shichipinFrom({Key key, this.data, this.timeSelectProvider}) : super(key: key);

  @override
  _shichipinFromState createState() => _shichipinFromState();
}

class _shichipinFromState extends State<shichipinFrom> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {

    List<Map> listDynamic = (widget.data['children']['column'] as List).cast();

    _childWidget(data, index){
      SampleModel sampleModel = widget.timeSelectProvider.sampleList[index];
      switch(data['type']){
        case 'select':
          String value = '';
          if (data['prop'] == 'materialId'){
            value = sampleModel.materialName;
          }else if(data['prop'] == 'withGoods'){
            value = sampleModel.withGoodsName;
          }
          return ActivityAddTextCell(
              title: data['label'],
              hintText: '请选择${data['label']}',
              value: value,
              trailing: Icon(Icons.chevron_right),
              onTap: () async {
                if (data['prop'] == 'materialId'){
                  Map<String, dynamic> map = {'type': '1'};
                  Map select = await showSelectListParameter(context, Api.materialSelectList, '请选择物料名称', 'name', map);
                  sampleModel.materialId = select['id'];
                  sampleModel.materialName = select['name'];
                  sampleModel.unitPrice = double.parse(select['unitPrice']);
                }else if (data['prop'] == 'withGoods'){
                  List<Map> dicData = (data['dicData'] as List).cast();
                  List<String> dicDataString = [];
                  for (Map map in dicData) {
                    dicDataString.add(map['label']);
                  }
                  String select = await showPicker(dicDataString, context);
                  sampleModel.withGoodsName = select;
                  if (select == '是'){
                    sampleModel.withGoods = 1;
                  }else {
                    sampleModel.withGoods = 2;
                  }
                }
                widget.timeSelectProvider.editSampleModelWith(index, sampleModel);
              }
          );
          break;
        case 'input':
          String value = '';
          if (data['prop'] == 'sample'){
            value = sampleModel.sample.toString();
          }else if(data['prop'] == 'costCash'){
            value = sampleModel.costCash.toString();
          }
          return ActivityAddTextCell(
              title: data['label'],
              hintText: '请选择${data['label']}',
              value: value,
              trailing: null,
              onTap: () => data['prop'] == 'costCash' ? null :
              AppUtil.showInputDialog(
                  context: context,
                  editingController: _editingController,
                  focusNode: _focusNode,
                  text: sampleModel.sample.toString(),
                  hintText: '请输入${data['label']}',
                  keyboardType: TextInputType.number,
                  inputFormatters : [
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  callBack: (text) {
                    if (sampleModel.materialId == ''){
                      EasyLoading.showToast('请先选择试吃品，再输入数量哦');
                      return;
                    }
                    sampleModel.costCash = (double.parse(text) * sampleModel.unitPrice);
                    sampleModel.sample = double.parse(text);
                    widget.timeSelectProvider.editSampleModelWith(index, sampleModel);

                    widget.timeSelectProvider.addCosttotal('${(widget.timeSelectProvider.sampleAllPrice +
                        widget.timeSelectProvider.costAllPrice)}');
                  }
              )
          );
          break;
        default:
          return Container();
          break;
      }
    }

    return Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        color: Colors.white,
        child: Column(
            children: [
              ListTile(
                title: Text(widget.data['label'], style: const TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                trailing: IconButton(
                    onPressed: () {
                      widget.timeSelectProvider.addSampleModel(SampleModel());
                    },
                    icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
              ),
              ListView.builder(
                  shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                  physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                  itemCount: widget.timeSelectProvider.sampleList.length,
                  itemBuilder: (context, index){
                    return Container(
                        margin: EdgeInsets.all(15),
                        decoration: new BoxDecoration(
                            border: new Border.all(color: Color(0xFF2F4058), width: 0.6),
                            color: Color(0xFF2F4058),
                            borderRadius: new BorderRadius.circular((5.0))
                        ),
                        child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                                physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                                itemCount: listDynamic.length,
                                itemBuilder: (context, indexChild){
                                  return _childWidget(listDynamic[indexChild], index);
                                },
                              ),
                              Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                      onPressed: (){
                                        widget.timeSelectProvider.deleteSampleModelWith(index);
                                      },
                                      icon: Icon(Icons.delete, color: AppColors.FFDD0000)
                                  )
                              )
                            ]
                        )
                    );
                  }
              )
            ]
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _editingController.dispose();
  }
}
