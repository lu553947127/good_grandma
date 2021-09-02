import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/common/my_progress_view.dart';

class StatisticsCell extends StatelessWidget {
  const StatisticsCell({Key key,
    @required this.avatar,
    @required this.name,
    @required this.target,
    @required this.current,
    this.onTap,
  }) : super(key: key);
  final String avatar;
  final String name;
  final String target;
  final String current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    double ratio = 0;
    final double budgetCountD = double.parse(target);
    final double budgetCurrentD = double.parse(current);
    if (budgetCountD > 0 && budgetCurrentD > 0)
      ratio = budgetCurrentD / budgetCountD;
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            onTap: onTap,
            title: Row(
              children: [
                ClipOval(
                    child: MyCacheImageView(
                        imageURL: avatar, width: 30, height: 30)),
                Expanded(
                    child: Text('  ' + name,
                        style: const TextStyle(
                            color: AppColors.FF2F4058,
                            fontSize: 14.0))),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text.rich(
                        TextSpan(
                            text: '￥' + current.toString(),
                            style: const TextStyle(
                                color: AppColors.FFE45C26,
                                fontSize: 12.0),
                            children: [
                              TextSpan(
                                  text: ' / ￥' + target.toString(),
                                  style: const TextStyle(
                                      color: AppColors.FFC1C8D7,
                                      fontSize: 12.0))
                            ]),
                        textAlign: TextAlign.end),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: MyProgressView(
                          ratio: ratio,
                          height: 6.0,
                          width: 180,
                          borderRadius: 3,
                          backgroundColor:
                          AppColors.FFE45C26.withOpacity(0.1),
                          valueColor: AppColors.FFE45C26),
                    ),
                  ],
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
            // trailing: Icon(Icons.chevron_right),
          ),
          const Divider(
              color: AppColors.FFEFEFF4,
              thickness: 1,
              height: 1,
              indent: 10,
              endIndent: 10),
        ],
      ),
    );
  }
}