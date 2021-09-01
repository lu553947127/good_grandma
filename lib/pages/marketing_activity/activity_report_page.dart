import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/marketing_activity_model.dart';
import 'package:good_grandma/pages/marketing_activity/edit_activity_report_page.dart';
import 'package:good_grandma/widgets/marketing_activity_detail_title.dart';
import 'package:good_grandma/widgets/marketing_activity_msg_cell.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';

///活动报表
class ActivityReportPage extends StatefulWidget {
  const ActivityReportPage(
      {Key key,
      @required this.model,
      @required this.state,
      @required this.stateColor})
      : super(key: key);
  final MarketingActivityModel model;
  final String state;
  final Color stateColor;

  @override
  _ActivityReportPageState createState() => _ActivityReportPageState();
}

class _ActivityReportPageState extends State<ActivityReportPage> {
  List<Map> _list1 = [];
  String _remark = '';

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('活动报表'),
          actions: [
            TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => EditActivityReportPage(
                            model: widget.model,
                            state: widget.state,
                            stateColor: widget.stateColor))),
                child: const Text('编辑',
                    style:
                        TextStyle(color: AppColors.FFC08A3F, fontSize: 14.0))),
          ],
        ),
        body: Scrollbar(
            child: CustomScrollView(
          slivers: [
            MarketingActivityDetailTitle(
                model: widget.model,
                state: widget.state,
                stateColor: widget.stateColor,
                showTime: false),
            PostDetailGroupTitle(color: AppColors.FFC08A3F, name: '报表信息'),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  Map map = _list1[index];
                  String title = map['title'];
                  String value = map['value'];
                  return MarketingActivityMsgCell(title: title, value: value);
                }, childCount: _list1.length),
              ),
            ),
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              sliver: SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 15.0),
                    title: const Text('文本区域',
                        style: TextStyle(
                            color: AppColors.FF959EB1, fontSize: 14.0)),
                    subtitle: Text(_remark,
                        style: const TextStyle(
                            color: AppColors.FF2F4058, fontSize: 14.0)),
                  ),
                ),
              ),
            )
          ],
        )));
  }

  void _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _list1 = [
      {'title': '文本框', 'value': '内容内容内容'},
      {'title': '时间', 'value': '2021-08-20'},
      {'title': '单选按钮', 'value': '选项'}
    ];
    _remark = '备注信息备注信息备注信息备注信息备注信息备注备注信息备注信息备注信息备注信息备注信息';
    if (mounted) setState(() {});
  }
}
