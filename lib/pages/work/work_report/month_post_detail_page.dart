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
import 'package:good_grandma/widgets/post_detail_plan_view_with_line.dart';
import 'package:good_grandma/widgets/post_detail_sales_tracking_cell.dart';

///月报详情
class MonthPostDetailPage extends StatefulWidget {
  final HomeReportModel model;
  final Color themColor;
  const MonthPostDetailPage(
      {Key key, @required this.model, @required this.themColor})
      : super(key: key);

  @override
  _MonthPostDetailPageState createState() => _MonthPostDetailPageState();
}

class _MonthPostDetailPageState extends State<MonthPostDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('月报详情')),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: FutureBuilder(
          future: requestPost(Api.reportDayDetail,
              json: jsonEncode({'id': widget.model.id, 'type': 3})),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
              if (salesTrackingListS.isNotEmpty) {
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
                {
                  'title': '本周目标',
                  'value': target.toStringAsFixed(2),
                  'end': '万元'
                },
                {
                  'title': '本周实际',
                  'value': actual.toStringAsFixed(2),
                  'end': '万元'
                },
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
                  'title': '下月规划进货金额',
                  'value': nextTarget.toStringAsFixed(2),
                  'end': '万元'
                }
              ];

              ///重点工作总结
              List<String> _summaries = [];
              String summaries = map['summaries'];
              _summaries = AppUtil.getListFromString(summaries);

              // print('itineraries = ${map['itineraries']}');
              ///下月行程及工作内容
              List<Map> itineraries = [];
              List<dynamic> itinerariesS = map['itineraries'] ?? [];
              if (itinerariesS.isNotEmpty) {
                itinerariesS.forEach((element) {
                  String title = element['title'];
                  String worksS = element['work'].toString();
                  // print('works = $worksS');
                  List<String> works = AppUtil.getListFromString(worksS);
                  itineraries.add({'title': title, 'works': works});
                });
              }

              ///重点工作内容
              List<String> _nextWorks = [];
              String works = map['plans'];
              _nextWorks = AppUtil.getListFromString(works);

              ///问题反馈以及解决方案
              List<String> _reportAndPlans = [];
              String reports = map['reports'];
              _reportAndPlans = AppUtil.getListFromString(reports);
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
                    //销量进度追踪（万元）
                    PostDetailGroupTitle(
                        color: widget.themColor, name: '销量进度追踪（万元）'),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      sliver: SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                        SalesTrackingModel model = salesTrackingList[index];
                        return PostDetailSalesTrackingCell(
                            model: model, color: widget.themColor);
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
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 15.0)),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      sliver: SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                        Map map = list1[index];
                        String title = map['title'];
                        String value = map['value'];
                        String hintText = map['hintText'];
                        String end = map['end'];
                        return Container(
                          color: Colors.white,
                          child: PostAddInputCellCore(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 6),
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

                    //本月重点工作总结
                    PostDetailGroupTitle(
                        color: widget.themColor, name: '本月重点工作总结'),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(4))),
                            child: WorkListWithTitle(
                                title: '', works: _summaries)),
                      ),
                    ),
                    //下月行程及工作内容
                    PostDetailGroupTitle(
                        color: widget.themColor, name: '下月行程及工作内容'),
                    PostDetailPlanViewWithLine(
                        plans: itineraries, themColor: widget.themColor),
                    SliverToBoxAdapter(
                        child: PostDetailKeyWorkView(
                            title: '重点工作内容', works: _nextWorks)),
                    //问题反馈以及解决方案
                    PostDetailGroupTitle(
                        color: widget.themColor, name: '问题反馈以及解决方案'),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4)),
                            child: WorkListWithTitle(
                                title: '', works: _reportAndPlans)),
                      ),
                    ),
                    SliverSafeArea(sliver: SliverToBoxAdapter(child: SizedBox(height: 10.0),)),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return NoDataWidget(emptyRetry: () => setState(() {}));
            }
            return LoadingWidget();
          },
        ),
      ),
    );
  }
}
