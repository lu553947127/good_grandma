import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/circle_border_pinter.dart';
import 'package:good_grandma/models/marketing_activity_model.dart';

///市场活动详情 预算视图
class MarketActivityDetailBudgetView extends StatelessWidget {
  const MarketActivityDetailBudgetView({
    Key key,
    @required this.model,
  }) : super(key: key);

  final MarketingActivityModel model;

  @override
  Widget build(BuildContext context) {
    double ratio = 0;
    final double budgetCountD = double.parse(model.budgetCount);
    final double budgetCurrentD = double.parse(model.budgetCurrent);
    if (budgetCountD > 0 && budgetCurrentD > 0)
      ratio = budgetCurrentD / budgetCountD;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      sliver: SliverToBoxAdapter(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text.rich(TextSpan(
                        text: '总  预  算  ',
                        style: const TextStyle(
                            color: AppColors.FF959EB1, fontSize: 14.0),
                        children: [
                          TextSpan(
                              text: '￥' + model.budgetCount,
                              style: const TextStyle(color: AppColors.FFE45C26))
                        ])),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                          width: 200, height: 1, color: AppColors.FFEFEFF4),
                    ),
                    Text.rich(TextSpan(
                        text: '已用预算  ',
                        style: const TextStyle(
                            color: AppColors.FF959EB1, fontSize: 14.0),
                        children: [
                          TextSpan(
                              text: '￥' + model.budgetCurrent,
                              style: const TextStyle(color: AppColors.FFE45C26))
                        ])),
                  ],
                ),
                Spacer(),
                CustomPaint(
                  painter: CircleBorderPinter(
                      size: 65, color: AppColors.FFE45C26, ratio: ratio),
                  child: SizedBox(
                    width: 65,
                    height: 65,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text('剩余',
                                style: TextStyle(
                                    color: AppColors.FFE45C26.withOpacity(0.8),
                                    fontSize: 10)),
                          ),
                          Text(((1 - ratio) * 100).toStringAsFixed(0) + '%',
                              style: TextStyle(
                                  color: AppColors.FFE45C26, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
