import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/examine/model/time_select_provider.dart';
import 'package:good_grandma/widgets/activity_add_text_cell.dart';
import 'package:good_grandma/widgets/select_form.dart';

///活动费用子表单
class feiyongFrom extends StatefulWidget {
  final dynamic data;
  final TimeSelectProvider timeSelectProvider;
  const feiyongFrom({Key key, this.data, this.timeSelectProvider}) : super(key: key);

  @override
  _feiyongFromState createState() => _feiyongFromState();
}

class _feiyongFromState extends State<feiyongFrom> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    List<Map> listDynamic = (widget.data['children']['column'] as List).cast();

    _childWidget(data, index){
      CostModel costModel = widget.timeSelectProvider.costList[index];
      switch(data['type']){
        case 'select':
          return ActivityAddTextCell(
              title: data['label'],
              hintText: '请选择${data['label']}',
              value: costModel.costTypeName,
              trailing: Icon(Icons.chevron_right),
              onTap: () async {
                Map select = await showSelectList(context, data['dicUrl'], '请选择${data['label']}', data['props']['label']);
                costModel.costType = select['dictKey'];
                costModel.costTypeName = select['dictValue'];
                widget.timeSelectProvider.editCostModelWith(index, costModel);
              }
          );
          break;
        case 'input':
          String value = '';
          if (data['prop'] == 'costDescribe'){
            value = costModel.costDescribe;
          }else if(data['prop'] == 'costCash'){
            value = costModel.costCash;
          }
          return ActivityAddTextCell(
              title: data['label'],
              hintText: '请选择${data['label']}',
              value: value,
              trailing: null,
              onTap: () => AppUtil.showInputDialog(
                  context: context,
                  editingController: _editingController,
                  focusNode: _focusNode,
                  text: value,
                  hintText: '请输入${data['label']}',
                  keyboardType: data['prop'] == 'costCash' ? TextInputType.number : TextInputType.text,
                  callBack: (text) {
                    if (data['prop'] == 'costDescribe'){
                      costModel.costDescribe = text;
                    }else if(data['prop'] == 'costCash'){
                      costModel.costCash = text;
                      widget.timeSelectProvider.addCosttotal('${(widget.timeSelectProvider.sampleAllPrice +
                          widget.timeSelectProvider.costAllPrice)}');
                    }
                    widget.timeSelectProvider.editCostModelWith(index, costModel);
                  })
          );
          break;
        default:
          return Container();
          break;
      }
    }

    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        color: Colors.white,
        child: Column(
            children: [
              ListTile(
                title: Text(widget.data['label'], style: const TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                trailing: IconButton(
                    onPressed: () {
                      widget.timeSelectProvider.addCostModel(CostModel());
                    },
                    icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
              ),
              ListView.builder(
                  shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                  physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                  itemCount: widget.timeSelectProvider.costList.length,
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
                                        widget.timeSelectProvider.deleteCostModelWith(index);
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
