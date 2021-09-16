import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///报修cell
class GuaranteeCell extends StatelessWidget {
  GuaranteeCell({
    Key key,
    @required this.values,
    @required this.stateName,
    @required this.stateColor,
  }) : super(key: key);

  final List<String> values;
  final String stateName;
  final Color stateColor;
  final List<String> _titles = [
    '报修单号',
    '品牌型号',
    '店铺名称',
    '店主姓名',
    '店铺电话',
    '所在位置',
    '报修时间'
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> views = [];
    int i = 0;
    _titles.forEach((title) {
      Widget titleView = Padding(
        padding: EdgeInsets.only(bottom: (i < _titles.length - 1) ? 14.0 : 0),
        child: Text.rich(TextSpan(
            text: title + '  ',
            style: const TextStyle(color: AppColors.FF959EB1, fontSize: 14.0),
            children: [
              TextSpan(
                text: values[i],
                style:
                    const TextStyle(color: AppColors.FF2F4058, fontSize: 14.0),
              )
            ])),
      );
      if (i == 0) {
        views.add(Row(
          children: [
            Expanded(child: titleView),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4.5),
              decoration: BoxDecoration(
                  color: stateColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2.5),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(2, 1),
                      color: stateColor.withOpacity(0.1),
                      blurRadius: 1.5,
                    ),
                  ]),
              child: Center(
                  child: Text(stateName,
                      style: TextStyle(color: stateColor, fontSize: 11.0))),
            )
          ],
        ));
      } else {
        views.add(titleView);
      }
      i++;
    });
    return Card(
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.03),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: views,
        ),
      ),
    );
  }
}
