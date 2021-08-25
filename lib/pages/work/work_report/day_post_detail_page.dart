import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:good_grandma/models/home_report_model.dart';
import 'package:good_grandma/widgets/post_detail_bottom_report_view.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/post_detail_header_view.dart';
import 'package:good_grandma/widgets/post_detail_plan_list.dart';
import 'package:good_grandma/widgets/post_detail_progress_view.dart';
import 'package:good_grandma/widgets/post_detail_report_list.dart';

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

  ///反馈列表
  List<Map> _reportList = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('日报详情'),
      ),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            //用户信息
            PostDetailHeaderView(
                avatar: widget.model.avatar,
                name: widget.model.userName,
                time: widget.model.time,
                position: _position,
                color: widget.themColor,
                postType: widget.model.postType,
                area: _area),
            //销量进度追踪（元）
            PostDetailGroupTitle(color: widget.themColor, name: '销量进度追踪（元）'),
            PostDetailProgressView(
                cumulative: widget.model.cumulative,
                target: widget.model.target,
                current: widget.model.target,
                color: widget.themColor,
                typeName: '今日销售'),
            //今日工作总结
            PostDetailGroupTitle(color: widget.themColor, name: '今日工作总结'),
            PostDetailPlanList(list: widget.model.summary),
            //明日工作计划
            PostDetailGroupTitle(color: widget.themColor, name: '明日工作计划'),
            PostDetailPlanList(list: widget.model.plans),
            //反馈
            PostDetailGroupTitle(color: widget.themColor, name: '反馈'),
            SliverSafeArea(
                sliver: PostDetailReportList(reportList: _reportList)),
          ],
        ),
      ),
      bottomNavigationBar: PostDetailBottomReportView(sendAction: _onSend),
    );
  }

  void _onSend(String text) {
    print('send = $text');
  }

  void _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _area = '新疆维吾尔自治区·克孜勒苏柯尔克孜自治州';
    _position = '城市经理';
    _reportList.clear();
    for (int i = 0; i < 10; i++) {
      _reportList.add({
        'image':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '李四$i',
        'time': '2012-05-29 16:31:50',
        'content':
            '评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评',
      });
    }
    if (mounted) setState(() {});
  }
}

