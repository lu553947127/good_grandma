import 'package:flutter/material.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/form/form.dart';
import 'package:good_grandma/form/form_row.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/pages/work/work_text.dart';
import 'package:good_grandma/widgets/photos_cell.dart';

///审批添加
class ExamineAdd extends StatelessWidget {
  String title;

  ExamineAdd({Key key
    , @required this.title
  }) : super(key: key);

  final GlobalKey _dynamicFormKey = GlobalKey<TFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(title,style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: CustomScrollView(
        slivers: [
          TForm.sliver(
            key: _dynamicFormKey,
            rows: buildFormRows(title),
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
      ),
    );
  }
}

List<TFormRow> buildFormRows(title) {
  List list;
  switch(title){
    case '请假审批':
      list = (WorkText.examine['column'] as List).cast();
      break;
    case '费用审批':
      list = (WorkText.examine2['column'] as List).cast();
      break;
  }

  print('$list');
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
  print('$type');
  TFormRow row;
  switch (type) {
    case 'select':
      row = TFormRow.customSelector(
        tag: e["prop"],
        title: e["label"],
        placeholder: e["placeholder"],
        require: true,
        options: (e["rules"] as List).map((e) => e["message"]).toList(),
        onTap: (context, row) async {
          String value = await showPicker(row.options, context);
          return value;
        },
      );
      break;
    case 'date':
      row = TFormRow.customSelector(
        tag: e["prop"],
        title: e["label"],
        placeholder: e["placeholder"],
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
        placeholder: e["placeholder"],
        require: true,
      );
      break;
    case 'upload':
      row = TFormRow.customCellBuilder(
        tag: e["prop"],
        title: e["label"],
        state: e["rules"],
        validator: (row) {
          bool suc = (row.state as List)
              .every((element) => (element["message"].length > 0));
          if (!suc) {
            row.requireMsg = "请完成${row.title}上传";
          }
          return suc;
        },
        widgetBuilder: (context, row) {
          return CustomPhotosWidget(row: row);
        },
      );
      break;
  }
  return row;
}

