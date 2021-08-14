import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/msg_list_model.dart';
///消息详情页面标题和内容 不包含附件
class MsgDetailCellContent extends StatelessWidget {
  const MsgDetailCellContent({
    Key key,
    @required this.model,
  }) : super(key: key);

  final MsgListModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.title ?? '',
            style: const TextStyle(
                color: AppColors.FF142339, fontSize: 16.0),
          ),
          const Divider(
            color: AppColors.FFEFEFF4,
            thickness: 1,
            height: 30,
          ),
          Text(
            model.content * 10 ?? '',
            style: const TextStyle(
                color: AppColors.FF2F4058, fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}