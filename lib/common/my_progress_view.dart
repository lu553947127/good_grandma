import 'package:flutter/material.dart';

///横向进度视图
class MyProgressView extends StatelessWidget {
  const MyProgressView({
    Key key,
    @required this.ratio,
    @required this.height,
    @required this.borderRadius,
    @required this.backgroundColor,
    @required this.valueColor,
  }) : super(key: key);

  final double ratio;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      // 圆角矩形剪裁（`ClipRRect`）组件，使用圆角矩形剪辑其子项的组件。
      child: ClipRRect(
        // 边界半径（`borderRadius`）属性，圆角的边界半径。
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        child: LinearProgressIndicator(
          value: ratio,
          backgroundColor: backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(valueColor),
        ),
      ),
    );
  }
}