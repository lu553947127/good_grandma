import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/loading_widget.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/models/home_report_model.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/post_detail_header_view.dart';
import 'package:good_grandma/widgets/post_detail_key_work_view.dart';
import 'package:good_grandma/widgets/post_detail_progress_view.dart';

///日报详情
class DayPostDetailPage extends StatefulWidget {
  final HomeReportModel model;
  final Color themColor;
  const DayPostDetailPage(
      {Key key, @required this.model, @required this.themColor})
      : super(key: key);

  @override
  _DayPostDetailPageState createState() => _DayPostDetailPageState();
}

class _DayPostDetailPageState extends State<DayPostDetailPage> {
  String _position = '';
  String _area = '';

  @override
  Widget build(BuildContext context) {
    // print('param = ${jsonEncode({'id': widget.model.id, 'type': 1})}');
    return Scaffold(
      appBar: AppBar(title: Text('日报详情')),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: FutureBuilder(
          future: requestPost(Api.reportDayDetail,
              json: jsonEncode({'id': widget.model.id, 'type': 1})),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              // LogUtil.d('reportDayDetail value = ${snapshot.data}');
              Map map = jsonDecode(snapshot.data.toString())['data'];
              _area = map['postName'] ?? '';
              _position = _area;
              String time = map['time'] ?? '';
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
                    //销量进度追踪（元）
                    PostDetailGroupTitle(
                        color: widget.themColor, name: '销量进度追踪（元）'),
                    PostDetailProgressView(
                        cumulative: widget.model.cumulative,
                        target: widget.model.target,
                        current: widget.model.actual,
                        color: widget.themColor,
                        typeName: '今日销售',
                        difference: 0,
                        completionRate: widget.model.cumulative /
                            widget.model.target *
                            100),
                    //今日工作总结
                    PostDetailGroupTitle(
                        color: widget.themColor, name: '今日工作总结'),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4)),
                            child: WorkListWithTitle(
                                title: '', works: widget.model.summary)),
                      ),
                    ),
                    //明日工作计划
                    PostDetailGroupTitle(
                        color: widget.themColor, name: '明日工作计划'),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4)),
                            child: WorkListWithTitle(
                                title: '', works: widget.model.plans)),
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
          },
        ),
      ),
    );
  }
}
