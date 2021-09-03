import 'package:flutter/material.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/widgets/add_content_input.dart';
import 'package:good_grandma/widgets/add_text_select.dart';
import 'package:good_grandma/widgets/select_form.dart';

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

    _childWidget(data){
      switch(data['type']){
        case 'date':
          return TextSelectView(
            leftTitle: data['label'],
            rightPlaceholder: '请选择${data['label']}',
            sizeHeight: 0,
            onPressed: (){
              return showPickerDate(context);
            },
          );
          break;
        case 'select':
          return TextSelectView(
            leftTitle: data['label'],
            rightPlaceholder: '请选择${data['label']}',
            sizeHeight: 1,
            onPressed: (){
              return showSelect(context, data['dicUrl'], '请选择${data['label']}');
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

            },
          );
          break;
        default:
          return Container();
          break;
      }
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
                      onPressed: () {
                        showToast("成功");
                      }
                  )
              )
          )
        ]
    );
  }
}
