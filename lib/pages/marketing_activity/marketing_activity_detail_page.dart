import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/models/goods_model.dart';
import 'package:good_grandma/models/marketing_activity_model.dart';
import 'package:good_grandma/pages/marketing_activity/activity_profit_page.dart';
import 'package:good_grandma/pages/marketing_activity/activity_report_page.dart';
import 'package:good_grandma/pages/marketing_activity/activity_summary_page.dart';
import 'package:good_grandma/widgets/market_activity_detail_budget_view.dart';
import 'package:good_grandma/widgets/marketing_activity_detail_title.dart';
import 'package:good_grandma/widgets/marketing_activity_msg_cell.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';

///市场活动详情
class MarketingActivityDetailPage extends StatefulWidget {
  const MarketingActivityDetailPage(
      {Key key,
      @required this.model,
      @required this.state,
      @required this.stateColor})
      : super(key: key);
  final MarketingActivityModel model;
  final String state;
  final Color stateColor;

  @override
  _MarketingActivityDetailPageState createState() =>
      _MarketingActivityDetailPageState();
}

class _MarketingActivityDetailPageState
    extends State<MarketingActivityDetailPage> {
  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    List<Map> _list1 = [
      {'title': '负  责  人', 'value': widget.model.leading},
      {'title': '活动类型', 'value': widget.model.type},
      {'title': '开始时间', 'value': widget.model.startTime},
      {'title': '结束时间', 'value': widget.model.endTime},
      {'title': '目标群体', 'value': widget.model.target},
      {'title': '目标数量', 'value': widget.model.targetCount},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('市场活动详情')),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            //title
            MarketingActivityDetailTitle(
                model: widget.model,
                stateColor: widget.stateColor,
                state: widget.state),
            //活动信息
            PostDetailGroupTitle(color: AppColors.FFC08A3F, name: '活动信息'),
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
            //活动预算
            PostDetailGroupTitle(color: AppColors.FFC08A3F, name: '活动预算'),
            MarketActivityDetailBudgetView(model: widget.model),
            //活动商品
            PostDetailGroupTitle(color: AppColors.FFC08A3F, name: '活动商品'),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  GoodsModel model = widget.model.goodsList[index];
                  return Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10.0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: MyCacheImageView(
                                imageURL: model.image, width: 60, height: 55),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(model.name,
                                style: const TextStyle(fontSize: 14.0)),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(model.spec,
                                  style: const TextStyle(fontSize: 12.0)),
                              Text('x${model.count}',
                                  style: const TextStyle(fontSize: 12.0)),
                            ],
                          ),
                        ),
                        const Divider(
                            color: AppColors.FFEFEFF4,
                            thickness: 1,
                            height: 1,
                            indent: 10.0,
                            endIndent: 10.0),
                      ],
                    ),
                  );
                }, childCount: widget.model.goodsList.length),
              ),
            ),
            SliverSafeArea(sliver: SliverToBoxAdapter()),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 57.0 + MediaQuery.of(context).padding.bottom,
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
          child: SizedBox(
            height: 57.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width - 10) / 3,
                  child: TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ActivityReportPage(
                                  model: widget.model,
                                  state: widget.state,
                                  stateColor: widget.stateColor))),
                      child: Column(
                        children: [
                          Image.asset('assets/images/market_table.png',
                              width: 16, height: 16),
                          Text('活动报表',
                              style: const TextStyle(
                                  color: AppColors.FF05A8C6, fontSize: 12.0))
                        ],
                      )),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: AppColors.FFEFEFF4,
                ),
                Container(
                  width: (MediaQuery.of(context).size.width - 10) / 3,
                  child: TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ActivityProfitPage(
                                  model: widget.model,
                                  state: widget.state,
                                  stateColor: widget.stateColor))),
                      child: Column(
                        children: [
                          Image.asset('assets/images/market_profit.png',
                              width: 16, height: 16),
                          Text('活动收益',
                              style: const TextStyle(
                                  color: AppColors.FFDD0000, fontSize: 12.0))
                        ],
                      )),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: AppColors.FFEFEFF4,
                ),
                Container(
                  width: (MediaQuery.of(context).size.width - 10) / 3,
                  child: TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ActivitySummaryPage(
                                  model: widget.model,
                                  state: widget.state,
                                  stateColor: widget.stateColor))),
                      child: Column(
                        children: [
                          Image.asset('assets/images/market_summary.png',
                              width: 16, height: 16),
                          Text('总结描述',
                              style: const TextStyle(
                                  color: AppColors.FFC08A3F, fontSize: 12.0))
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    widget.model.time = '2012-05-29 16:31:50';
    widget.model.setTarget('儿童');
    widget.model.setTargetCount('100');
    if (mounted) setState(() {});
  }
}
