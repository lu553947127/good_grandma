import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/widgets/home_report_cell.dart';

///总结列表
class HomeReportCellList extends StatelessWidget {
  final List<String> list;
  final String title;
  final int type;
  HomeReportCellList({Key key, @required this.list, @required this.title, this.type = 0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (list == null || list.isEmpty) {
      return Container();
    }
    final titleWidget = Text(title ?? '',
        style:
        const TextStyle(color: AppColors.FF959EB1, fontSize: 12.0));
    final Map map = HomeReportCell.transInfoFromPostType(type);
    final Color color = map['color'];
    final String name = map['name'];
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: type ==0
                ?titleWidget
                :Row(
              children: [
                Expanded(child: titleWidget),
                Container(
                  width: 37,
                  height: 20,
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2.5),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(2, 1),
                          color: color.withOpacity(0.4),
                          blurRadius: 1.5,
                        ),
                      ]),
                  child: Center(
                      child: Text('$name报',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 11.0))),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: AppColors.FFF4F5F8,
                borderRadius: BorderRadius.circular(4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(list.length, (index) {
                String title1 = list[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(TextSpan(
                      text: '${index + 1}.',
                      style: const TextStyle(
                          color: AppColors.FF959EB1, fontSize: 12.0),
                      children: [
                        TextSpan(
                            text: title1 ?? '',
                            style: const TextStyle(color: AppColors.FF2F4058))
                      ],
                    )),
                    Visibility(
                        visible: index < list.length - 1,
                        child: const Divider(
                            color: Color(0xFFE3E3E7), thickness: 1))
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}