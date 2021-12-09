import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/pages/examine/model/time_select_provider.dart';
import 'package:good_grandma/pages/examine/apply/custom_form.dart';
import 'package:provider/provider.dart';

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
    TimeSelectProvider timeSelectProvider = new TimeSelectProvider();
    Map<String, dynamic> map = {'processId': widget.processId};
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(widget.name, style: TextStyle(fontSize: 18, color: Colors.black)),
      ),
      body: FutureBuilder(
        future: requestGet(Api.getFormByProcessId, param: map),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            var data = jsonDecode(snapshot.data.toString());
            LogUtil.d('请求结果---getFormByProcessId----$data');
            var form = jsonDecode(data['data']['appForm']);
            LogUtil.d('form----$form');
            dynamic process = data['data']['process'];
            List list = (form['column'] as List).cast();
            LogUtil.d('list----$list');
            return ChangeNotifierProvider<TimeSelectProvider>.value(
                value: timeSelectProvider,
                child: CustomFormView(
                    name: widget.name,
                    processId: widget.processId,
                    list: list,
                    process: process
                )
            );
          }else {
            return Center(
              child: CircularProgressIndicator(color: AppColors.FFC68D3E)
            );
          }
        }
      )
    );
  }
}