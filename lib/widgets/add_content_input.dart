import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/widgets/introduce_input.dart';

typedef OnChanged = void Function(String txt);

///多行文本输入框
class ContentInputView extends StatefulWidget {
  final String leftTitle;
  final String rightPlaceholder;
  final OnChanged onChanged;
  final Color color;

  ContentInputView({Key key,
    @required this.leftTitle,
    @required this.rightPlaceholder,
    @required this.onChanged,
    @required this.color}) : super(key: key);

  @override
  _ContentInputViewState createState() => _ContentInputViewState();
}

class _ContentInputViewState extends State<ContentInputView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: Text(widget.leftTitle, style: const TextStyle(color: AppColors.FF070E28, fontSize: 15.0))
          ),
          SizedBox(height: 0),
          Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: InputWidget(
                placeholder: widget.rightPlaceholder,
                onChanged: (String txt){
                  setState(() {
                    if(widget.onChanged != null){
                      widget.onChanged(txt);
                    }
                  });
                },
              )
          )
        ],
      ),
    );
  }
}
