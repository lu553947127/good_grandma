import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/widgets/post_progress_view.dart';

///商品销量统计cell
class SalesStatisticsCell extends StatelessWidget {
  const SalesStatisticsCell({
    Key key,
    @required this.title,
    @required this.salesCount,
    @required this.salesPrice,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String salesCount;
  final String salesPrice;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    double salesCountD = double.parse(salesCount);
    double salesPriceD = double.parse(salesPrice);
    double target = salesPriceD;
    if (salesCountD > salesPriceD) {
      target = salesCountD;
    }
    return ListTile(
      onTap: onTap,
      title: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Text(title),
            ),
            const Divider(),
            PostProgressView(
                count: target,
                current: salesCountD,
                color: AppColors.FF05A8C6,
                title: '订单量',
                titleColor: AppColors.FF959EB1,
                textColor: AppColors.FF05A8C6),
            PostProgressView(
                count: target,
                current: salesPriceD,
                color: AppColors.FFE45C26,
                title: '销售额',
                titleColor: AppColors.FF959EB1,
                textColor: AppColors.FFE45C26),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
