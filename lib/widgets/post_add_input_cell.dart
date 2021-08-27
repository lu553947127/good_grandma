import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///添加报告单行文本输入cell
class PostAddInputCell extends StatelessWidget {
  const PostAddInputCell({
    Key key,
    @required this.title,
    @required this.value,
    @required this.hintText,
    this.end = '',
    this.endWidget,
    @required this.onTap,
  }) : super(key: key);

  final String title;
  final String value;
  final String hintText;
  final String end;
  final Widget endWidget;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          ListTile(
              onTap: onTap,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14.0),
              title: Row(
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: AppColors.FF2F4058,
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal)),
                  Expanded(
                    child: (value != null && value.isNotEmpty)
                        ? Text(
                            value,
                            style: const TextStyle(
                                color: AppColors.FF2F4058,
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
                        style: const TextStyle(
                            color: AppColors.FF2F4058,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal)),
                  ),
                ],
              )),
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
