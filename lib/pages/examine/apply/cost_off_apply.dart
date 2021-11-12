import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/examine/children_form/dynamic_form.dart';
import 'package:good_grandma/pages/examine/children_form/system_form.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/pages/examine/model/form_rovider.dart';
import 'package:good_grandma/pages/examine/model/form_sys_provider.dart';
import 'package:good_grandma/provider/image_provider.dart';
import 'package:good_grandma/pages/examine/model/time_select_provider.dart';
import 'package:good_grandma/widgets/add_content_input.dart';
import 'package:good_grandma/widgets/add_number_input.dart';
import 'package:good_grandma/widgets/add_text_default.dart';
import 'package:good_grandma/widgets/add_text_select.dart';
import 'package:good_grandma/widgets/photos_cell.dart';
import 'package:good_grandma/widgets/select_form.dart';
import 'package:provider/provider.dart';

///费用核销申请
class ExamineCostOffApply extends StatefulWidget {
  final String name;
  final String processId;
  final List list;

  ExamineCostOffApply({Key key
    , @required this.name
    , @required this.processId
    , @required this.list
  }) : super(key: key);

  @override
  _ExamineCostOffApplyState createState() => _ExamineCostOffApplyState();
}

class _ExamineCostOffApplyState extends State<ExamineCostOffApply> {
  @override
  Widget build(BuildContext context) {

    ImagesProvider imagesProvider = new ImagesProvider();
    FormProvider formProvider = new FormProvider();
    FormSysProvider formSysProvider = new FormSysProvider();
    TimeSelectProvider timeSelectProvider = Provider.of<TimeSelectProvider>(context);

    DateTime now = new DateTime.now();
    String nowTime = '${now.year}-${now.month}-${now.day}';

    List<String> dataList = [];
    Map addData = new Map();
    addData['processId'] = widget.processId;

    for (Map map in widget.list) {
      dataList.add(map['prop']);
    }

    LogUtil.d('dataList----$dataList');

    _childWidget(data){

      switch(data['type']){
        case 'date':
          addData[data['prop']] = nowTime;
          return TextDefaultView(
              leftTitle: data['label'],
              rightPlaceholder: nowTime,
              sizeHeight: 0
          );
          break;
        case 'select':
          if (data['label'] == '费用类别'){
            return TextSelectView(
              leftTitle: data['label'],
              rightPlaceholder: '请选择${data['label']}',
              sizeHeight: 1,
              value: timeSelectProvider.select,
              onPressed: () async{

                String select = await showSelect(context, data['dicUrl'], '请选择${data['label']}', data['props']);

                LogUtil.d('select----$select');

                timeSelectProvider.addValue(select);

                for (String prop in dataList) {
                  if (data['prop'] == prop){
                    addData[prop] = select;
                  }
                }

                LogUtil.d('addData----$addData');
                return select;
              },
            );
          }else {
            return TextSelectView(
              leftTitle: data['label'],
              rightPlaceholder: '请选择${data['label']}',
              sizeHeight: 1,
              value: timeSelectProvider.value,
              onPressed: () async{

                String select = await showSelect(context, data['dicUrl'], '请选择${data['label']}', data['props']);

                LogUtil.d('select----$select');

                timeSelectProvider.addValue2(select);

                for (String prop in dataList) {
                  if (data['prop'] == prop){
                    addData[prop] = select;
                  }
                }

                LogUtil.d('addData----$addData');
                return select;
              },
            );
          }
          break;
        case 'input':
          if (data['prop'] == 'shenqingren'){
            addData[data['prop']] = '${Store.readPostName()}${Store.readNickName()}';

            return TextDefaultView(
                leftTitle: data['label'],
                rightPlaceholder: '${Store.readPostName()}${Store.readNickName()}',
                sizeHeight: 1
            );
          }else if (data['prop'] == 'hejidaxie'){
            return Container();
          }else if (data['prop'] == 'hejixiaoxie'){
            return Container();
          }else {
            return NumberInputView(
              leftTitle: data['label'],
              rightPlaceholder: '请输入${data['label']}',
              leftInput: data['prepend'] == null ? '' : data['prepend'],
              rightInput: data['append'],
              type: TextInputType.number,
              rightLength: 120,
              sizeHeight: 1,
              onChanged: (tex){
                for (String prop in dataList) {
                  if (data['prop'] == prop){
                    addData[prop] = tex;
                  }
                }

                LogUtil.d('addData----$addData');
              },
            );
          }
          break;
        case 'textarea':
          return ContentInputView(
            color: Colors.white,
            leftTitle: data['label'],
            rightPlaceholder: '请输入${data['label']}',
            sizeHeight: 10,
            onChanged: (tex){
              for (String prop in dataList) {
                if (data['prop'] == prop){
                  addData[prop] = tex;
                }
              }

              LogUtil.d('addData----$addData');
            },
          );
          break;
        case 'dynamic':
          if (data['prop'] == 'zhifuduixiangxinxi'){
            return ChangeNotifierProvider<FormProvider>.value(
              value: formProvider,
              child: DynamicFormView(
                data: data,
              ),
            );
          }else if (data['prop'] == 'xitongfujian'){
            return ChangeNotifierProvider<FormSysProvider>.value(
              value: formSysProvider,
              child: SystemFormView(
                data: data,
              ),
            );
          }else {
            return Container();
          }
          break;
        case 'upload':
          return ChangeNotifierProvider<ImagesProvider>.value(
              value: imagesProvider,
              child:  CustomPhotoWidget(
                  title: data['label'],
                  length: 3,
                  sizeHeight: 10,
                  url: data['action']
              )
          );
          break;
        default:
          return Container();
          break;
      }
    }

    ///发起流程
    _startProcess(){
      addData['feiyongleibie'] = timeSelectProvider.select;
      addData['feiyongshenqing'] = timeSelectProvider.valueList;

      addData['file'] = imagesProvider.imagePath;
      addData['zhifuduixiangxinxi'] = formProvider.mapList;
      LogUtil.d('addData----$addData');
      requestPost(Api.startProcess, json: addData).then((val) async{
        var data = json.decode(val.toString());
        LogUtil.d('请求结果---startProcess----$data');
        if (data['code'] == 200){
          showToast("添加成功");
          Navigator.of(Application.appContext).pop('refresh');
        }else {
          showToast(data['msg']);
        }
      });
    }

    return CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _childWidget(widget.list[index]);
              }, childCount: widget.list.length)
          ),
          SliverToBoxAdapter(
              child: Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 30, left: 22, right: 22),
                  child: LoginBtn(
                      title: '提交',
                      onPressed: _startProcess
                  )
              )
          )
        ]
    );
  }
}
