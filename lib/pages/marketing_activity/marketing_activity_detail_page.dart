import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/marketing_activity_model.dart';
import 'package:good_grandma/pages/marketing_activity/add_marketing_activity_page.dart';
import 'package:good_grandma/widgets/marketing_activity_detail_title.dart';
import 'package:good_grandma/widgets/marketing_activity_msg_cell.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

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

class _MarketingActivityDetailPageState extends State<MarketingActivityDetailPage> {

  @override
  Widget build(BuildContext context) {
    List<Map> _list1 = [
      {'title': '开始时间', 'value': widget.model.startTime},
      {'title': '结束时间', 'value': widget.model.endTime},
      {'title': '上级通路客户', 'value': widget.model.customerName},
      {'title': '活动简述', 'value': widget.model.sketch}
    ];

    List<Map> _list2 = [
      {'title': '申请资源费用合计(元)', 'value': widget.model.costTotal},
      {'title': '预计进货额(元)', 'value': widget.model.purchaseMoney},
      {'title': '预计进货投入产出比(%)', 'value': widget.model.purchaseRatio.toString() + '%'}
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
              )
            ),
            PostDetailGroupTitle(color: AppColors.FFC08A3F, name: '试吃品'),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                    margin: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          MarketingActivityMsgCell(title: '物料名称', value: widget.model.activityCosts[index]['materialName']),
                          MarketingActivityMsgCell(title: '试吃品(箱)/数量', value: widget.model.activityCosts[index]['sample'].toString() + '箱'),
                          MarketingActivityMsgCell(title: '费用描述', value: widget.model.activityCosts[index]['costDescribe']),
                          MarketingActivityMsgCell(title: '现金', value: widget.model.activityCosts[index]['costCash'].toString())
                        ]
                    )
                );
              }, childCount: widget.model.activityCosts.length),
            ),
            //费用信息
            PostDetailGroupTitle(color: AppColors.FFC08A3F, name: '费用信息'),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  margin: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, bottom: 5.0),
                        child: Text(widget.model.activityCostList[index]['costTypeName'],
                            style: const TextStyle(fontSize: 14.0)),
                      ),
                      SizedBox(height: 5),
                      MarketingActivityMsgCell(title: '现金', value: widget.model.activityCostList[index]['costCash']),
                      MarketingActivityMsgCell(title: '费用描述', value: widget.model.activityCostList[index]['costDescribe'])
                    ]
                  )
                );
              }, childCount: widget.model.activityCostList.length),
            ),
            //活动商品
            PostDetailGroupTitle(color: AppColors.FFC08A3F, name: '合计'),
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
            SliverSafeArea(
                sliver: SliverToBoxAdapter(
                    child: Visibility(
                        visible: widget.state == '驳回' ? true : false,
                        child: SubmitBtn(
                            vertical: 5.0,
                            title: '编辑',
                            onPressed: () async {
                              MarketingActivityModel model = MarketingActivityModel(id: 'id');
                              bool needRefresh = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                      ChangeNotifierProvider<MarketingActivityModel>.value(
                                        value: model,
                                        child: AddMarketingActivityPage(id: widget.model.id),
                                      )));
                              if(needRefresh != null && needRefresh){
                                Navigator.pop(context, true);
                              }
                            }
                        )
                    )
                )
            )
          ]
        )
      )
    );
  }
}
