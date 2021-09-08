import 'package:flutter/material.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/common/colors.dart';

class SalesStatisticsDetailShopOrderCell extends StatelessWidget {
  const SalesStatisticsDetailShopOrderCell({
    Key key,
    @required this.avatar,
    @required this.title,
    @required this.count,
    @required this.onTap,
  }) : super(key: key);

  final String avatar;
  final String title;
  final String count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: ClipOval(
              child: MyCacheImageView(imageURL: avatar, width: 30, height: 30)),
          title: Row(
            children: [
              Expanded(
                  child: Text(title, style: const TextStyle(fontSize: 14.0))),
              Text('订货数量：$count',
                  style: const TextStyle(
                      fontSize: 12.0, color: AppColors.FF959EB1)),
            ],
          ),
          trailing: Icon(Icons.chevron_right),
        ),
        const Divider(height: 1, indent: 15, endIndent: 15),
      ],
    );
  }
}
