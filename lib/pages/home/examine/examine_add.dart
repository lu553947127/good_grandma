import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/form/form.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
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

  final GlobalKey _dynamicFormKey = GlobalKey<TFormState>();

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
            var form = jsonDecode(data['data']['form']);
            LogUtil.d('form----$form');
            List list = (form['column'] as List).cast();
            LogUtil.d('list----$list');
            return CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return CustomFormView(data: list[index]);
                    }, childCount: list.length)
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 30, left: 22, right: 22),
                    child: LoginBtn(
                      title: '提交',
                      onPressed: () {
                        showToast("成功");
                      },
                    ),
                  ),
                ),
              ],
            );
          }else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}