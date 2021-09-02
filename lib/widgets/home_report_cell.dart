import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/models/home_report_model.dart';
import 'package:good_grandma/pages/work/work_report/day_post_detail_page.dart';
import 'package:good_grandma/pages/work/work_report/month_post_detail_page.dart';
import 'package:good_grandma/pages/work/work_report/month_post_detail_zn_page.dart';
import 'package:good_grandma/pages/work/work_report/week_post_detail_page.dart';
import 'package:good_grandma/pages/work/work_report/week_post_detail_zn_page.dart';
import 'package:good_grandma/widgets/home_report_cell_list.dart';
import 'package:good_grandma/widgets/post_progress_view.dart';

class HomeReportCell extends StatelessWidget {
  final HomeReportModel model;

  HomeReportCell({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map map = transInfoFromPostType(model.postType);
    final Color color = map['color'];
    final String name = map['name'];
    //是否是职能
    bool isZN = false;
    return ListTile(
      onTap: () {
        if (model.postType == 1) {
          //日报
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return DayPostDetailPage(model: model, themColor: color);
          }));
        } else if (model.postType == 2) {
          //周报
          if (isZN) {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return WeekPostDetailZNPage(model: model, themColor: color);
            }));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return WeekPostDetailPage(model: model, themColor: color);
            }));
          }
        } else if (model.postType == 3) {
          //月报
          if (isZN) {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return MonthPostDetailZNPage(model: model, themColor: color);
            }));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return MonthPostDetailPage(model: model, themColor: color);
            }));
          }
        }
      },
      contentPadding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      title: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  offset: Offset(2, 1), //x,y轴
                  color: Colors.black.withOpacity(0.1), //投影颜色
                  blurRadius: 1 //投影距离
              ),
            ]),
        child: Column(
          children: [
            //头像 名称 日期 类别
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Row(
                children: [
                  ClipOval(
                    child: MyCacheImageView(
                      imageURL: model.avatar,
                      width: 30.0,
                      height: 30.0,
                      errorWidgetChild:
                      Icon(Icons.supervised_user_circle, size: 30.0),
                    ),
                  ),
                  Text('  ' + (model.userName ?? '') + '  ',
                      style: const TextStyle(fontSize: 14.0)),
                  Expanded(
                      child: Text(model.time ?? '',
                          style: const TextStyle(
                              color: AppColors.FF959EB1, fontSize: 12.0))),
                  Container(
                    width: 37,
                    height: 20,
                    decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2.5),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(2, 1),
                            color: color.withOpacity(0.4),
                            blurRadius: 1.5,
                          ),
                        ]),
                    child: Center(
                        child: Text('$name报',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11.0))),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.FFF4F5F8, thickness: 1, height: 1.0),
            //本周目标
            PostProgressView(
                count: model.target,
                current: model.target,
                color: color.withOpacity(0.4),
                title: '本$name目标',
                textColor: color),
            //本周累计
            PostProgressView(
                count: model.target,
                current: model.cumulative,
                color: color.withOpacity(0.6),
                title: '本$name累计',
                textColor: color),
            //本周实际
            PostProgressView(
                count: model.target,
                current: model.actual,
                color: color,
                title: '本$name实际',
                textColor: color),
            const Divider(
                color: AppColors.FFEFEFF4,
                thickness: 1,
                indent: 10.0,
                endIndent: 10.0),
            HomeReportCellList(
                list: model.summary ?? [], title: '本$name区域重点工作总结'),
            HomeReportCellList(
                list: model.plans ?? [],
                title: (name == '日' ? '明' : '下') + '$name工作计划'),
          ],
        ),
      ),
    );
  }
  ///工作报告类型转颜色和中文名
  static Map transInfoFromPostType(int postType) {
    if (postType == 1) {
      //日
      return {'color': AppColors.FFE5A800, 'name': '日'};
    } else if (postType == 2) {
      //周
      return {'color': AppColors.FFC08A3F, 'name': '周'};
    }
    //月
    return {'color': AppColors.FFE45C26, 'name': '月'};
  }
}
