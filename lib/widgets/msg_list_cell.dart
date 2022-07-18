import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/msg_list_model.dart';
import 'package:provider/provider.dart';

///消息列表cell样式，也用于规章文件
class MsgListCell extends StatelessWidget {
  final VoidCallback cellOnTap;
  final String type;
  MsgListCell({Key key, @required this.cellOnTap, this.type = ''}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final MsgListModel model = Provider.of<MsgListModel>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          Text(
            model.time ?? '',
            style: const TextStyle(color: AppColors.FFC1C8D7, fontSize: 12.0),
          ),
          ListTile(
            title: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    offset: Offset(2, 1),
                    blurRadius: 1.5,
                  )
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //标题 已读未读
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        model.title ?? '',
                        style: TextStyle(
                            color: model.read
                                ? AppColors.FF959EB1
                                : AppColors.FF2F4058,
                            fontSize: 14.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                      Visibility(
                        visible: !model.forRegularDoc,
                        child: Container(
                          width: 36,
                          height: 20,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2.5),
                              border: Border.all(
                                  color: model.read
                                      ? AppColors.FFC1C8D7
                                      : AppColors.FFC08A3F),
                              boxShadow: [
                                BoxShadow(
                                    color: model.read
                                        ? AppColors.FFC1C8D7
                                        : AppColors.FFC08A3F,
                                    offset: Offset(1, 1),
                                    blurRadius: 1.5)
                              ]),
                          child: Center(
                            child: Text(
                              type.isEmpty ? model.read ? '已读' : '未读' : '审批中',
                              style: TextStyle(
                                  color: model.read
                                      ? AppColors.FFC1C8D7
                                      : AppColors.FFC08A3F,
                                  fontSize: 11.0),
                            )
                          )
                        )
                      )
                    ]
                  ),
                  //内容
                  Padding(
                    padding: const EdgeInsets.only(top: 7, bottom: 14),
                    child: Text(
                      model.text ?? '',
                      style: TextStyle(
                          color: model.read
                              ? AppColors.FF959EB1
                              : AppColors.FFC1C8D7,
                          fontSize: 12.0),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ),
                  //附件
                  Visibility(
                    visible:
                        model.haveEnclosure,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.FFF8F9FC,
                        ),
                        child: Row(
                          children: [
                            Image.asset('assets/images/msg_enclosure.png',
                                width: 24, height: 24),
                            Expanded(
                              child: Text(
                                '  ' + (model.enclosureName.isNotEmpty ?model.enclosureName: '附件'),
                                style: TextStyle(
                                    color: AppColors.FF959EB1, fontSize: 12.0),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            ),
                            // Spacer(),
                            Visibility(
                              visible: model.forDuiZhangDan,
                              child: Image.asset(
                                model.sign
                                    ? 'assets/images/msg_sign.png'
                                    : 'assets/images/msg_unsign.png',
                                width: 12,
                                height: 12,
                              )
                            ),
                            Visibility(
                              visible: model.forDuiZhangDan,
                              child: Text(
                                model.sign ? '  已签署  ' : '  未签署  ',
                                style: TextStyle(
                                    color: model.sign
                                        ? AppColors.FFC08A3F
                                        : AppColors.FF2F4058,
                                    fontSize: 11),
                              )
                            )
                          ]
                        )
                      )
                    )
                  ),
                  //查看详情
                  Row(
                    children: [
                      Text(
                        '查看详情',
                        style: TextStyle(
                            color: model.read
                                ? AppColors.FF959EB1
                                : AppColors.FF2F4058,
                            fontSize: 12.0),
                      ),
                      Spacer(),
                      Icon(
                        Icons.chevron_right,
                        color: model.read
                            ? AppColors.FF959EB1
                            : AppColors.FF2F4058,
                        size: 24,
                      )
                    ]
                  )
                ]
              )
            ),
            onTap: () {
              if (cellOnTap != null) cellOnTap();
            }
          )
        ]
      )
    );
  }
}
