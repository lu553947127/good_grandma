import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

class TextSelectView extends StatelessWidget {
  final String leftTitle;
  final String rightPlaceholder;
  final void Function() onPressed;

  TextSelectView({Key key,
    @required this.leftTitle,
    @required this.rightPlaceholder,
    @required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      color: Colors.white,
      height: 60,
      child: TextButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(leftTitle, style: const TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
            Row(
              children: [
                Text(leftTitle, style: const TextStyle(color: AppColors.FFC1C8D7, fontSize: 15.0)),
                Icon(Icons.keyboard_arrow_right, color: AppColors.FFC1C8D7)
              ],
            )
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}
