import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/loading_widget.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/home_report_model.dart';
import 'package:good_grandma/models/week_post_add_new_model.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/post_detail_header_view.dart';
import 'package:good_grandma/widgets/post_detail_key_work_view.dart';
import 'package:good_grandma/widgets/post_detail_next_week_work_view.dart';
import 'package:good_grandma/widgets/post_detail_sales_tracking_cell.dart';
import 'package:good_grandma/widgets/week_post_detail_plan_view_with_line.dart';

///周报详情
class WeekPostDetailPage extends StatefulWidget {
  final HomeReportModel model;
  final Color themColor;
  const WeekPostDetailPage(
      {Key key, @required this.model, @required this.themColor})
      : super(key: key);

  @override
  _WeekPostDetailPageState createState() => _WeekPostDetailPageState();
}

class _WeekPostDetailPageState extends State<WeekPostDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('周报详情')),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: FutureBuilder(
            future: requestPost(Api.reportDayDetail,
                json: jsonEncode({'id': widget.model.id, 'type': 2})),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // LogUtil.d('reportDayDetail value = ${snapshot.data}');
                Map map = jsonDecode(snapshot.data.toString())['data'];
                String _position = '';
                String _area = '';
                _area = map['postName'] ?? '';
                _position = _area;
                String time = map['time'] ?? '';

                ///销量进度追踪（万元）
                List<SalesTrackingModel> salesTrackingList = [];
                double target = 0;
                double actual = 0;
                double cumulative = 0;
                double difference = 0;
                double completionRate = 0;
                double nextTarget = 0;
                String salesTrackingListS = map['salesTrackingList'] ?? '';
                if(salesTrackingListS.isNotEmpty){
                  List list = jsonDecode(salesTrackingListS);
                  // print('list = $list');
                  list.forEach((map) {
                    SalesTrackingModel model = SalesTrackingModel.fromJson(map);
                    target += model.target;
                    actual += model.actual;
                    cumulative += model.cumulative;
                    difference += model.difference;
                    completionRate += model.completionRate;
                    nextTarget += model.nextTarget;
                    salesTrackingList.add(model);
                  });
                }
                List<Map> list1 = [
                  {'title': '本周目标', 'value': target.toStringAsFixed(2), 'end': '万元'},
                  {'title': '本周实际', 'value': actual.toStringAsFixed(2), 'end': '万元'},
                  {
                    'title': '本月累计',
                    'value': cumulative.toStringAsFixed(2),
                    'end': '万元'
                  },
                  {
                    'title': '月度差额',
                    'value': difference.toStringAsFixed(2),
                    'end': '万元'
                  },
                  {
                    'title': '月度达成率',
                    'value': completionRate.toStringAsFixed(2),
                    'end': '%'
                  },
                  {
                    'title': '下周规划进货金额',
                    'value': nextTarget.toStringAsFixed(2),
                    'end': '万元'
                  }
                ];
                ///目标达成说明
                String targetDesc = map['summaries'] ?? '';
                ///本周行程及工作内容
                List<Map> itineraries = [];
                List<dynamic> itinerariesS = map['itineraries'] ?? '';
                if(itinerariesS.isNotEmpty){
                  itinerariesS.forEach((element) {
                    itineraries.add(element);
                  });
                }
                ///本周区域重点工作总结
                List<String> summaries = [];
                String summaries1 = map['targetDesc'];
                summaries = AppUtil.getListFromString(summaries1);
                ///下月行程及工作内容
                Map _nextWeek = {};
                List<Map> cities = [];
                List<String> works = [];

                List<dynamic> citiesS = map['cities'] ?? '';
                if(citiesS.isNotEmpty){
                  citiesS.forEach((element) {
                    cities.add(element);
                  });
                }
                _nextWeek['cities'] = cities;

                String worksS = map['plans'];
                works = AppUtil.getListFromString(worksS);
                _nextWeek['works'] = works;

                final lineCore = Container(
                  color: Colors.white,
                  child: const Divider(color: AppColors.FFF4F5F8,thickness: 5,indent: 10,endIndent: 10),
                );
                final line = SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  sliver: SliverToBoxAdapter(
                    child: lineCore,
                  ),
                );

                return Scrollbar(
                  child: CustomScrollView(
                    slivers: [
                      //用户信息
                      PostDetailHeaderView(
                          avatar: widget.model.avatar,
                          name: widget.model.userName,
                          time: time,
                          position: _position,
                          color: widget.themColor,
                          postType: widget.model.postType,
                          area: _area),
                      //销量进度追踪
                      PostDetailGroupTitle(
                          color: widget.themColor, name: '销量进度追踪（万元）'),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((context, index) {
                              SalesTrackingModel model = salesTrackingList[index];
                              return PostDetailSalesTrackingCell(model: model,color: widget.themColor,forWeek:true);
                            }, childCount: salesTrackingList.length)),
                      ),
                      //合计
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        sliver: SliverToBoxAdapter(
                          child: Container(
                            padding: const EdgeInsets.all(15.0),
                            color: Colors.white,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('合计',
                                  style:
                                  const TextStyle(color: Colors.red, fontSize: 15.0)),
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((context, index) {
                              Map map = list1[index];
                              String title = map['title'];
                              String value = map['value'];
                              String hintText = map['hintText'];
                              String end = map['end'];
                              return Container(
                                color: Colors.white,
                                child: PostAddInputCellCore(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 6),
                                  title: title,
                                  value: value,
                                  hintText: hintText,
                                  endWidget: null,
                                  end: end,
                                  fontSize: 14.0,
                                  titleColor: AppColors.FF959EB1,
                                ),
                              );
                            }, childCount: list1.length)),
                      ),
                      line,
                      //目标达成说明
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        sliver: SliverToBoxAdapter(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(4))
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.only(bottom: 10,left: 14.0,right: 14.0),
                              title: const Text('目标达成说明\n',style: TextStyle(color: AppColors.FF959EB1,fontSize: 15)),
                              subtitle: Text(targetDesc,style: const TextStyle(color: AppColors.FF2F4058,fontSize: 14)),
                            ),
                          ),
                        ),
                      ),
                      //本周行程及工作内容
                      PostDetailGroupTitle(
                          color: widget.themColor, name: '本周行程及工作内容'),
                      WeekPostDetailPlanViewWithLine(
                          itineraries: itineraries, themColor: widget.themColor),
                      SliverToBoxAdapter(
                          child: PostDetailKeyWorkView(
                              title: '本周区域重点工作总结', works: summaries)),
                      //下周行程及重点工作内容
                      PostDetailGroupTitle(
                          color: widget.themColor, name: '下周行程及重点工作内容'),
                      PostDetailNextWeekWorkView(nextWeek: _nextWeek),
                      SliverSafeArea(sliver: SliverToBoxAdapter()),
                    ],
                  ),
                );
              }
              if (snapshot.hasError) {
                return NoDataWidget(emptyRetry: () => setState(() {}));
              }
              return LoadingWidget();
            }),
      ),
    );
  }
}

