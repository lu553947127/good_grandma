import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/form/form.dart';
import 'package:good_grandma/form/form_row.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';

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
                TForm.sliver(
                  key: _dynamicFormKey,
                  rows: buildFormRows(list),
                  divider: Divider(
                    height: 0.5,
                    thickness: 0.5,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 30, left: 22, right: 22),
                    child: LoginBtn(
                      title: '提交',
                      onPressed: () {
                        //校验
                        List errors = (_dynamicFormKey.currentState as TFormState).validate();
                        print('errors=======$errors');
                        if (errors.isNotEmpty) {
                          showToast(errors.first);
                          return;
                        }
                        //提交
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

///循环显示表单数据
List<TFormRow> buildFormRows(list) {
  List<TFormRow> rows = [];
  list.forEach((e) {
    TFormRow row = getRow(e);
    if (row != null) {
      rows.add(row);
    }
  });
  return rows;
}

TFormRow getRow(e) {
  String type = e["type"];
  TFormRow row;
  switch (type) {
    case 'select':
      row = TFormRow.customSelector(
        tag: e["prop"],
        title: e["label"],
        placeholder: e['rules'][0]["message"],
        require: true,
        options: (e["rules"] as List).map((e) => e["message"]).toList(),
        onTap: (context, row) async {
          String value = await showPicker(row.options, context);
          return value;
        },
        // onTap: (context, row){
        //
        //   return null;
        // }
      );
      break;
    case 'date':
      row = TFormRow.customSelector(
        tag: e["prop"],
        title: e["label"],
        require: true,
        onTap: (context, row) async {
          return showPickerDate(context);
        },
      );
      break;
    case 'input':
      row = TFormRow.input(
        tag: e["prop"],
        title: e["label"],
        maxLength: e["span"],
        require: true,
      );
      break;
    // case 'upload':
    //   row = TFormRow.customCellBuilder(
    //     tag: e["prop"],
    //     title: e["label"],
    //     state: e["rules"],
    //     validator: (row) {
    //       bool suc = (row.state as List)
    //           .every((element) => (element["message"].length > 0));
    //       if (!suc) {
    //         row.requireMsg = "请完成${row.title}上传";
    //       }
    //       return suc;
    //     },
    //     widgetBuilder: (context, row) {
    //       return CustomPhotosWidget(row: row);
    //     },
    //   );
    //   break;
  }
  return row;
}