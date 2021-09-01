import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/common/my_progress_view.dart';
import 'package:good_grandma/models/marketing_activity_model.dart';
import 'package:good_grandma/pages/marketing_activity/marketing_activity_detail_page.dart';

///市场活动列表cell
class MarketingActivityCell extends StatelessWidget {
  const MarketingActivityCell({
    Key key,
    @required this.model,
    @required this.state,
  }) : super(key: key);

  final MarketingActivityModel model;
  final String state;

  @override
  Widget build(BuildContext context) {
    Color stateColor = AppColors.FFE45C26;
    if (state == '进行中')
      stateColor = AppColors.FF05A8C6;
    else if (state == '已完结') stateColor = AppColors.FF959EB1;

    List<Widget> views1 = [];
    List<String> titles = ['活动类型：', '活动时间：', '负 责 人：', '主 办 方：'];
    List<String> values = [
      model.type,
      model.startTime + '-' + model.endTime,
      model.leading,
      model.sponsor
    ];
    int i = 0;
    titles.forEach((title) {
      views1.add(Text.rich(TextSpan(
          text: title,
          style: const TextStyle(color: AppColors.FF959EB1, fontSize: 12.0),
          children: [
            TextSpan(
                text: values[i],
                style: const TextStyle(color: AppColors.FF2F4058))
          ])));
      i++;
    });

    double ratio = 0;
    final double budgetCountD = double.parse(model.budgetCount);
    final double budgetCurrentD = double.parse(model.budgetCurrent);
    if (budgetCountD > 0 && budgetCurrentD > 0)
      ratio = budgetCurrentD / budgetCountD;

    List<Widget> views2 = [];
    model.goodsList.forEach((goodsModel) {
      String image = goodsModel.image;
      String name = goodsModel.name;
      String count = goodsModel.count.toString();
      views2.add(Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(2.5),
                child:
                    MyCacheImageView(imageURL: image, width: 60, height: 55)),
            Expanded(
                child:
                    Text('  ' + name, style: const TextStyle(fontSize: 14.0))),
            Text('数量：' + count, style: const TextStyle(fontSize: 14.0)),
          ],
        ),
      ));
    });

    return ListTile(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MarketingActivityDetailPage(
                  model: model, state: state, stateColor: stateColor))),
      title: Card(
        child: Column(
          children: [
            //活动名称
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    model.title,
                    style: const TextStyle(
                        color: AppColors.FF142339, fontSize: 14.0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
                  Card(
                    color: stateColor.withOpacity(0.1),
                    shadowColor: stateColor.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.5, vertical: 5),
                      child: Text(
                        state,
                        style: TextStyle(color: stateColor, fontSize: 11.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //类型信息
            Container(
              width: double.infinity,
              color: AppColors.FFEFEFF4,
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: views1,
              ),
            ),
            //预算
            Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: Row(
                children: [
                  const Text(
                    '活动预算',
                    style: TextStyle(color: AppColors.FF959EB1, fontSize: 12.0),
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                          text: '￥' + model.budgetCurrent,
                          style: const TextStyle(
                              color: AppColors.FFE45C26, fontSize: 12.0),
                          children: [
                            TextSpan(
                              text: ' / ￥' + model.budgetCount,
                              style: const TextStyle(
                                  color: AppColors.FFC1C8D7, fontSize: 12.0),
                            )
                          ]),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 10.0, right: 10.0),
              child: MyProgressView(
                  ratio: ratio,
                  height: 6.0,
                  borderRadius: 3,
                  backgroundColor: AppColors.FFE45C26.withOpacity(0.1),
                  valueColor: AppColors.FFE45C26),
            ),
            //商品列表
            Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: Row(
                children: [
                  const Text(
                    '活动商品',
                    style: TextStyle(color: AppColors.FF959EB1, fontSize: 12.0),
                  ),
                  Spacer()
                ],
              ),
            ),
            Column(children: views2)
          ],
        ),
      ),
    );
  }
}
