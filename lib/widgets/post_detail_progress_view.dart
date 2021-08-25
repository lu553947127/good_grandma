import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/widgets/post_progress_view.dart';

///报告详情页现实目标完成进度
class PostDetailProgressView extends StatelessWidget {
  ///本月目标总数
  final double target;
  ///下一周期的目标总数
  final double nextTarget;

  ///本月累计
  final double cumulative;

  ///本日（周、月）实际
  final double current;
  final Color color;

  ///日：今日销售，周：本周实际，月：本月实际
  final String typeName;
  const PostDetailProgressView({
    Key key,
    @required this.cumulative,
    @required this.current,
    @required this.color,
    @required this.target,
    @required this.typeName,
    this.nextTarget = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _CoreView coreView = _CoreView(
        target: target,
        color: color,
        cumulative: cumulative,
        current: current,
        typeName: typeName);
    Widget view = coreView;
    if(typeName == '本周实际' || typeName == '本月实际'){
      final divider = Divider(color: AppColors.FFEFEFF4,thickness: 1,indent: 10.0,endIndent: 10.0);
      view = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          coreView,
          divider,
          PostProgressView(
              count: nextTarget,
              current: nextTarget,
              color: color,
              title: '下周规划进货金额',
              textColor: color,
              fontSize: 14.0,
              width: 0,
              height: 8),
        ],
      );
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(4)),
          child: view,
        ),
      ),
    );
  }
}

class _CoreView extends StatelessWidget {
  const _CoreView({
    Key key,
    @required this.target,
    @required this.color,
    @required this.cumulative,
    @required this.current,
    @required this.typeName,
  }) : super(key: key);

  final double target;
  final Color color;
  final double cumulative;
  final double current;
  final String typeName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostProgressView(
                count: target,
                current: target,
                color: color.withOpacity(0.4),
                title: '本月目标',
                textColor: color,
                fontSize: 14.0,
                width: 95,
                height: 8,
            ),
            PostProgressView(
                count: target,
                current: cumulative,
                color: color.withOpacity(0.6),
                title: '本月累计',
                textColor: color,
                fontSize: 14.0,
                width: 95,
                height: 8),
            PostProgressView(
                count: target,
                current: current,
                color: color,
                title: typeName,
                textColor: color,
                fontSize: 14.0,
                width: 95,
                height: 8),
            PostProgressView(
                count: target,
                current: target - cumulative,
                color: color,
                title: '月度差额',
                textColor: color,
                fontSize: 14.0,
                width: 0,
                height: 8),
          ],
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: CustomPaint(
            painter:
                _BorderPinter(size: 95, color: color, ratio: cumulative / target),
            child: SizedBox(
              width: 95,
              height: 95,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('月度达成率',
                          style: TextStyle(
                              color: color.withOpacity(0.8), fontSize: 10)),
                    ),
                    Text((cumulative / target * 100).toStringAsFixed(0) + '%',
                        style: TextStyle(color: color, fontSize: 24)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BorderPinter extends CustomPainter {
  final double size;
  final double ratio;
  final Color color;

  Paint _bgPaint;
  Paint _frontPaint;
  RRect _shape;
  PathMetric _pathMetric;

  _BorderPinter(
      {@required this.ratio, @required this.size, @required this.color})
      : super() {
    _bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..color = color.withOpacity(0.4);

    _frontPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..color = color;

    _shape = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: size, height: size),
        Radius.circular(size / 2));

    final path = Path()..addRRect(_shape);

    _pathMetric = path.computeMetrics().single;
    // print('_pathMetric = $_pathMetric');
  }

  @override
  void paint(Canvas canvas, Size size1) {
    final path = Path();
    final totalLength = _pathMetric.length;
    final currentLength = totalLength * ratio;
    // print('totalLength = $totalLength,currentLength = $currentLength');

    // path.addPath(_pathMetric.extractPath(0, currentLength), Offset.zero);

    final startingPoint = totalLength / 4;
    path.addPath(
        _pathMetric.extractPath(startingPoint, currentLength + startingPoint),
        Offset.zero);
    path.addPath(
        _pathMetric.extractPath(
            0.0, currentLength - (totalLength - startingPoint)),
        Offset.zero);

    canvas.translate(size / 2, size / 2);
    canvas.drawRRect(_shape, _bgPaint);
    canvas.drawPath(path, _frontPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
