import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/week_post_add_new_model.dart';
import 'package:good_grandma/widgets/post_detail_progress_view.dart';
import 'package:good_grandma/widgets/post_progress_view.dart';

///周报和月报详情页面销量进度追踪cell
class PostDetailSalesTrackingCell extends StatelessWidget {
  const PostDetailSalesTrackingCell(
      {Key key,
      @required this.model,
      @required this.color,
      this.forWeek = false})
      : super(key: key);

  final SalesTrackingModel model;
  final Color color;

  ///区分是周报还是月报
  final bool forWeek;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
                  child: Text(
                      model.area.city.isNotEmpty
                          ? model.area.city
                          : '未知区域',
                      style: TextStyle(color: color, fontSize: 15)),
                ),
                PostDetailProgressCoreView(
                  target: model.target,
                  color: color,
                  cumulative: model.cumulative,
                  current: model.actual,
                  typeName: forWeek ? '本周实际' : '本月实际',
                  difference: model.difference,
                  completionRate: model.completionRate,
                ),
                PostProgressView(
                    count: model.nextTarget,
                    current: model.nextTarget,
                    color: color,
                    title: '下周规划进货金额',
                    textColor: color,
                    fontSize: 14.0,
                    showProgressLine: false,
                    height: 8,
                    showWY: false),
              ],
            )),
        Container(
          color: Colors.white,
          child: const Divider(
              color: AppColors.FFF4F5F8,
              thickness: 5,
              indent: 10,
              endIndent: 10),
        )
      ],
    );
  }
}
