import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///显示商品总数、商品总重、商品总额的视图
class OrderGoodsCountView extends StatelessWidget {
  const OrderGoodsCountView({
    Key key,
    @required this.totalCount,
    @required this.giftCount,
    @required this.count,
    @required this.countWeight,
    @required this.countPrice,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(15.0),
  }) : super(key: key);

  final int totalCount;
  final int giftCount;
  final int count;
  final double countWeight;
  final double countPrice;
  final Color color;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: padding,
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 14.0, color: AppColors.FF2F4058),
        child: Row(
          children: [
            Column(
              children: [
                Visibility(visible: totalCount != null, child: Text('实际数量')),
                Visibility(visible: totalCount != null, child: SizedBox(height: 8)),
                Visibility(visible: totalCount != null, child: Text('搭赠数量')),
                Visibility(visible: totalCount != null, child: SizedBox(height: 8)),
                Text('商品总数'),
                SizedBox(height: 8),
                Text('商品总重'),
                SizedBox(height: 8),
                Text('商品总额'),
              ]
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Visibility(visible: totalCount != null, child: Text(totalCount.toString())),
                Visibility(visible: totalCount != null, child: SizedBox(height: 8)),
                Visibility(visible: totalCount != null, child: Text(giftCount.toString())),
                Visibility(visible: totalCount != null, child: SizedBox(height: 8)),
                Text(count.toString()),
                SizedBox(height: 8),
                Text(countWeight.toStringAsFixed(2) + 'kg'),
                SizedBox(height: 8),
                Text.rich(TextSpan(
                    text: '¥',
                    style: const TextStyle(
                        color: AppColors.FFE45C26, fontSize: 12.0),
                    children: [
                      TextSpan(
                        text: countPrice.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 18.0),
                      )
                    ])),
              ]
            )
          ]
        )
      )
    );
  }
}
