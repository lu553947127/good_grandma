import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/loading_widget.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/home_report_model.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/post_detail_header_view.dart';
import 'package:good_grandma/widgets/post_detail_key_work_view.dart';

///周(月)报详情(职能)
class PostDetailZNPage extends StatefulWidget {
  final HomeReportModel model;
  final Color themColor;
  final bool forWeek;
  const PostDetailZNPage(
      {Key key,
      @required this.model,
      @required this.themColor,
      this.forWeek = true})
      : super(key: key);

  @override
  _PostDetailZNPageState createState() => _PostDetailZNPageState();
}

class _PostDetailZNPageState extends State<PostDetailZNPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.forWeek ? '周报详情' : '月报详情')),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: FutureBuilder(
            future: requestPost(Api.reportDayDetail,
                json: jsonEncode(
                    {'id': widget.model.id, 'type': widget.forWeek ? 2 : 3})),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // LogUtil.d('reportDayDetail value = ${snapshot.data}');
                Map map = jsonDecode(snapshot.data.toString())['data'];
                String _position = '';
                String _area = '';
                _area = map['postName'] ?? '';
                _position = _area;
                String time = map['time'] ?? '';

                ///本周工作内容
                List<String> _currentWorks = [];
                String works = map['currentWorks'];
                _currentWorks = AppUtil.getListFromString(works);

                ///工作中存在的问题及需改进的方面
                List<String> _problems = [];
                String problemsS = map['problems'];
                _problems = AppUtil.getListFromString(problemsS);

                ///工作计划
                List<String> _plans = [];
                String plansS = map['plans'];
                _plans = AppUtil.getListFromString(plansS);

                ///建议
                List<String> _suggests = [];
                String suggestsS = map['suggests'];
                _suggests = AppUtil.getListFromString(suggestsS);

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
                      //本周工作内容
                      PostDetailGroupTitle(
                          color: widget.themColor,
                          name: widget.forWeek ? '本周工作内容' : '本月工作内容'),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        sliver: SliverToBoxAdapter(
                          child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4)),
                              child: WorkListWithTitle(
                                  title: '', works: _currentWorks)),
                        ),
                      ),
                      //本周工作中存在的问题及需改进的方面
                      PostDetailGroupTitle(
                          color: widget.themColor,
                          name: widget.forWeek
                              ? '本周工作中存在的问题及需改进的方面'
                              : '本月工作中存在的问题及需改进的方面'),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        sliver: SliverToBoxAdapter(
                          child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4)),
                              child: WorkListWithTitle(
                                  title: '', works: _problems)),
                        ),
                      ),
                      //下周工作计划
                      PostDetailGroupTitle(
                          color: widget.themColor,
                          name: widget.forWeek ? '下周工作计划' : '下月工作计划'),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        sliver: SliverToBoxAdapter(
                          child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4)),
                              child: WorkListWithTitle(
                                  title: '', works: _plans)),
                        ),
                      ),
                      //建议
                      PostDetailGroupTitle(color: widget.themColor, name: '建议'),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        sliver: SliverToBoxAdapter(
                          child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4)),
                              child: WorkListWithTitle(
                                  title: '', works: _suggests)),
                        ),
                      ),
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
