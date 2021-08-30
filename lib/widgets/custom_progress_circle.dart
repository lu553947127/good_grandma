import 'dart:ui';
import 'package:flutter/material.dart';

///自定义进度圆圈封装
class CustomProgressCircle extends StatelessWidget {
  CustomProgressCircle({Key key
    , this.size
    , this.ratio
    , this.color
    , this.width
    , this.height
  }) : super(key: key);

  ///整个圆圈尺寸
  final double size;

  ///当前进度/总进度
  final double ratio;

  ///主题颜色
  final Color color;

  ///内圈宽度
  final double width;

  ///内圈高度
  final double height;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BorderPinter(size: size, color: color, ratio: ratio),
      child: SizedBox(
        width: width,
        height: height,
        child: Container(),
      ),
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
      ..strokeWidth = 4
      ..color = color.withOpacity(0.4);

    _frontPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
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