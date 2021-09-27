import 'package:flutter/material.dart';
import 'package:good_grandma/common/circle_border_pinter.dart';

///业绩统计头部视图
class StatisticsHeadWidget extends StatelessWidget {
  const StatisticsHeadWidget({
    Key key,
    @required this.titleView,
    this.title = '业绩统计',
    @required this.target,
    @required this.current,
    @required this.showRightArrow,
    this.onTap,
  }) : super(key: key);

  final Widget titleView;
  final String title;
  final double target;
  final double current;
  final bool showRightArrow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    double ratio = 0;
    if (target > 0 && current > 0) ratio = current / target;
    return Stack(
      children: [
        Positioned(
          bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width - 15 * 2,
                height: 50,
              ),
            )
        ),
        Image.asset('assets/images/performance_head.png',
            fit: BoxFit.fill, width: double.infinity),
        SafeArea(
          child: GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //标题
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButton(color: Colors.white),
                      Text(title,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18)),
                      BackButton(color: Colors.transparent, onPressed: () {}),
                    ],
                  ),
                  //内容
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            titleView,
                            _TitleCell(
                                color: Colors.white.withOpacity(0.4),
                                title: '年度目标：',
                                value: target.toStringAsFixed(2)),
                            _TitleCell(
                                color: Colors.white.withOpacity(0.6),
                                title: '已完成：',
                                value: current.toStringAsFixed(2)),
                            _TitleCell(
                                color: Colors.white,
                                title: '完成比：',
                                value:
                                    (ratio * 100).toStringAsFixed(0) + '%'),
                          ],
                        ),
                        Spacer(),
                        CustomPaint(
                          painter: CircleBorderPinter(
                              size: 110,
                              color: Colors.white,
                              ratio: ratio,
                              strokeWidth: 10),
                          child: SizedBox(
                            width: 110,
                            height: 110,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 9.0),
                                    child: Text('已完成',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10)),
                                  ),
                                  Text((ratio * 100).toStringAsFixed(0) + '%',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                            visible: showRightArrow,
                            child: Icon(Icons.chevron_right,
                                color: Colors.white)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TitleCell extends StatelessWidget {
  const _TitleCell(
      {Key key,
      @required this.color,
      @required this.title,
      @required this.value})
      : super(key: key);
  final Color color;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipOval(child: Container(width: 6, height: 6, color: color)),
          Text.rich(TextSpan(
              text: '  ' + title,
              style: const TextStyle(color: Colors.white, fontSize: 12.0),
              children: [
                TextSpan(text: value, style: const TextStyle(fontSize: 16.0))
              ]))
        ],
      ),
    );
  }
}
