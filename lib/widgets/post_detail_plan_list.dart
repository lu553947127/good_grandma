import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///报告总结和计划列表视图
class PostDetailPlanList extends StatelessWidget {
  final List<String> list;
  const PostDetailPlanList({Key key, @required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _views = [];
    int i = 1;
    for (String title1 in list) {
      _views.add(Text.rich(TextSpan(
        text: '$i.',
        style: const TextStyle(color: AppColors.FF959EB1, fontSize: 12.0),
        children: [
          TextSpan(
              text: title1 ?? '',
              style: const TextStyle(color: AppColors.FF2F4058))
        ],
      )));
      if (i < list.length)
        _views.add(const Divider(color: AppColors.FFEFEFF4, thickness: 1));
      i++;
    }
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _views,
          ),
        ),
      ),
    );
  }
}
