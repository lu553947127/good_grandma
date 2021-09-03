import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/widgets/add_content_input.dart';
import 'package:good_grandma/widgets/add_text_select.dart';
import 'package:good_grandma/widgets/select_form.dart';
import 'package:good_grandma/widgets/time_select.dart';

///请假申请
class ExamineLeaveApply extends StatefulWidget {
  final String name;
  final String processId;
  final List list;

  ExamineLeaveApply({Key key
    , @required this.name
    , @required this.processId
    , @required this.list
  }) : super(key: key);

  @override
  _ExamineLeaveApplyState createState() => _ExamineLeaveApplyState();
}

class _ExamineLeaveApplyState extends State<ExamineLeaveApply> {
  @override
  Widget build(BuildContext context) {

    List<String> dataList = [];
    Map addData = new Map();
    addData['processId'] = widget.processId;

    for (Map map in widget.list) {
      dataList.add(map['prop']);
    }

    LogUtil.d('dataList----$dataList');

    _childWidget(data){
      switch(data['type']){
        case 'select':
          return TextSelectView(
            leftTitle: data['label'],
            rightPlaceholder: '请选择${data['label']}',
            sizeHeight: 0,
            onPressed: () async{
              String type = await showSelect(context, data['dicUrl'], '请选择${data['label']}');
              print('type -------- $type');

              for (String prop in dataList) {
                if (data['prop'] == prop){
                  addData[prop] = type;
                }
              }

              LogUtil.d('addData----$addData');
              return type;
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
        default:
          return Container();
          break;
      }
    }

    ///发起流程
    _startProcess(){
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
