import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///周报详情左边显示竖线的计划视图
class WeekPostDetailPlanViewWithLine extends StatelessWidget {
  const WeekPostDetailPlanViewWithLine({
    Key key,
    @required List<Map> itineraries,
    @required this.themColor,
  })  : _itineraries = itineraries,
        super(key: key);

  final List<Map> _itineraries;
  final Color themColor;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          Map map = _itineraries[index];
          String title = map['title'] ?? '';
          String work = map['work'] ?? '';
          String lastCityName = map['lastCityId'] ?? '';
          String actualCityName = map['actualCityId'] ?? '';
          // List<String> plans = map['works'];

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
              lastHide: index == _itineraries.length - 1,
              work: work,
              lastCityName: lastCityName,
              actualCityName: actualCityName,
            ),
          );
        }, childCount: _itineraries.length),
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
    @required this.work,
    @required this.lastCityName,
    @required this.actualCityName,
  }) : super(key: key);

  final Color themColor;
  final String title;

  ///是否隐藏圆点上面的竖线，第一个视图里需要隐藏
  final bool firstHide;

  ///是否隐藏圆点下面的竖线，最后一个视图里需要隐藏
  final bool lastHide;
  final String work;
  final String lastCityName;
  final String actualCityName;

  @override
  Widget build(BuildContext context) {
    List<Widget> _views = [
      DefaultTextStyle(
        style: const TextStyle(color: AppColors.FF959EB1),
        child: Wrap(
          spacing: 30,
          children: [
            Text.rich(TextSpan(text: '上周计划城市 ', children: [
              TextSpan(
                  text: lastCityName,
                  style: const TextStyle(color: AppColors.FF2F4058))
            ])),
            // SizedBox(width: 30),
            Text.rich(TextSpan(text: '实际工作城市 ', children: [
              TextSpan(
                  text: actualCityName,
                  style: const TextStyle(color: AppColors.FF2F4058))
            ])),
          ],
        ),
      ),
      const Divider(),
      Text(work),
    ];

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
              margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(
                          color: lastHide ? Colors.white : themColor,
                          width: 1))),
              child: Container(
                // padding: const EdgeInsets.all(10.0),
                // decoration: BoxDecoration(
                //     color: AppColors.FFF4F5F8,
                //     borderRadius: BorderRadius.circular(4)),
                // width: double.infinity,
                child: Card(
                  color: AppColors.FFF4F5F8,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _views,
                    ),
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
