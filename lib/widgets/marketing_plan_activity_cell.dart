import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/pages/marketing_activity/marketing_plan_detail.dart';

///行销规划列表cell
class MarketingPlanActivityCell extends StatelessWidget {
  const MarketingPlanActivityCell({
    Key key,
    @required this.model
  }) : super(key: key);

  final dynamic model;

  @override
  Widget build(BuildContext context) {

    List<Widget> views1 = [];
    List<String> titles = ['渠道类型：', '活动类型：', '活动时间：', '规划参与活动网点数量：', '涉及经销商数量：'];
    List<String> values = [
      model['channelType'].toString(),
      model['activityType'].toString(),
      model['createTime'],
      model['planJoinBranch'].toString(),
      model['involveDealerNum'].toString()
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

    return ListTile(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MarketingPlanDetailPage(model: model))),
        title: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //活动名称
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Expanded(
                          child: Text(
                            '大区: ${model['regionName']} - ${model['provinceName']} - ${model['cityName']}',
                            style: const TextStyle(
                                color: AppColors.FF142339, fontSize: 14.0),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ))
                  ),
                  //类型信息
                  Container(
                      width: double.infinity,
                      color: AppColors.FFF9F9FB,
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: views1,
                      )
                  )
                ]
            )
        )
    );
  }
}
