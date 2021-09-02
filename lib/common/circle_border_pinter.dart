import 'dart:ui';

import 'package:flutter/material.dart';

///圆圈进度条
class CircleBorderPinter extends CustomPainter {
  final double size;
  final double ratio;
  final double strokeWidth;
  final Color color;

  Paint _bgPaint;
  Paint _frontPaint;
  RRect _shape;
  PathMetric _pathMetric;

  CircleBorderPinter(
      {@required this.ratio, @required this.size, @required this.color,this.strokeWidth = 8})
      : super() {
    _bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color.withOpacity(0.4);

    _frontPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
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
