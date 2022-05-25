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
    @required this.netAmount,
    @required this.discount,
    @required this.standardCount,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(15.0),
  }) : super(key: key);

  ///实际数量
  final int totalCount;
  ///搭赠数量
  final int giftCount;
  ///商品总数
  final int count;
  ///商品总重
  final double countWeight;
  ///商品总额
  final double countPrice;
  ///商品净额
  final double netAmount;
  ///折扣合计
  final double discount;
  ///标准件数
  final double standardCount;
  ///背景颜色
  final Color color;
  ///间距
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
                Visibility(visible: giftCount != null, child: Text('搭赠数量')),
                Visibility(visible: giftCount != null, child: SizedBox(height: 8)),
                Text('商品总数'),
                SizedBox(height: 8),
                Text('商品总重'),
                SizedBox(height: 8),
                Text('商品总额'),
                Visibility(visible: netAmount != null, child: SizedBox(height: 8)),
                Visibility(visible: netAmount != null, child: Text('商品净额')),
                Visibility(visible: discount != null, child: SizedBox(height: 8)),
                Visibility(visible: discount != null, child: Text('折扣合计')),
                Visibility(visible: standardCount != null, child: SizedBox(height: 8)),
                Visibility(visible: standardCount != null, child: Text('标准件数')),
              ]
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Visibility(visible: totalCount != null, child: Text(totalCount.toString())),
                Visibility(visible: totalCount != null, child: SizedBox(height: 8)),
                Visibility(visible: giftCount != null, child: Text(giftCount.toString())),
                Visibility(visible: giftCount != null, child: SizedBox(height: 8)),
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
                Visibility(visible: netAmount != null, child: SizedBox(height: 8)),
                Visibility(visible: netAmount != null, child: Text.rich(TextSpan(
                    text: '¥',
                    style: const TextStyle(
                        color: AppColors.FFE45C26, fontSize: 12.0),
                    children: [
                      TextSpan(
                        text: netAmount == null ? '' : netAmount.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 18.0),
                      )
                    ]))),
                Visibility(visible: discount != null, child: SizedBox(height: 8)),
                Visibility(visible: discount != null, child: Text.rich(TextSpan(
                    text: '¥',
                    style: const TextStyle(
                        color: AppColors.FFE45C26, fontSize: 12.0),
                    children: [
                      TextSpan(
                        text: discount == null ? '' :  discount.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 18.0),
                      )
                    ]))),
                Visibility(visible: standardCount != null, child: SizedBox(height: 8)),
                Visibility(visible: standardCount != null, child: Text(standardCount.toString())),
              ]
            )
          ]
        )
      )
    );
  }
}
