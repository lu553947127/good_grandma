import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///新增市场活动 活动信息cell
class ActivityAddTextCell extends StatelessWidget {
  ActivityAddTextCell({
    Key key,
    @required this.title,
    @required this.hintText,
    @required this.value,
    @required this.trailing,
    @required this.onTap,
  }) : super(key: key);
  final String title;
  final String hintText;
  final String value;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            onTap: onTap,
            title: Row(
              children: [
                Text(title),
                Expanded(
                  child: value != null && value.isNotEmpty
                      ? Text(value,
                          textAlign: TextAlign.end,
                          style: const TextStyle(fontSize: 14.0))
                      : Text(hintText,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              color: AppColors.FFC1C8D7, fontSize: 14.0)),
                ),
              ],
            ),
            trailing: trailing,
          ),
          const Divider(color: AppColors.FFF4F5F8, thickness: 1, height: 1),
        ],
      ),
    );
  }
}
