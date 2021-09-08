import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///订货明细cell
class SalesStatisticsDetailOrderCell extends StatelessWidget {
  const SalesStatisticsDetailOrderCell({
    Key key,
    @required this.title,
    @required this.time,
    @required this.count,
    @required this.price,
  }) : super(key: key);

  final String title;
  final String time;
  final String count;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: DefaultTextStyle(
              style: const TextStyle(color: AppColors.FF959EB1,fontSize: 12.0),
              child: Row(
                children: [
                  Expanded(child: Text(title,style: const TextStyle(color: AppColors.FF2F4058))),
                  Text(time),
                ],
              ),
            ),
            subtitle: DefaultTextStyle(
              style: const TextStyle(color: AppColors.FF959EB1,fontSize: 12.0),
              child: Row(
                children: [
                  Expanded(child: Text('订货数量：$count箱')),
                  Text('订单金额：￥$price'),
                ],
              ),
            ),
          ),
          const Divider(height: 1,indent: 10.0,endIndent: 10.0)
        ],
      ),
    );
  }
}