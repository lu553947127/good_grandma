import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnChanged = void Function(String txt);

///带右下角计数的输入框
class InputWidget extends StatefulWidget {
  const InputWidget({
    this.placeholder='请输入',
    this.onChanged,
    this.maxLength = 1000,
    this.maxLines = 10,
  });

  final String placeholder;
  final OnChanged onChanged;
  final int maxLength;
  final int maxLines;

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {

  String result = '';

  @override
  Widget build(BuildContext context) {
    return _textInput();
  }

  Widget _textInput() {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Container(
          height: 136,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(4.0)
            ),
            // border: Border.all(color: Color(0xFFDEDEDE)),
          ),
          alignment: AlignmentDirectional.topStart,
          child: CupertinoTextField(
            placeholder: widget.placeholder,
            cursorColor: Color(0xFFC68D3E),//修改光标颜色
            style: TextStyle(fontSize: 15, color: Colors.black),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            textInputAction: TextInputAction.unspecified,
            onChanged: (str) {
              setState(() {
                result = str;
                if(widget.onChanged != null){
                  widget.onChanged(str);
                }
              });
            }
          )
        ),
        Container(
          margin: EdgeInsets.only(bottom: 25, right: 20),
          child: Text(
            result.length.toString() + '/'+widget.maxLength.toString(),
            style: TextStyle(color: Colors.grey),
          )
        )
      ]
    );
  }
}
