import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';

///报告详情底部评论列表
class PostDetailReportList extends StatelessWidget {
  const PostDetailReportList({
    Key key,
    @required List<Map> reportList,
  })  : _reportList = reportList,
        super(key: key);

  final List<Map> _reportList;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        Map map = _reportList[index];
        String image = map['image'];
        String name = map['name'];
        String time = map['time'];
        String content = map['content'];
        BorderRadius borderRadios = BorderRadius.zero;
        if (index == 0) {
          borderRadios = BorderRadius.vertical(top: Radius.circular(4));
        } else if (index == _reportList.length - 1) {
          borderRadios = BorderRadius.vertical(bottom: Radius.circular(4));
        }
        return Container(
          decoration:
              BoxDecoration(color: Colors.white, borderRadius: borderRadios),
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(10.0),
                leading: ClipOval(
                    child: MyCacheImageView(
                        imageURL: image, width: 30, height: 30)),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            color: AppColors.FF2F4058, fontSize: 14.0)),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.5, bottom: 9),
                      child: Text(time,
                          style: const TextStyle(
                              color: AppColors.FF959EB1, fontSize: 11.0)),
                    ),
                  ],
                ),
                subtitle: Text(content,
                    style: const TextStyle(
                        color: AppColors.FF2F4058, fontSize: 11.0)),
              ),
              const Divider(
                  color: AppColors.FFF4F5F8,
                  thickness: 1,
                  height: 1,
                  indent: 10.0,
                  endIndent: 10.0)
            ],
          ),
        );
      }, childCount: _reportList.length)),
    );
  }
}
