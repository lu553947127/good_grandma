import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/models/declaration_form_model.dart';
import 'package:good_grandma/models/goods_model.dart';

class MyDeclarationFormCell extends StatelessWidget {
  const MyDeclarationFormCell({
    Key key,
    @required this.model,
    @required this.onTap,
    this.orderType = 1,
  }) : super(key: key);
  final DeclarationFormModel model;
  final VoidCallback onTap;

  ///是否是一级订单，一级订单和二级订单显示的不太一样
  final int orderType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
      child: Card(
        child: ListTile(
          onTap: onTap,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(model.storeModel.name ?? '',
                          style: TextStyle(
                              color: model.showGray()
                                  ? Colors.black
                                  : AppColors.FFE45C26,
                              fontSize: 14.0))),
                  Card(
                    color: model.statusColor.withOpacity(0.1),
                    shadowColor: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4.5),
                      child: Text(
                        model.statusName,
                        style: TextStyle(
                            color: model.statusColor,
                            fontSize: 14.0),
                      ),
                    ),
                  ),
                ],
              ),
              Text(model.time ?? '',
                  style: const TextStyle(
                      color: AppColors.FF959EB1, fontSize: 14.0)),
              const Divider(),
              ...model.goodsList.map(
                  (goodsModel) => DeclarationGoodsCell(goodsModel: goodsModel)),
              Align(
                alignment: Alignment.bottomRight,
                child: Text.rich(TextSpan(
                    text: '总额：',
                    style: const TextStyle(color: Colors.black, fontSize: 14.0),
                    children: [
                      TextSpan(
                        text: '¥ ',
                        style: TextStyle(
                            color:
                            orderType == 1 ? AppColors.FFE45C26 : Colors.black),
                      ),
                      TextSpan(
                        text: model.goodsPrice.toStringAsFixed(2),
                        style: TextStyle(
                            color:
                            orderType == 1 ? AppColors.FFE45C26 : Colors.black,
                            fontSize: 16.0),
                      ),
                    ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeclarationGoodsCell extends StatelessWidget {
  const DeclarationGoodsCell({
    Key key,
    @required this.goodsModel,
  }) : super(key: key);
  final GoodsModel goodsModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      width: double.infinity,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 9),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: MyCacheImageView(
                    imageURL: goodsModel.image, width: 74, height: 50)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(goodsModel.name,
                  style: const TextStyle(
                      color: AppColors.FF2F4058, fontSize: 14.0)),
              Visibility(
                visible: goodsModel.specs.isNotEmpty,
                child: Text('规格：' + goodsModel.specs.first.spec,
                    style: const TextStyle(
                        color: AppColors.FF959EB1, fontSize: 14.0)),
              )
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('¥' + goodsModel.invoice.toStringAsFixed(2),
                  style: const TextStyle(
                      color: AppColors.FF959EB1, fontSize: 14.0)),
              Text('x' + goodsModel.count.toStringAsFixed(0),
                  style: const TextStyle(
                      color: AppColors.FF959EB1, fontSize: 14.0)),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderNewListItem extends StatelessWidget {
  const OrderNewListItem({Key key,
    @required this.model,
    @required this.onTap,
  }) : super(key: key);
  final DeclarationFormModel model;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                offset: Offset(2, 1),
                blurRadius: 1.5,
              )
            ]
        ),
        child: ListTile(
          title: Column(
              mainAxisSize:MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: 220,
                                child: Text('订单号:${model.id}', style: TextStyle(fontSize: 14, color: model.statusColor))
                            ),
                            SizedBox(height: 10),
                            Text(model.time, style: TextStyle(fontSize: 12, color: Color(0XFF959EB1)))
                          ]
                      )),
                      Card(
                        color: model.statusColor.withOpacity(0.1),
                        shadowColor: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4.5),
                          child: Text(
                            model.statusName,
                            style: TextStyle(
                                color: model.statusColor,
                                fontSize: 14.0)
                          )
                        )
                      )
                    ]
                ),
                SizedBox(height: 10),
                //分割线
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Color(0xFFEFEFF4)),
                    )
                ),
                SizedBox(height: 5),
                Container(
                    margin: EdgeInsets.only(top: 2),
                    child: Row(
                        children: [
                          Text('客户名称: ', style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                          SizedBox(width: 10),
                          Text(model.storeModel.name, style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                        ]
                    )
                ),
                Container(
                    margin: EdgeInsets.only(top: 2),
                    child: Row(
                        children: [
                          Text('订单总额: ', style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                          SizedBox(width: 10),
                          Text('${model.goodsPrice}', style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                        ]
                    )
                ),
                // Container(
                //     margin: EdgeInsets.only(top: 2),
                //     child: Row(
                //         children: [
                //           Text('订单净额: ', style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                //           SizedBox(width: 10),
                //           Text('${model.goodsPrice}', style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                //         ]
                //     )
                // ),
                Container(
                    margin: EdgeInsets.only(top: 2),
                    child: Row(
                        children: [
                          Text('商品件数: ', style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                          SizedBox(width: 10),
                          Text('${model.goodsCount}', style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                        ]
                    )
                )
              ]
          ),
          onTap: onTap,
        )
    );
  }
}

