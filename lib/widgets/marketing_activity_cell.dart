import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/marketing_activity_model.dart';
import 'package:good_grandma/pages/marketing_activity/marketing_activity_detail_page.dart';

///市场活动列表cell
class MarketingActivityCell extends StatelessWidget {
  const MarketingActivityCell({
    Key key,
    @required this.model
  }) : super(key: key);

  final MarketingActivityModel model;

  @override
  Widget build(BuildContext context) {
    Color stateColor = AppColors.FFE45C26;
    String statusName = '';
    switch(model.statusId){
      case 1:
        statusName = '未进行';
        stateColor = AppColors.FFE45C26;
        break;
      case 2:
        statusName = '进行中';
        stateColor = AppColors.FF05A8C6;
        break;
      case 3:
        statusName = '已完结';
        stateColor = AppColors.FF959EB1;
        break;
      case 4:
        statusName = '驳回';
        stateColor = AppColors.FFC68D3E;
        break;
    }

    List<Widget> views1 = [];
    List<String> titles = ['活动时间：', '上级通路客户：', '申请资源费用合计(元)：', '预计进货额(元)：', '预计进货投入产出比(%)：'];
    List<String> values = [
      model.startTime + ' - ' + model.endTime,
      model.customerName,
      model.costTotal,
      model.purchaseMoney,
      model.purchaseRatio
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
          MaterialPageRoute(
              builder: (_) => MarketingActivityDetailPage(
                  model: model, state: statusName, stateColor: stateColor))),
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
                    model.name,
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
                        statusName,
                        style: TextStyle(color: stateColor, fontSize: 11.0),
                      )
                    )
                  )
                ]
              )
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
