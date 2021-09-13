import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/provider/form_sys_provider.dart';
import 'package:good_grandma/widgets/add_text_select.dart';
import 'package:provider/provider.dart';
import 'package:good_grandma/widgets/select_form.dart';

///系统附件子表单
class SystemFormView extends StatefulWidget {
  var data;
  SystemFormView({Key key, this.data}) : super(key: key);

  @override
  _SystemFormViewState createState() => _SystemFormViewState();
}

class _SystemFormViewState extends State<SystemFormView> {
  @override
  Widget build(BuildContext context) {

    List<Map> listDynamic = (widget.data['children']['column'] as List).cast();
    LogUtil.d('listDynamic----$listDynamic');

    final FormSysProvider formSysProvider = Provider.of<FormSysProvider>(context);

    Map addData = new Map();

    _childWidget(data, index){

      switch(data['type']){
        case 'select':
          return TextSelectView(
            leftTitle: data['label'],
            rightPlaceholder: '请选择${data['label']}',
            sizeHeight: 0,
            onPressed: () async{
              String select = await showSelect(context, data['dicUrl'], '请选择${data['label']}');
              LogUtil.d('select----$select');

              // if (data['prop'] == 'danweimingcheng'){
              //   formModel.danweimingcheng = select;
              // } else if (data['prop'] == 'zhifufangshi'){
              //   formModel.zhifufangshi = select;
              // }
              //
              // formProvider.editFormWith(index, formModel);

              return select;
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
                    formSysProvider.addForm(addData);
                  },
                  icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
            ),
            ListView.builder(
                shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                itemCount: formSysProvider.formSys.length,
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
                                  formSysProvider.deleteFormWith(index);
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
