import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/marketing_activity_model.dart';
import 'package:good_grandma/pages/marketing_activity/edit_activity_profit_page.dart';
import 'package:good_grandma/widgets/marketing_activity_detail_title.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';

///活动收益
class ActivityProfitPage extends StatefulWidget {
  const ActivityProfitPage(
      {Key key,
      @required this.model,
      @required this.state,
      @required this.stateColor})
      : super(key: key);
  final MarketingActivityModel model;
  final String state;
  final Color stateColor;

  @override
  _ActivityProfitPageState createState() => _ActivityProfitPageState();
}

class _ActivityProfitPageState extends State<ActivityProfitPage> {
  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('活动收益'),
          actions: [
            TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => EditActivityProfitPage(
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
            PostDetailGroupTitle(color: AppColors.FFC08A3F, name: '活动收益'),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              sliver: SliverToBoxAdapter(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 15.0),
                    child: Text.rich(TextSpan(
                        text: '活动收益  ',
                        style: const TextStyle(
                            color: AppColors.FF959EB1, fontSize: 14.0),
                        children: [
                          TextSpan(
                            text: '￥' + widget.model.purchaseMoney,
                            style: const TextStyle(
                                color: AppColors.FFE45C26, fontSize: 18.0),
                          ),
                          TextSpan(
                            text: ' 元',
                            style: const TextStyle(
                                color: AppColors.FF2F4058, fontSize: 14.0),
                          ),
                        ])),
                  ),
                ),
              ),
            ),
          ],
        )));
  }

  void _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    if (mounted) setState(() {});
  }
}
