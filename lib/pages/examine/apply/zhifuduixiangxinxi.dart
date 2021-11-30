import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/pages/examine/model/time_select_provider.dart';
import 'package:good_grandma/widgets/add_number_input.dart';
import 'package:good_grandma/widgets/add_text_input.dart';
import 'package:good_grandma/widgets/add_text_select.dart';
import 'package:good_grandma/widgets/select_form.dart';

///支付对象信息子表单
class zhifuduixiangxinxiFrom extends StatefulWidget {
  final dynamic data;
  final TimeSelectProvider timeSelectProvider;
  const zhifuduixiangxinxiFrom({Key key, this.data, this.timeSelectProvider}) : super(key: key);

  @override
  _zhifuduixiangxinxiFromState createState() => _zhifuduixiangxinxiFromState();
}

class _zhifuduixiangxinxiFromState extends State<zhifuduixiangxinxiFrom> {
  @override
  Widget build(BuildContext context) {

    List<Map> listDynamic = (widget.data['children']['column'] as List).cast();

    _childWidget(data, index){
      FormModel formModel = widget.timeSelectProvider.zhifuduixiangxinxiList[index];
      switch(data['type']){
        case 'select':
          if (data['prop'] == 'danweimingcheng'){
            return TextInputView(
                leftTitle: data['label'],
                rightPlaceholder: '请输入${data['label']}',
                sizeHeight: 1,
                rightLength: 120,
                onChanged: (tex){
                  if (data['prop'] == 'danweimingcheng'){
                    formModel.danweimingcheng = tex;
                  }
                  widget.timeSelectProvider.editzhifuduixiangFormWith(index, formModel);
                }
            );
          }else {
            String value = '';
            if (data['prop'] == 'zhifufangshi'){
              value = formModel.zhifufangshi;
            }
            return TextSelectView(
              leftTitle: data['label'],
              rightPlaceholder: '请选择${data['label']}',
              sizeHeight: 0,
              value : value,
              onPressed: () async{
                String select = await showSelect(context, data['dicUrl'], '请选择${data['label']}', data['props']);
                if (data['prop'] == 'zhifufangshi'){
                  formModel.zhifufangshi = select;
                }
                widget.timeSelectProvider.editzhifuduixiangFormWith(index, formModel);
                return select;
              },
            );
          }
          break;
        case 'input':
          return TextInputView(
              leftTitle: data['label'],
              rightPlaceholder: '请输入${data['label']}',
              sizeHeight: 1,
              rightLength: 120,
              onChanged: (tex){
                if (data['prop'] == 'zhanghao'){
                  formModel.zhanghao = tex;
                } else if (data['prop'] == 'kaihuhangmingcheng'){
                  formModel.kaihuhangmingcheng = tex;
                }else if (data['prop'] == 'beizhu'){
                  formModel.beizhu = tex;
                }
                widget.timeSelectProvider.editzhifuduixiangFormWith(index, formModel);
              }
          );
          break;
        case 'number':
          return NumberInputView(
            leftTitle: data['label'],
            rightPlaceholder: '请输入${data['label']}',
            leftInput: '¥',
            rightInput: '元',
            type: TextInputType.number,
            rightLength: 80,
            sizeHeight: 1,
            onChanged: (tex){
              if (data['prop'] == 'jine'){
                formModel.jine = tex;
              }
              widget.timeSelectProvider.editzhifuduixiangFormWith(index, formModel);
            },
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
                      widget.timeSelectProvider.addzhifuduixiangForm(FormModel());
                    },
                    icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
              ),
              ListView.builder(
                  shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                  physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                  itemCount: widget.timeSelectProvider.zhifuduixiangxinxiList.length,
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
                                        widget.timeSelectProvider.deletezhifuduixiangFormWith(index);
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
}
