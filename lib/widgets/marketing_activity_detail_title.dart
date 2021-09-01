import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/marketing_activity_model.dart';

///市场活动详情顶部标题视图
class MarketingActivityDetailTitle extends StatelessWidget {
  const MarketingActivityDetailTitle(
      {Key key,
      @required this.model,
      @required this.state,
      @required this.stateColor,
      this.showTime = true})
      : super(key: key);

  final MarketingActivityModel model;
  final String state;
  final Color stateColor;
  final bool showTime;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    model.title,
                    style: const TextStyle(
                        color: AppColors.FF2F4058, fontSize: 16.0),
                  )),
                  Card(
                    color: stateColor.withOpacity(0.1),
                    shadowColor: stateColor.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.5, vertical: 5),
                      child: Text(
                        state,
                        style: TextStyle(color: stateColor, fontSize: 11.0),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: showTime,
                child: Row(
                  children: [
                    Image.asset('assets/images/icon_visit_statistics_time.png',
                        width: 12, height: 12),
                    Text(
                      '  发布时间：' + (model.time ?? ''),
                      style: const TextStyle(
                          color: AppColors.FF959EB1, fontSize: 12.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
