import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///单行文本输入框
class TextInputView extends StatelessWidget {
  String leftTitle;
  String rightPlaceholder;
  TextEditingController textEditingController = TextEditingController();
  TextInputType type;
  double rightLength;

  TextInputView({Key key,
    @required this.leftTitle,
    @required this.rightPlaceholder,
    @required this.textEditingController,
    @required this.type,
    @required this.rightLength
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      color: Colors.white,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(leftTitle, style: const TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
          Container(
            width: rightLength,
            child: MouseRegion(
                child: TextField(
                  controller: textEditingController,
                  keyboardType: type,//输入类型
                  style: TextStyle(fontSize: 15,color: Color(0xFF333333)),
                  cursorColor: Color(0xFFC68D3E),//修改光标颜色
                  decoration: InputDecoration(
                    hintText: rightPlaceholder,
                    hintStyle: TextStyle(fontSize: 15,color: Color(0XFFC1C8D7)),
                    border: InputBorder.none,//去掉下划线
                  ),
                )
            ),
          )
        ],
      ),
    );
  }
}
