import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/widgets/marketing_activity_msg_cell.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';

///行销规划详情
class MarketingPlanDetailPage extends StatefulWidget {
  const MarketingPlanDetailPage(
      {Key key,
        @required this.model})
      : super(key: key);
  final dynamic model;

  @override
  _MarketingPlanDetailPageState createState() =>
      _MarketingPlanDetailPageState();
}

class _MarketingPlanDetailPageState extends State<MarketingPlanDetailPage> {

  @override
  Widget build(BuildContext context) {
    List<Map> _list1 = [
      {'title': '地区', 'value': '${widget.model['regionName']} - ${widget.model['provinceName']} - ${widget.model['cityName']}'},
      {'title': '城市类型', 'value': widget.model['cityType'].toString()},
      {'title': '2022销量目标', 'value': widget.model['sellTarget']},
      {'title': '城市一铺货渠道网点总数', 'value': widget.model['channelTotal'].toString()}
    ];

    List<Map> _list2 = [
      {'title': '渠道类型', 'value': widget.model['channelType'].toString()},
      {'title': '活动类型', 'value': widget.model['activityType'].toString()},
      {'title': '活动时间', 'value': widget.model['createTime']},
      {'title': '规划参与活动网店数量', 'value': widget.model['planJoinBranch'].toString()},
      {'title': '涉及经销商数量', 'value': widget.model['involveDealerNum'].toString()},
      {'title': '预计销量', 'value': widget.model['planSell'].toString()},
      {'title': '规划月算消耗', 'value': widget.model['planConsume'].toString()},
      {'title': '活动政策描述', 'value': widget.model['activityContent']}
    ];

    return Scaffold(
        appBar: AppBar(title: const Text('行销规划详情')),
        body: Scrollbar(
            child: CustomScrollView(
                slivers: [
                  PostDetailGroupTitle(color: AppColors.FFC08A3F, name: '基础信息'),
                  SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          Map map = _list1[index];
                          String title = map['title'];
                          String value = map['value'];
                          return MarketingActivityMsgCell(title: title, value: value);
                        }, childCount: _list1.length),
                      )
                  ),
                  PostDetailGroupTitle(color: AppColors.FFC08A3F, name: '渠道消费者促销规划表'),
                  SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          Map map = _list2[index];
                          String title = map['title'];
                          String value = map['value'];
                          return MarketingActivityMsgCell(title: title, value: value);
                        }, childCount: _list2.length),
                      )
                  ),
                  PostDetailGroupTitle(color: AppColors.FFC08A3F, name: '备注'),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: MarketingActivityMsgCell(title: '备注', value: widget.model['remark']),
                    )
                  ),
                  SliverSafeArea(sliver: SliverToBoxAdapter()),
                ]
            )
        )
    );
  }
}
