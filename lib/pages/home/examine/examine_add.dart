import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/pages/home/examine/apply/cost_apply.dart';
import 'package:good_grandma/pages/home/examine/apply/cost_off_apply.dart';
import 'package:good_grandma/pages/home/examine/apply/leave_apply.dart';
import 'package:good_grandma/widgets/custom_form.dart';

///审批添加
class ExamineAdd extends StatefulWidget {
  final String name;
  final String processId;

  ExamineAdd({Key key
    , @required this.name
    , @required this.processId
  }) : super(key: key);

  @override
  _ExamineAddState createState() => _ExamineAddState();
}

class _ExamineAddState extends State<ExamineAdd> {

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> map = {'processId': widget.processId};
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(widget.name,style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: FutureBuilder(
        future: requestGet(Api.getFormByProcessId, param: map),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            var data = jsonDecode(snapshot.data.toString());
            LogUtil.d('请求结果---getFormByProcessId----$data');
            var form = jsonDecode(data['data']['appForm']);
            LogUtil.d('form----$form');
            List list = (form['column'] as List).cast();
            LogUtil.d('list----$list');

            switch (widget.name){
              case '费用申请':
                return ExamineCostApply(
                    name: widget.name,
                    processId: widget.processId,
                    list: list
                );
                break;
              case '请假流程':
                return ExamineLeaveApply(
                    name: widget.name,
                    processId: widget.processId,
                    list: list
                );
                break;
              case '费用核销':
                return ExamineCostOffApply(
                    name: widget.name,
                    processId: widget.processId,
                    list: list
                );
                break;
              default:
                return CustomFormView(
                    name: widget.name,
                    processId: widget.processId,
                    list: list
                );
                break;
            }
          }else {
            return Center(
              child: CircularProgressIndicator()
            );
          }
        }
      )
    );
  }
}