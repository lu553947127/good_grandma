import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///提交按钮
class SubmitBtn extends StatelessWidget {
  const SubmitBtn({
    Key key,
    @required this.title,
    @required this.onPressed,
    this.width = double.infinity,
    this.height = 44,
    this.horizontal = 15.0,
    this.vertical = 22.0,
    this.fontSize = 18.0,
    this.elevation = 5.0,
  }) : super(key: key);

  final String title;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final double horizontal;
  final double vertical;
  final double fontSize;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal,vertical: vertical),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              primary: AppColors.FFC08A3F,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(height / 2),
              ),
              elevation: elevation,
              textStyle: TextStyle(fontSize: fontSize,color: Colors.white)
          ),
          child: Container(
            height: height,
            width: width,
            child: Center(child: Text(title ?? '')),
          )),
    );
  }
}