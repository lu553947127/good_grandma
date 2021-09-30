import 'package:flutter/material.dart';

///报告中单独一个进度条封装
class PostProgressView extends StatelessWidget {
  ///目标总数
  final double count;

  ///当前数额
  final double current;

  ///标题
  final String title;

  ///标题颜色
  final Color titleColor;

  ///进度条颜色
  final Color color;

  ///金额文字颜色
  final Color textColor;
  final double fontSize;

  ///进度条最大宽度
  final double width;

  ///进度条高度
  final double height;
  final double horizontal;
  final double vertical;

  ///是否显示结尾的万元
  final bool showWY;
  PostProgressView({
    Key key,
    @required this.count,
    @required this.current,
    @required this.color,
    @required this.title,
    @required this.textColor,
    this.width = 150,
    this.titleColor = Colors.black,
    this.height = 6,
    this.fontSize = 12.0,
    this.horizontal = 10.0,
    this.vertical = 4.0,
    this.showWY = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double r = count == 0 ? current : current / count;
    if (r > 1) r = 1;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: Row(
        children: [
          Text((title ?? '') + '  ',
              style: TextStyle(color: titleColor, fontSize: 14.0)),
          Expanded(child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            return
              Stack(
                children: [
                  Container(height: height, width: constraints.maxWidth),
                  Container(
                    height: height,
                    width: constraints.maxWidth * r,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              );
          },)),
          Text(
              (width == 0 ? '' : '  ') +
                  (fontSize == 12.0 ? '¥' : '') +
                  '${_numTranfer(current)}' +
                  (showWY ? '万元' : ''),
              style: TextStyle(color: textColor, fontSize: fontSize)),
        ],
      ),
    );
  }

  String _numTranfer(double num) {
    if (num ~/ 100000000 > 0)
      return (num / 100000000).toStringAsFixed(2) + '亿';
    else if (num ~/ 10000000 > 0)
      return (num / 10000000).toStringAsFixed(2) + '千万';
    else if (num ~/ 1000000 > 0)
      return (num / 1000000).toStringAsFixed(2) + '百万';
    else if (num ~/ 10000 > 0)
      return (num / 10000).toStringAsFixed(2) + '万';
    else
      return num.toStringAsFixed(2);
  }
}
