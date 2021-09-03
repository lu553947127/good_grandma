import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///单行文本默认显示框
class TextDefaultView extends StatefulWidget {
  ///左侧标题
  String leftTitle;

  ///右侧输入框占位
  String rightPlaceholder = '请输入';

  ///分割线间距
  double sizeHeight = 0;

  TextDefaultView({Key key,
    this.leftTitle,
    this.rightPlaceholder,
    this.sizeHeight
  }) : super(key: key);

  @override
  _TextDefaultViewState createState() => _TextDefaultViewState();
}

class _TextDefaultViewState extends State<TextDefaultView> {
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
              Text(widget.rightPlaceholder, style: const TextStyle(color: AppColors.FFC1C8D7, fontSize: 15.0))
            ],
          )
        ],
      ),
    );
  }
}
