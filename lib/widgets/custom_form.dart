import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/provider/image_provider.dart';
import 'package:good_grandma/widgets/add_content_input.dart';
import 'package:good_grandma/widgets/add_number_input.dart';
import 'package:good_grandma/widgets/add_text_default.dart';
import 'package:good_grandma/widgets/add_text_input.dart';
import 'package:good_grandma/widgets/add_text_select.dart';
import 'package:good_grandma/widgets/photos_cell.dart';
import 'package:good_grandma/widgets/select_form.dart';
import 'package:good_grandma/widgets/time_select.dart';
import 'package:provider/provider.dart';

///自定义表单组件
class CustomFormView extends StatefulWidget {
  final String name;
  final String processId;
  final List list;
  CustomFormView({Key key,
    this.name,
    this.processId,
    this.list
  }) : super(key: key);

  @override
  _CustomFormViewState createState() => _CustomFormViewState();
}

class _CustomFormViewState extends State<CustomFormView> {
  @override
  Widget build(BuildContext context) {
    ImagesProvider imagesProvider = new ImagesProvider();

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
          if (data['detail'] != null && data['detail'] == true){
            addData[data['prop']] = nowTime;
            return TextDefaultView(
                leftTitle: data['label'],
                rightPlaceholder: nowTime,
                sizeHeight: 0
            );
          } else {
            return TextSelectView(
              leftTitle: data['label'],
              rightPlaceholder: '请选择${data['label']}',
              sizeHeight: 0,
              onPressed: () async{
                String time = await showPickerDate(context);
                for (String prop in dataList) {
                  if (data['prop'] == prop){
                    addData[prop] = time;
                  }
                }

                LogUtil.d('addData----$addData');
                return time;
              },
            );
          }
          break;
        case 'input':
          if (data['label'] == '申请人'){

            addData[data['prop']] = '${Store.readPostName()}${Store.readNickName()}';

            return TextDefaultView(
                leftTitle: data['label'],
                rightPlaceholder: '${Store.readPostName()}${Store.readNickName()}',
                sizeHeight: 1
            );
          }else {
            return TextInputView(
              leftTitle: data['label'],
              rightPlaceholder: '请输入${data['label']}',
              sizeHeight: 1,
              rightLength: 120,
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
        case 'select':
          return TextSelectView(
            leftTitle: data['label'],
            rightPlaceholder: '请选择${data['label']}',
            sizeHeight: 1,
            onPressed: () async{
              String select = await showSelect(context, data['dicUrl'], '请选择${data['label']}');
              LogUtil.d('select----$select');

              for (String prop in dataList) {
                if (data['prop'] == prop){
                  addData[prop] = select;
                }
              }

              LogUtil.d('addData----$addData');
              return select;
            },
          );
          break;
        case 'datetimerange':
          return TimeSelectView(
              leftTitle: data['label'],
              rightPlaceholder: '请选择${data['label']}',
              sizeHeight: 1,
              onPressed: (param) {
                print('onPressed=============  ${param['startTime'] + ' - ' + param['endTime']}');
                print('param--------onPressed--------- $param');

                List<String> timeList = [];
                timeList.add(param['startTime']);
                timeList.add(param['endTime']);

                for (String prop in dataList) {
                  if (data['prop'] == prop){
                    addData[prop] = timeList;
                  }
                }

                addData['days'] = param['days'];

                LogUtil.d('addData----$addData');
              }
          );
          break;
        case 'number':
          if (widget.name == '请假流程'){
            return Container();
          }
          return NumberInputView(
            leftTitle: data['label'],
            rightPlaceholder: '请输入${data['label']}',
            leftInput: '',
            rightInput: '',
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
          return Container(
            child: Text('无法显示此类型'),
          );
          break;
      }
    }

    ///发起流程
    _startProcess(){

      for (Map map in widget.list) {
        if ('upload' == map['type']){
          addData[map['prop']] = imagesProvider.imagePath;
          LogUtil.d('请求结果---prop----${map['prop']}');
        }
      }

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
