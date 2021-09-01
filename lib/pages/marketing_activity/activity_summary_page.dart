import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/models/marketing_activity_model.dart';
import 'package:good_grandma/pages/marketing_activity/edit_activity_summary_page.dart';
import 'package:good_grandma/widgets/marketing_activity_detail_title.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';

///总结描述
class ActivitySummaryPage extends StatefulWidget {
  const ActivitySummaryPage(
      {Key key,
        @required this.model,
        @required this.state,
        @required this.stateColor})
      : super(key: key);
  final MarketingActivityModel model;
  final String state;
  final Color stateColor;

  @override
  _ActivitySummaryPageState createState() => _ActivitySummaryPageState();
}

class _ActivitySummaryPageState extends State<ActivitySummaryPage> {
  String _remark = '';
  List<String> _images = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> views = [];
    _images.forEach((image) {
      views.add(ClipRRect(
        borderRadius: BorderRadius.circular(4),
          child: MyCacheImageView(imageURL: image, width: 75, height: 56)));
    });
    return Scaffold(
        appBar: AppBar(
          title: const Text('总结描述'),
          actions: [
            TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => EditActivitySummaryPage(
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
                PostDetailGroupTitle(color: AppColors.FFC08A3F, name: '总结描述'),
                SliverPadding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      color: Colors.white,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: const Text('图         片',
                                style: TextStyle(
                                    color: AppColors.FF959EB1, fontSize: 14.0)),
                          ),
                          Wrap(
                            spacing:10,
                            runSpacing: 10,
                            children: views,
                          ),
                        ],
                      ),
                    ),
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
                ),
              ],
            )));
  }

  void _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _remark = '备注信息备注信息备注信息备注信息备注信息备注备注信息备注信息备注信息备注信息备注信息';
    _images.clear();
    _images.addAll([
      'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
      'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
      'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
      'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
      'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
      'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
    ]);
    if (mounted) setState(() {});
  }
}
