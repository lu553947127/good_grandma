import 'package:flutter/material.dart';
import 'package:good_grandma/models/home_report_model.dart';
import 'package:good_grandma/widgets/post_detail_bottom_report_view.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/post_detail_header_view.dart';
import 'package:good_grandma/widgets/post_detail_plan_list.dart';
import 'package:good_grandma/widgets/post_detail_report_list.dart';
///月报详情(职能)
class MonthPostDetailZNPage extends StatefulWidget {
  final HomeReportModel model;
  final Color themColor;
  const MonthPostDetailZNPage({Key key, @required this.model, @required this.themColor}) : super(key: key);

  @override
  _MonthPostDetailZNPageState createState() => _MonthPostDetailZNPageState();
}

class _MonthPostDetailZNPageState extends State<MonthPostDetailZNPage> {
  String _position = '';
  String _area = '';

  ///问题列表
  List<String> _problems = [];
  ///建议列表
  List<String> _proposals = [];
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
      appBar: AppBar(title: const Text('月报详情')),
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
            //本周工作内容
            PostDetailGroupTitle(color: widget.themColor, name: '本月工作内容'),
            PostDetailPlanList(list: widget.model.summary),
            //本周工作中存在的问题及需改进的方面
            PostDetailGroupTitle(color: widget.themColor, name: '本月工作中存在的问题及需改进的方面'),
            PostDetailPlanList(list: _problems),
            //下周工作计划
            PostDetailGroupTitle(color: widget.themColor, name: '下月工作计划'),
            PostDetailPlanList(list: widget.model.plans),
            //建议
            PostDetailGroupTitle(color: widget.themColor, name: '建议'),
            PostDetailPlanList(list: _proposals),
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

    _problems.clear();
    _problems.addAll([
      '本周工作中存在的问题及需改进的方面',
      '本周工作中存在的问题及需改进的方面',
      '本周工作中存在的问题及需改进的方面',
      '本周工作中存在的问题及需改进的方面',
      '本周工作中存在的问题及需改进的方面',
      '本周工作中存在的问题及需改进的方面',
    ]);

    _proposals.clear();
    _proposals.addAll([
      '本周工作中存在的问题及需改进的方面1',
      '本周工作中存在的问题及需改进的方面1',
      '本周工作中存在的问题及需2改进的方面',
      '本周工作中存在的问题及需改进的方面',
      '本周工作中存在的问题及3需改进的方面',
      '本周工作中存在的问题f及需改进的方面',
    ]);

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
