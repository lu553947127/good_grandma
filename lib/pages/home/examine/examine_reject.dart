import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/home/examine/examine_detail_title.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/widgets/introduce_input.dart';

///审核驳回页面
class ExamineReject extends StatelessWidget {
  final String title;
  var process;
  final String type;
  final String processIsFinished;
  final String processInsId;
  final String taskId;
  final String wait;

  ExamineReject({Key key
    , this.title
    , this.process
    , this.type
    , this.processIsFinished
    , this.processInsId
    , this.taskId, this.wait
  }) : super(key: key);

  String comment = '';

  ///驳回
  _completeTask(){
    LogUtil.d('---comment----$comment');
    if (comment == '') {
      showToast("驳回原因不能为空");
      return;
    }

    Map<String, dynamic> map = {
      'pass': false,
      'processInstanceId': processInsId,
      'taskId': taskId,
      'comment': comment};

    requestPost(Api.completeTask, json: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---completeTask----$data');

      if (data['code'] == 200){
        showToast("$title成功");
        Navigator.of(Application.appContext).pop('refresh');
      }else {
        showToast(data['msg']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(title, style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: CustomScrollView(
        slivers: [
          ExamineDetailTitle(
            avatar: process['user']['avatar'],
            title: process['processDefinitionName'],
            time: '提交时间: ${process['createTime']}',
            wait: wait,
            status: processIsFinished == '审核中' ? '审核中' : '已审核',
            type: type,
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 15),
          ),
          SliverToBoxAdapter(
            child: InputWidget(
              placeholder: '请填写$title原因',
              onChanged: (String txt){
                comment = txt;
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: LoginBtn(
                  title: '确定',
                  onPressed: _completeTask
              )
            ),
          )
        ],
      ),
    );
  }
}
