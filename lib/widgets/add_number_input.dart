import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

typedef OnChanged = void Function(String txt);

///单行文本输入框
class NumberInputView extends StatefulWidget {
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

  ///输入框左侧文字
  String leftInput = '';

  ///输入框右侧文字
  String rightInput = '';

  ///分割线间距
  double sizeHeight = 0;

  NumberInputView({Key key,
    this.leftTitle,
    this.rightPlaceholder,
    this.type,
    this.rightLength,
    this.maxLength,
    this.onChanged,
    this.sizeHeight,
    this.leftInput,
    this.rightInput
  }) : super(key: key);

  @override
  _NumberInputViewState createState() => _NumberInputViewState();
}

class _NumberInputViewState extends State<NumberInputView> {
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
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.leftTitle, style: const TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(widget.leftInput, style: const TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                    Container(
                        width: widget.rightLength,
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
                            }
                        )
                    ),
                    Text(widget.rightInput, style: const TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
