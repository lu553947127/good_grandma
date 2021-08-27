import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

typedef OnChanged = void Function(String txt);

///单行文本输入框
class TextInputView extends StatefulWidget {
  ///左侧标题
  String leftTitle;

  ///右侧输入框占位
  String rightPlaceholder = '请输入';

  ///输入框输入类型
  TextInputType type = TextInputType.text;

  ///右侧输入框长度
  double rightLength = 100.0;

  ///输入最大字数长度
  int maxLength = 12;

  ///输入监听
  final OnChanged onChanged;

  ///分割线间距
  double sizeHeight = 0;

  TextInputView({Key key,
    this.leftTitle,
    this.rightPlaceholder,
    this.type,
    this.rightLength,
    this.maxLength,
    this.onChanged,
    this.sizeHeight
  }) : super(key: key);

  @override
  _TextInputViewState createState() => _TextInputViewState();
}

class _TextInputViewState extends State<TextInputView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      color: Colors.white,
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: double.infinity,
              height: widget.sizeHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.leftTitle, style: const TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
              Container(
                width: widget.rightLength,
                child: ConstrainedBox(
                  child: Expanded(
                      child: TextField(
                        keyboardType: widget.type,//输入类型
                        style: TextStyle(fontSize: 15,color: Color(0xFF333333)),
                        cursorColor: Color(0xFFC68D3E),//修改光标颜色
                        maxLength: widget.maxLength,
                        decoration: InputDecoration(
                          hintText: widget.rightPlaceholder,
                          hintStyle: TextStyle(fontSize: 15,color: Color(0XFFC1C8D7)),
                          border: InputBorder.none,//去掉下划线
                        ),
                        onChanged: (String txt){
                          setState(() {
                            if(widget.onChanged != null){
                              widget.onChanged(txt);
                            }
                          });
                        },
                      )
                  ),
                  constraints: BoxConstraints.tightFor(width: 100.0),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
