import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///添加报告单行文本输入cell
class PostAddInputCell extends StatelessWidget {
  const PostAddInputCell({
    Key key,
    @required this.title,
    @required this.value,
    @required this.hintText,
    this.bgColor = Colors.white,
    this.contentPadding,
    this.end = '',
    this.endWidget,
    @required this.onTap,
  }) : super(key: key);

  final String title;
  final String value;
  final String hintText;
  final Color bgColor;
  final String end;
  final EdgeInsets contentPadding;
  final Widget endWidget;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Column(
        children: [
          PostAddInputCellCore(onTap: onTap, contentPadding:contentPadding, title: title, value: value, hintText: hintText, endWidget: endWidget, end: end),
          const Divider(
              color: AppColors.FFF4F5F8,
              thickness: 1,
              height: 1,
              indent: 15.0,
              endIndent: 15.0)
        ],
      ),
    );
  }
}

class PostAddInputCellCore extends StatelessWidget {
  const PostAddInputCellCore({
    Key key,
    @required this.onTap,
    this.contentPadding,
    @required this.title,
    @required this.value,
    @required this.hintText,
    @required this.endWidget,
    @required this.end,
    this.titleColor = AppColors.FF2F4058,
    this.valueColor = AppColors.FF2F4058,
  }) : super(key: key);

  final VoidCallback onTap;
  final EdgeInsets contentPadding;
  final String title;
  final String value;
  final String hintText;
  final Widget endWidget;
  final String end;
  final Color titleColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onTap,
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 14.0),
        title: Row(
          children: [
            Text(title,
                style: TextStyle(
                    color: titleColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal)),
            Expanded(
              child: (value != null && value.isNotEmpty)
                  ? Text(
                      value,
                      style: TextStyle(
                          color: valueColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.end,
                    )
                  : Text(
                      hintText,
                      style: const TextStyle(
                          color: AppColors.FFC1C8D7,
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.end,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: endWidget ?? Text(end,
                  style: TextStyle(
                      color: titleColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal)),
            ),
          ],
        ));
  }
}
