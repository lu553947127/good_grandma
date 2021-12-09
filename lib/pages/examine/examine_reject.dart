import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/examine/examine_detail_title.dart';
import 'package:good_grandma/pages/examine/model/time_select_provider.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/widgets/introduce_input.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:good_grandma/widgets/select_more_user.dart';
import 'package:provider/provider.dart';

///审核驳回页面
class ExamineReject extends StatelessWidget {
  final String title;
  final dynamic process;
  final String type;
  final String processIsFinished;
  final String processInsId;
  final String taskId;
  final String wait;
  final String processDefinitionId;

  ExamineReject({Key key
    , this.title
    , this.process
    , this.type
    , this.processIsFinished
    , this.processInsId
    , this.taskId
    , this.wait
    , this.processDefinitionId
  }) : super(key: key);

  String comment = '';
  String copyUser = '';

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
      'processDefinitionId': processDefinitionId,
      'taskId': taskId,
      'comment': comment,
      'copyUser': copyUser
    };

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
    TimeSelectProvider timeSelectProvider = Provider.of<TimeSelectProvider>(context);
    String copyUserName = process['copyUserName'];

    if (copyUserName.isNotEmpty){
      copyUser = process['copyUser'];
      timeSelectProvider.addcopyUserName(copyUserName);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(title, style: TextStyle(fontSize: 18, color: Colors.black)),
      ),
      body: CustomScrollView(
        slivers: [
          ExamineDetailTitle(
            avatar: process['user']['avatar'],
            title: process['processDefinitionName'],
            time: '提交时间: ${process['createTime']}',
            wait: wait,
            status: processIsFinished,
            type: type,
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 15),
          ),
          SliverToBoxAdapter(
              child: PostAddInputCell(
                  title: '抄送人',
                  value: timeSelectProvider.copyUserName,
                  hintText: '请选择抄送人',
                  endWidget: Icon(Icons.chevron_right),
                  onTap: () async {
                    Map area = await showMultiSelectList(context, timeSelectProvider, '请选择抄送人');
                    copyUser = area['id'];
                    timeSelectProvider.addcopyUserName(area['name']);
                  }
              )
          ),
          SliverToBoxAdapter(
            child: InputWidget(
              placeholder: '请填写$title原因',
              onChanged: (String txt){
                comment = txt;
              }
            )
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: LoginBtn(
                  title: '确定',
                  onPressed: _completeTask
              )
            )
          )
        ]
      )
    );
  }
}
