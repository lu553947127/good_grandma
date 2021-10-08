import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/circle_border_pinter.dart';
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

  ///月度差额
  final double difference;

  ///月度达成率
  final double completionRate;
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
    @required this.difference,
    @required this.completionRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostDetailProgressCoreView coreView = PostDetailProgressCoreView(
      target: target,
      color: color,
      cumulative: cumulative,
      current: current,
      typeName: typeName,
      difference: difference,
      completionRate: completionRate,
    );
    Widget view = coreView;
    if (typeName == '本周实际' || typeName == '本月实际') {
      final divider = Divider(
          color: AppColors.FFEFEFF4,
          thickness: 1,
          indent: 10.0,
          endIndent: 10.0);
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
              showProgressLine: false,
              height: 8,
              showWY: false),
        ],
      );
    }

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4)),
        child: view,
      ),
    );
  }
}

class PostDetailProgressCoreView extends StatelessWidget {
  const PostDetailProgressCoreView({
    Key key,
    @required this.target,
    @required this.color,
    @required this.cumulative,
    @required this.current,
    @required this.typeName,
    @required this.difference,
    @required this.completionRate,
  }) : super(key: key);

  final double target;
  final Color color;
  final double cumulative;
  final double current;
  final String typeName;

  ///月度差额
  final double difference;

  ///月度达成率
  final double completionRate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostProgressView(
                  count: target,
                  current: target,
                  color: color.withOpacity(0.4),
                  title: '本月目标',
                  textColor: color,
                  fontSize: 14.0,
                  height: 8,
                  showWY: false),
                PostProgressView(
                    count: target,
                    current: cumulative,
                    color: color.withOpacity(0.6),
                    title: '本月累计',
                    textColor: color,
                    fontSize: 14.0,
                    height: 8,
                    showWY: false),
                PostProgressView(
                    count: target,
                    current: current,
                    color: color,
                    title: typeName,
                    textColor: color,
                    fontSize: 14.0,
                    height: 8,
                    showWY: false),
                PostProgressView(
                    count: target,
                    current: difference,
                    color: color,
                    title: '月度差额',
                    textColor: color,
                    fontSize: 14.0,
                    showProgressLine: false,
                    height: 8,
                    showWY: false),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: CustomPaint(
            painter: CircleBorderPinter(
                size: 95, color: color, ratio: completionRate / 100),
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
                    Text(completionRate.toStringAsFixed(0) + '%',
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
