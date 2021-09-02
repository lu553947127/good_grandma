import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_progress_view.dart';
import 'package:good_grandma/models/day_post_add_model.dart';
import 'package:good_grandma/widgets/home_report_cell.dart';
import 'package:good_grandma/widgets/home_report_cell_list.dart';

///工作报告统计详细cell
class ReportStatisticsDetailCell extends StatelessWidget {
  const ReportStatisticsDetailCell({Key key,@required this.model}) : super(key: key);
  final DayPostAddModel model;

  @override
  Widget build(BuildContext context) {
    String title1 = '今日工作总结';
    String title2 = '明日工作计划';
    if(model.type == 2){
      title1 = '本周区域重点工作总结';
      title2 = '下周工作计划';
    }
    else if(model.type == 3){
      title1 = '本月重点工作总结';
      title2 = '下月重点工作内容';
    }
    final Map map = HomeReportCell.transInfoFromPostType(model.type);
    final Color color = map['color'];
    return ListTile(
      title: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              HomeReportCellList(list: model.summaries, title: title1,type: model.type),
              HomeReportCellList(list: model.plans, title: title2),
              Padding(
                padding:
                const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                child: Row(
                  children: [
                    const Text(
                      '业绩进度',
                      style: TextStyle(color: AppColors.FF2F4058, fontSize: 12.0),
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                            text: '￥' + model.cumulative,
                            style: const TextStyle(
                                color: AppColors.FFE45C26, fontSize: 12.0),
                            children: [
                              TextSpan(
                                text: ' / ￥' + model.target,
                                style: const TextStyle(
                                    color: AppColors.FFC1C8D7, fontSize: 12.0),
                              )
                            ]),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 10.0, right: 10.0),
                child: MyProgressView(
                    ratio: double.parse(model.achievementRate) / 100,
                    height: 6.0,
                    borderRadius: 3,
                    backgroundColor: color.withOpacity(0.1),
                    valueColor: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}