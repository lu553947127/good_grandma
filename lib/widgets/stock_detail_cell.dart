import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/stock_detail_mdoel.dart';
import 'package:provider/provider.dart';

class StockDetailCell extends StatelessWidget {
  const StockDetailCell({Key key, @required this.map}) : super(key: key);
  final Map map;

  @override
  Widget build(BuildContext context) {
    String time = map['reportTime'];
    List<String> dates = time.split('-');
    if(dates.length == 3)
      time = dates[1] + '-' + dates.last;
    List list1 = map['appCustomerCheckGoods'];
    return Column(
      children: [
        ...List.generate(list1.length, (index) {
          Map goodsMap = list1[index] as Map;
          StockDetailModel model = StockDetailModel.fromJson(goodsMap);
          return ChangeNotifierProvider<StockDetailModel>.value(
            value: model,
            child: _TitleWidget(
              time: index == 0 ? time : '',
              isLast: index == list1.length - 1,
            ),
          );
        }),
        const Divider(height: 1, indent: 15.0, endIndent: 15.0),
      ],
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({
    Key key,
    this.time = '',
    this.isLast = false,
  }) : super(key: key);
  final String time;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final StockDetailModel model = Provider.of<StockDetailModel>(context);
    final double width = 40.0;
    final double width1 =  width + 15.0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      width: double.infinity,
      child: DefaultTextStyle(
        style: const TextStyle(color: AppColors.FF2F4058,fontSize: 14.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(width: width, child: Text(time)),
                SizedBox(width: 10.0),
                Expanded(child: Text(model.name)),
                _RedCountText(title: '总计(箱)：' ,value: model.count),
                IconButton(
                    onPressed: () => model.setOpened(!model.opened),
                    icon: Icon(model.opened
                        ? Icons.keyboard_arrow_up_outlined
                        : Icons.keyboard_arrow_down_outlined)),
              ],
            ),
            Visibility(
              visible: model.opened,
              child: Column(
                children: List.generate(model.goodsList.length, (index) => Padding(
                  padding: EdgeInsets.only(left: width1,right: 0.0,bottom: 13.0),
                  child: _StockCell(model: model.goodsList[index],),
                )),
              ),
            ),
            Visibility(visible: !isLast, child: Divider(height: 1,indent:width1)),
          ],
        ),
      ),
    );
  }
}

class _StockCell extends StatelessWidget {
  const _StockCell({Key key,@required this.model}) : super(key: key);
  final StackGoodsListModel model;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
    style: const TextStyle(color: AppColors.FF959EB1,fontSize: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 1,child: Text(_transforTime(model.typeName),style: const TextStyle(color: AppColors.FFC68D3E))),
          Expanded(flex: 2,child: _RedCountText(title: '数量(箱)：' ,value: _number(model.typeName)))
        ],
      ),
    );
  }
  String _transforTime(String time){
    String str = '';
    switch(time){
      case 'oneToThree':
        str = '≤6个月';
        break;
      case 'fourToSix':
        str = '>6个月';
        break;
    }
    return str;
  }

  String _number(String time){
    String str = '';
    switch(time){
      case 'oneToThree':
        str = model.oneToThree;
        break;
      case 'fourToSix':
        str = model.fourToSix;
        break;
    }
    return str;
  }
}

class _RedCountText extends StatelessWidget {
  const _RedCountText({
    Key key,
    @required this.title,
    this.titleColor,
    @required this.value,
  }) : super(key: key);

  final String title;
  final Color titleColor;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(
        text: title,
        style: TextStyle(color: titleColor),
        children: [
          TextSpan(
              text: value.isEmpty?'0':value,
              style: const TextStyle(color: AppColors.FFE45C26)
          )
        ]
    ));
  }
}
