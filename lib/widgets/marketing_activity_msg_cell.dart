import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///灰色标题 黑色副标题 白色背景和底部下划线的cell
class MarketingActivityMsgCell extends StatelessWidget {
  const MarketingActivityMsgCell({
    Key key,
    @required this.title,
    @required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            leading: Text(title,
                style: const TextStyle(
                    color: AppColors.FF959EB1, fontSize: 14.0)),
            title: Text(value,
                style: const TextStyle(fontSize: 14.0)),
          ),
          const Divider(
              color: AppColors.FFEFEFF4, height: 1),
        ]
      )
    );
  }
}