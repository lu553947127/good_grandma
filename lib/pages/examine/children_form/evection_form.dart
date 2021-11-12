import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/pages/examine/model/form_evection_provider.dart';
import 'package:good_grandma/widgets/add_number_input.dart';
import 'package:good_grandma/widgets/add_text_input.dart';
import 'package:good_grandma/widgets/time_select.dart';
import 'package:provider/provider.dart';

///出差明细子表单
class DynamicEvectionFormView extends StatefulWidget {
  var data;
  DynamicEvectionFormView({Key key, this.data}) : super(key: key);

  @override
  _DynamicEvectionFormViewState createState() => _DynamicEvectionFormViewState();
}

class _DynamicEvectionFormViewState extends State<DynamicEvectionFormView> {
  @override
  Widget build(BuildContext context) {

    List<Map> listDynamic = (widget.data['children']['column'] as List).cast();
    LogUtil.d('listDynamic----$listDynamic');

    final FormEvectionProvider formEvectionProvider = Provider.of<FormEvectionProvider>(context);

    _childWidget(data, index){
      FormEvectionModel formEvectionModel = formEvectionProvider.form[index];

      switch(data['type']){
        case 'datetimerange':
          return TimeSelectView(
              leftTitle: data['label'],
              rightPlaceholder: '请选择${data['label']}',
              value: (formEvectionModel.start_time.isNotEmpty && formEvectionModel.end_time.isNotEmpty)
                  ? '${formEvectionModel.start_time + '\n' + formEvectionModel.end_time}'
                  : '',
              dayNumber: formEvectionModel.hejitianshu,
              sizeHeight: 0,
              onPressed: (param) {
                // print('onPressed=============  ${param['startTime'] + ' - ' + param['endTime']}');
                // print('param--------onPressed--------- $param');

                formEvectionModel.start_time = param['startTime'];
                formEvectionModel.end_time = param['endTime'];
                formEvectionModel.hejitianshu = param['days'];

                formEvectionProvider.editFormWith(index, formEvectionModel);
              }
          );
          break;
        case 'input':
          if (data['label'] == '合计天数'){
            return Container();
          }else {
            return TextInputView(
                leftTitle: data['label'],
                rightPlaceholder: '请输入${data['label']}',
                sizeHeight: 1,
                rightLength: 120,
                onChanged: (tex){

                  if (data['prop'] == 'qizhididian'){
                    formEvectionModel.qizhididian = tex;
                  } else if (data['prop'] == 'chuchaimudi'){
                    formEvectionModel.chuchaimudi = tex;
                  } else if (data['prop'] == 'beizhu'){
                    formEvectionModel.beizhu = tex;
                  }

                  formEvectionProvider.editFormWith(index, formEvectionModel);
                }
            );
          }
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

              if (data['prop'] == 'jiaotongjine'){
                formEvectionModel.jiaotongjine = tex;
              } else if (data['prop'] == 'shineijiaotong'){
                formEvectionModel.shineijiaotong = tex;
              } else if (data['prop'] == 'zhusujine'){
                formEvectionModel.zhusujine = tex;
              } else if (data['prop'] == 'buzhujine'){
                formEvectionModel.buzhujine = tex;
              }

              formEvectionProvider.editFormWith(index, formEvectionModel);
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
                    formEvectionProvider.addForm(FormEvectionModel());
                  },
                  icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
            ),
            ListView.builder(
                shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                itemCount: formEvectionProvider.form.length,
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
                                  formEvectionProvider.deleteFormWith(index);
                                },
                                icon: Icon(Icons.delete, color: AppColors.FFDD0000)
                            )
                        )
                      ],
                    ),
                  );
                }
            )
          ],
        )
    );
  }
}
