import 'package:flutter/material.dart';
import 'package:good_grandma/widgets/post_progress_view.dart';
import 'package:good_grandma/common/colors.dart';

///店铺销量cell
class SalesStatisticsDetailShopCell extends StatelessWidget {
  const SalesStatisticsDetailShopCell({
    Key key,
    @required this.title,
    @required this.count,
    @required this.price,
  }) : super(key: key);

  final String title;
  final String count;
  final String price;

  @override
  Widget build(BuildContext context) {
    double salesCountD = double.parse(count);
    double salesPriceD = double.parse(price);
    double target = salesPriceD;
    if (salesCountD > salesPriceD) {
      target = salesCountD;
    }
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Text(title, style: const TextStyle(fontSize: 14.0)),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PostProgressView(
                    count: target,
                    current: salesCountD,
                    color: AppColors.FF05A8C6,
                    title: '销量   ',
                    horizontal: 0.0,
                    titleColor: AppColors.FF959EB1,
                    textColor: AppColors.FF05A8C6),
                PostProgressView(
                    count: target,
                    current: salesPriceD,
                    color: AppColors.FFE45C26,
                    title: '销售额',
                    horizontal: 0.0,
                    titleColor: AppColors.FF959EB1,
                    textColor: AppColors.FFE45C26),
              ],
            ),
          ),
          const Divider(height: 1, indent: 10.0, endIndent: 10.0)
        ],
      ),
    );
  }
}