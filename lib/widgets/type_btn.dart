import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///单选按钮
class TypeBtn extends StatelessWidget {
  const TypeBtn(
      {Key key,
        @required this.isSelected,
        @required this.title,
        @required this.onPressed})
      : super(key: key);
  final bool isSelected;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Row(
          children: [
            isSelected
                ? Icon(Icons.check_circle, color: AppColors.FFC08A3F, size: 14)
                : Icon(Icons.radio_button_unchecked,
                color: Colors.grey, size: 14),
            Text(title,
                style:
                const TextStyle(color: AppColors.FF2F4058, fontSize: 14.0)),
          ],
        ));
  }
}