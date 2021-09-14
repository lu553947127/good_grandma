import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///单行选择框
class TextSelectView extends StatefulWidget {

  ///左侧标题
  final String leftTitle;
  ///右侧占位
  String rightPlaceholder;
  ///点击回调
  final Future Function() onPressed;
  ///选择回调value
  String value;
  ///分割线间距
  double sizeHeight = 0;

  TextSelectView({Key key,
    this.leftTitle,
    this.rightPlaceholder,
    this.onPressed,
    this.sizeHeight,
    this.value = '',
  }) : super(key: key);

  @override
  _TextSelectViewState createState() => _TextSelectViewState();
}

class _TextSelectViewState extends State<TextSelectView> {
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
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.leftTitle, style: TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                Row(
                  children: [
                    Text(widget.value == '' ?widget.rightPlaceholder:widget.value,
                        style: TextStyle(color: widget.value == '' ? AppColors.FFC1C8D7 : AppColors.FF070E28, fontSize: 15.0)),
                    Icon(Icons.keyboard_arrow_right, color: widget.value == '' ? AppColors.FFC1C8D7 : AppColors.FF070E28)
                  ],
                )
              ],
            ),
            onTap: () async{
              widget.value = await widget.onPressed();
            },
          )
        ],
      ),
    );
  }
}
