import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/models/day_post_add_model.dart';
import 'package:good_grandma/models/home_report_model.dart';
import 'package:good_grandma/models/month_post_add_new_model.dart';
import 'package:good_grandma/models/post_add_zn_model.dart';
import 'package:good_grandma/models/week_post_add_new_model.dart';
import 'package:good_grandma/pages/work/work_report/day_post_add_page.dart';
import 'package:good_grandma/pages/work/work_report/day_post_detail_page.dart';
import 'package:good_grandma/pages/work/work_report/month_post_add_page.dart';
import 'package:good_grandma/pages/work/work_report/month_post_detail_page.dart';
import 'package:good_grandma/pages/work/work_report/post_add_zn_page.dart';
import 'package:good_grandma/pages/work/work_report/week_post_add_page.dart';
import 'package:good_grandma/pages/work/work_report/week_post_detail_page.dart';
import 'package:good_grandma/pages/work/work_report/post_detail_zn_page.dart';
import 'package:good_grandma/widgets/home_report_cell_list.dart';
import 'package:good_grandma/widgets/post_progress_view.dart';
import 'package:provider/provider.dart';

class HomeReportCell extends StatelessWidget {
  final HomeReportModel model;

  ///是否是草稿
  final bool isCG;
  final VoidCallback needRefreshAction;

  HomeReportCell(
      {Key key,
      @required this.model,
      this.isCG = false,
      this.needRefreshAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map map = transInfoFromPostType(model.postType);
    final Color color = map['color'];
    final String name = map['name'];
    return ListTile(
      onTap: () => _onTap(context, color),
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
                      errorWidgetChild: Image.asset(
                          'assets/images/icon_empty_user.png',
                          width: 30.0,
                          height: 30.0),
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
            //目标
            Visibility(
              visible: !model.isZN,
              child: PostProgressView(
                  count: model.target,
                  current: model.target,
                  color: color.withOpacity(0.4),
                  title: model.postType == 1 ? '本月目标' : '本$name目标',
                  textColor: color,
                showWY: model.postType == 1 ?false:true,
              ),
            ),
            //累计
            Visibility(
              visible: !model.isZN,
              child: PostProgressView(
                  count: model.target,
                  current: model.cumulative,
                  color: color.withOpacity(0.6),
                  title: '本月累计',
                  textColor: color,
                showWY: model.postType == 1 ?false:true,),
            ),
            //实际
            Visibility(
              visible: !model.isZN,
              child: PostProgressView(
                  count: model.target,
                  current: model.actual,
                  color: color,
                  title: '本$name实际',
                  textColor: color,
                showWY: model.postType == 1 ?false:true,),
            ),
            Visibility(
              visible: !model.isZN,
              child: const Divider(
                  color: AppColors.FFEFEFF4,
                  thickness: 1,
                  indent: 10.0,
                  endIndent: 10.0),
            ),
            HomeReportCellList(
                list: model.summary ?? [], title: '本$name' + (model.isZN?'工作内容':'区域重点工作总结')),
            HomeReportCellList(
                list: model.plans ?? [],
                title: (name == '日' ? '明' : '下') + '$name工作计划'),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context, Color color) async {
    if (isCG) {
      //草稿
      bool result;
      if (model.postType == 1) {
        //日报
        DayPostAddModel addModel = DayPostAddModel();
        addModel.id = model.id;
        addModel.setTarget(model.target.toString());
        addModel.setActual(model.actual.toString());
        addModel.setCumulative(model.cumulative.toString());
        addModel.setAchievementRate();
        addModel.setSummaries(model.summary);
        addModel.setPlans(model.plans);
        result = await Navigator.push(context, MaterialPageRoute(builder: (_) {
          return ChangeNotifierProvider<DayPostAddModel>.value(
              value: addModel, child: DayPostAddPage(id: model.id));
        }));
      } else if (model.postType == 2) {
        //周报
        if (model.isZN) {
          //职能**
          PostAddZNModel addModel = PostAddZNModel();
          addModel.id = model.id;
          result =
              await Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ChangeNotifierProvider<PostAddZNModel>.value(
                value: addModel, child: PostAddZNPage(id: model.id));
          }));
        } else {
          WeekPostAddNewModel addModel = WeekPostAddNewModel();
          addModel.id = model.id;
          result =
              await Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ChangeNotifierProvider<WeekPostAddNewModel>.value(
                value: addModel, child: WeekPostAddPage(id: model.id));
          }));
        }
      } else if (model.postType == 3) {
        //月报
        if (model.isZN) {
          //职能**
          PostAddZNModel addModel = PostAddZNModel();
          addModel.id = model.id;
          result =
              await Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ChangeNotifierProvider<PostAddZNModel>.value(
                value: addModel,
                child: PostAddZNPage(isWeek: false, id: model.id));
          }));
        } else {
          MonthPostAddNewModel addModel = MonthPostAddNewModel();
          addModel.id = model.id;
          result =
              await Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ChangeNotifierProvider<MonthPostAddNewModel>.value(
                value: addModel, child: MonthPostAddPage(id: model.id));
          }));
        }
      }
      if (result != null && result && needRefreshAction != null)
        needRefreshAction();
    } else {
      //详细
      if (model.postType == 1) {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return DayPostDetailPage(model: model, themColor: color);
        }));
      } else if (model.postType == 2) {
        //周报
        if (model.isZN) {
          //职能
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return PostDetailZNPage(
              model: model,
              themColor: color,
            );
          }));
        } else {
          //详情
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return WeekPostDetailPage(model: model, themColor: color);
          }));
        }
      } else if (model.postType == 3) {
        //月报
        if (model.isZN) {
          //职能
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return PostDetailZNPage(
              model: model,
              themColor: color,
              forWeek: false,
            );
          }));
        } else {
          //详情
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return MonthPostDetailPage(model: model, themColor: color);
          }));
        }
      }
    }
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
