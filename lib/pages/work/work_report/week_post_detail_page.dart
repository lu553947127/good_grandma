import 'package:flutter/material.dart';
import 'package:good_grandma/models/home_report_model.dart';
import 'package:good_grandma/widgets/post_detail_bottom_report_view.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/post_detail_header_view.dart';
import 'package:good_grandma/widgets/post_detail_key_work_view.dart';
import 'package:good_grandma/widgets/post_detail_next_week_work_view.dart';
import 'package:good_grandma/widgets/post_detail_plan_view_with_line.dart';
import 'package:good_grandma/widgets/post_detail_progress_view.dart';
import 'package:good_grandma/widgets/post_detail_report_list.dart';

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
  String _position = '';
  String _area = '';

  ///下月行程
  List<Map> _plans = [];

  ///本周区域重点工作总结
  List<String> _works = [];

  ///下周行程及重点工作内容
  Map _nextWeek = {};

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
      appBar: AppBar(title: const Text('周报详情')),
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
            //销量进度追踪
            PostDetailGroupTitle(color: widget.themColor, name: '销量进度追踪（元）'),
            PostDetailProgressView(
                cumulative: widget.model.cumulative,
                target: widget.model.target,
                current: widget.model.target,
                color: widget.themColor,
                typeName: '本周实际'),
            //下月行程及工作内容
            PostDetailGroupTitle(color: widget.themColor, name: '下月行程及工作内容'),
            PostDetailPlanViewWithLine(
                plans: _plans, themColor: widget.themColor),
            SliverToBoxAdapter(
                child:
                    PostDetailKeyWorkView(title: '本周区域重点工作总结', works: _works)),
            //下周行程及重点工作内容
            PostDetailGroupTitle(color: widget.themColor, name: '下周行程及重点工作内容'),
            PostDetailNextWeekWorkView(nextWeek: _nextWeek),
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

    _plans.clear();
    _plans.addAll([
      {
        'title': '周一',
        'plans': [
          '本周工作中存在的问题及需改进的方面',
          '本周工作中存在的问题及需改进的方面',
          '本周工作中存在的问题及需改进的方面',
        ]
      },
      {
        'title': '周二',
        'plans': [
          '本周工作中存在的问题及需改进的方面',
          '本周工作中存在的问题及需改进的方面',
          '本周工作中存在的问题及需改进的方面',
        ]
      },
      {
        'title': '周三',
        'plans': [
          '本周工作中存在的问题及需改进的方面',
          '本周工作中存在的问题及需改进的方面',
          '本周工作中存在的问题及需改进的方面',
        ]
      },
      {
        'title': '周四',
        'plans': [
          '本周工作中存在的问题及需改进的方面',
          '本周工作中存在的问题及需改进的方面',
          '本周工作中存在的问题及需改进的方面',
        ]
      },
      {
        'title': '周五',
        'plans': [
          '本周工作中存在的问题及需改进的方面',
          '本周工作中存在的问题及需改进的方面',
          '本周工作中存在的问题及需改进的方面',
        ]
      },
      {
        'title': '周六',
        'plans': [
          '本周工作中存在的问题及需改进的方面',
          '本周工作中存在的问题及需改进的方面',
          '本周工作中存在的问题及需改进的方面',
        ]
      },
    ]);

    _works.clear();
    _works.addAll([
      '本周工作中存在的问题及需改进的方面',
      '本周工作中存在的问作中存在的作中存在的作中存在的作中存在的作中存在的题及需改进的方面',
      '本周工作中存在的问题及需改进的方面',
      '本周工作中存在的问题及需改进的方面',
      '本周工作中存在的问题及需改进的方面',
      '本周工作中存在的问题及需改进的方面',
    ]);

    _nextWeek = {
      'cities': [
        {'title': '周一', 'city': '济南'},
        {'title': '周二', 'city': '秦皇岛'},
        {'title': '周三', 'city': '北京'},
        {'title': '周四', 'city': '石家庄'},
        {'title': '周五', 'city': '呼和浩特'},
        {'title': '周六', 'city': '克孜勒苏柯尔克孜'},
      ],
      'works': [
        '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
        '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
        '和冯经理拜访经销商和冯经理拜访经和冯经理拜访经销商和冯经理拜访经销商和冯经理销商和冯经理',
        '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
        '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
        '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
      ],
    };

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
