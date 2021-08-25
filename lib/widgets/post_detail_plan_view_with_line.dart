import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///左边显示竖线的计划视图
class PostDetailPlanViewWithLine extends StatelessWidget {
  const PostDetailPlanViewWithLine({
    Key key,
    @required List<Map> plans,
    @required this.themColor,
  })  : _plans = plans,
        super(key: key);

  final List<Map> _plans;
  final Color themColor;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          Map map = _plans[index];
          String title = map['title'];
          List<String> plans = map['plans'];

          double top = 0;
          double bottom = 0;
          BorderRadius borderRadio = BorderRadius.zero;
          if (index == 0) {
            top = 15.0;
            borderRadio = BorderRadius.vertical(top: Radius.circular(4));
          }
          return Container(
            padding: EdgeInsets.only(left: 8.0, top: top, bottom: bottom),
            decoration:
                BoxDecoration(color: Colors.white, borderRadius: borderRadio),
            child: _PlanViewCell(
              themColor: themColor,
              title: title,
              firstHide: index == 0,
              lastHide: index == _plans.length - 1,
              plans: plans,
            ),
          );
        }, childCount: _plans.length),
      ),
    );
  }
}

class _PlanViewCell extends StatelessWidget {
  const _PlanViewCell({
    Key key,
    @required this.themColor,
    @required this.title,
    this.firstHide = false,
    this.lastHide = false,
    @required this.plans,
  }) : super(key: key);

  final Color themColor;
  final String title;

  ///是否隐藏圆点上面的竖线，第一个视图里需要隐藏
  final bool firstHide;

  ///是否隐藏圆点下面的竖线，最后一个视图里需要隐藏
  final bool lastHide;
  final List<String> plans;

  @override
  Widget build(BuildContext context) {
    List<Widget> _views = [];
    int i = 1;
    for (String title1 in plans) {
      _views.add(Text.rich(TextSpan(
        text: '$i.',
        style: const TextStyle(color: AppColors.FF959EB1, fontSize: 12.0),
        children: [
          TextSpan(
              text: title1 ?? '',
              style: const TextStyle(color: AppColors.FF2F4058))
        ],
      )));
      if (i < plans.length)
        _views.add(const Divider(color: AppColors.FFEFEFF4, thickness: 1));
      i++;
    }
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                width: 1,
                height: 10.0,
                color: firstHide ? Colors.white : themColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                            color: lastHide ? Colors.white : themColor,
                            width: 1))),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: AppColors.FFF4F5F8,
                      borderRadius: BorderRadius.circular(4)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _views,
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: 6,
          top: -4,
          child: Row(
            children: [
              ClipOval(
                  child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    border: Border.all(color: themColor, width: 1),
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: themColor.withOpacity(0.3),
                          offset: Offset(1, 1),
                          blurRadius: 1.5)
                    ]),
              )),
              Text('  ' + title),
            ],
          ),
        ),
      ],
    );
  }
}
