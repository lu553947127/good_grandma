import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/home/examine/apply/evection_form.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/provider/form_evection_provider.dart';
import 'package:good_grandma/provider/image_provider.dart';
import 'package:good_grandma/widgets/add_text_default.dart';
import 'package:good_grandma/widgets/photos_cell.dart';
import 'package:provider/provider.dart';

///出差申请
class ExamineEvectionApply extends StatefulWidget {
  final String name;
  final String processId;
  final List list;

  ExamineEvectionApply({Key key
    , @required this.name
    , @required this.processId
    , @required this.list
  }) : super(key: key);

  @override
  _ExamineEvectionApplyState createState() => _ExamineEvectionApplyState();
}

class _ExamineEvectionApplyState extends State<ExamineEvectionApply> {
  @override
  Widget build(BuildContext context) {
    ImagesProvider imagesProvider = new ImagesProvider();
    FormEvectionProvider formEvectionProvider = new FormEvectionProvider();

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
        case 'input':
          addData[data['prop']] = '${Store.readPostName()}${Store.readNickName()}';
          return TextDefaultView(
              leftTitle: data['label'],
              rightPlaceholder: '${Store.readPostName()}${Store.readNickName()}',
              sizeHeight: 1
          );
          break;
        case 'dynamic':
          return ChangeNotifierProvider<FormEvectionProvider>.value(
            value: formEvectionProvider,
            child: DynamicEvectionFormView(
              data: data,
            ),
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
          return Container();
          break;
      }
    }

    ///发起流程
    _startProcess(){
      addData['biaodanfujian'] = imagesProvider.imagePath;
      addData['chuchaimingxi'] = formEvectionProvider.mapList;
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
