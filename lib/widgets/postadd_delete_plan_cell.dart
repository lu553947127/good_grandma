import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///添加删除总结或者计划的输入框cell
class PostAddDeletePlanCell extends StatelessWidget {
  const PostAddDeletePlanCell({
    Key key,
    @required this.value,
    @required this.hintText,
    this.isAdd = true,
    @required this.textOnTap,
    @required this.rightBtnOnTap,
  }) : super(key: key);

  final String value;
  final String hintText;
  final VoidCallback textOnTap;
  final VoidCallback rightBtnOnTap;
  final bool isAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.FFEFEFF4, width: 1)),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: textOnTap,
                child: value.isEmpty
                    ? Text(hintText,
                        style: const TextStyle(
                            color: AppColors.FFC1C8D7, fontSize: 14.0))
                    : Text(value),
              ),
            ),
            IconButton(
              onPressed: rightBtnOnTap,
              icon: isAdd
                  ? Icon(Icons.add_circle, color: AppColors.FFC08A3F)
                  : Icon(Icons.delete_forever_outlined, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
