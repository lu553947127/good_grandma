import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';

///报告详情页面顶部用户信息
class PostDetailHeaderView extends StatelessWidget {
  final String avatar;
  final String name;

  ///职位
  final String position;

  ///地区
  final String area;
  final String time;
  final int postType;
  final Color color;
  const PostDetailHeaderView(
      {Key key,
      @required this.avatar,
      @required this.name,
      @required this.position,
      @required this.area,
      @required this.time,
      @required this.postType,
      @required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String typeName = '日报';
    if (postType == 2) {
      typeName = '周报';
    } else if (postType == 3) {
      typeName = '月报';
    }
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              offset: Offset(1, 1),
              blurRadius: 1.5)
        ]),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
        child: Row(
          children: [
            ClipOval(
              child: MyCacheImageView(
                imageURL: avatar,
                width: 50.0,
                height: 50.0,
                errorWidgetChild:
                Image.asset('assets/images/icon_empty_user.png',
                    width: 50, height: 50),
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 240),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Visibility(
                          visible: name != null && name.isNotEmpty,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                                constraints: BoxConstraints(maxWidth: 140),
                                child: Text(name ?? '',
                                    style: const TextStyle(
                                        color: AppColors.FF2F4058,
                                        fontSize: 14.0))),
                          ),
                        ),
                        Visibility(
                          visible: position != null && position.isNotEmpty,
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 120),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.5, vertical: 3.0),
                            decoration: BoxDecoration(
                                color: AppColors.FFE45C26.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(2.5)),
                            child: Text(
                              position ?? '',
                              style: const TextStyle(
                                  color: AppColors.FFE45C26, fontSize: 11.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Text(area ?? '',
                          style: const TextStyle(
                              color: AppColors.FF959EB1, fontSize: 11.0)),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4.5),
                          child: Icon(Icons.access_time,
                              color: AppColors.FF959EB1, size: 12.0),
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: 210),
                          child: Text(
                            time ?? '',
                            style: const TextStyle(
                                color: AppColors.FF959EB1, fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Container(
              width: 37,
              height: 20,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2.5),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(2, 1),
                      color: color.withOpacity(0.4),
                      blurRadius: 1.5,
                    ),
                  ]),
              child: Center(
                  child: Text(typeName,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 11.0))),
            ),
          ],
        ),
      ),
    );
  }
}
