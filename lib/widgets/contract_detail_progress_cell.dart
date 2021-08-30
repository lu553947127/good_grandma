import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';

///合同详情页下面流程cell
class ContractDetailProgressCell extends StatelessWidget {
  const ContractDetailProgressCell({
    Key key,
    @required this.isLast,
    @required this.stateColor,
    @required this.stateName,
    @required this.time,
    @required this.content,
    @required this.avatar,
    @required this.userName,
    @required this.position,
  }) : super(key: key);

  final bool isLast;
  final Color stateColor;
  final String stateName;
  final String time;
  final String content;
  final String avatar;
  final String userName;
  final String position;

  @override
  Widget build(BuildContext context) {
    double avatarWH = 35.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: avatarWH / 2),
            child: Container(
              padding: EdgeInsets.only(left: 20, top: avatarWH),
              decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(
                          color: isLast ? Colors.white : AppColors.FFC1C8D7,
                          width: 1))),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle_outline,
                              color: stateColor, size: 12),
                          Expanded(
                            child: Text('  ' + stateName,
                                style:
                                    TextStyle(color: stateColor, fontSize: 11),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Text(time,
                              style: const TextStyle(
                                  color: AppColors.FFC1C8D7, fontSize: 11)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 13.0),
                        child: Text(
                          content,
                          style: const TextStyle(
                              color: AppColors.FF959EB1, fontSize: 12.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Row(
              children: [
                ClipOval(
                    child: MyCacheImageView(
                        imageURL: avatar, width: avatarWH, height: avatarWH)),
                Text(
                  '  ' + userName,
                  style: const TextStyle(
                      color: AppColors.FF2F4058, fontSize: 14.0),
                ),
                Card(
                  color: AppColors.FFE45C26.withOpacity(0.1),
                  shadowColor: AppColors.FFE45C26.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.5, vertical: 2.5),
                    child: Text(
                      position,
                      style: const TextStyle(
                          color: AppColors.FFE45C26, fontSize: 11.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
