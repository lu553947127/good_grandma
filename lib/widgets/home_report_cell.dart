import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/models/home_report_model.dart';

class HomeReportCell extends StatelessWidget {
  final HomeReportModel model;
  HomeReportCell({Key key, @required this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  offset: Offset(2, 1), //x,y轴
                  color: Colors.black.withOpacity(0.1), //投影颜色
                  blurRadius: 1 //投影距离
                  ),
            ]),
        child: Column(
          children: [
            //头像 名称 日期 类别
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Row(
                children: [
                  ClipOval(
                    child: MyCacheImageView(
                      imageURL: model.avatar,
                      width: 30.0,
                      height: 30.0,
                      errorWidgetChild:
                          Icon(Icons.supervised_user_circle, size: 30.0),
                    ),
                  ),
                  Text('  ' + (model.userName ?? '') + '  ',
                      style: const TextStyle(fontSize: 14.0)),
                  Expanded(
                      child: Text(model.time ?? '',
                          style: const TextStyle(
                              color: AppColors.FF959EB1, fontSize: 12.0))),
                  Container(
                    width: 37,
                    height: 20,
                    decoration: BoxDecoration(
                        color: model.isWeekType
                            ? AppColors.FFC08A3F
                            : AppColors.FFE45C26,
                        borderRadius: BorderRadius.circular(2.5),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(2, 1),
                            color: model.isWeekType
                                ? AppColors.FFC08A3F.withOpacity(0.4)
                                : AppColors.FFE45C26.withOpacity(0.4),
                            blurRadius: 1.5,
                          ),
                        ]),
                    child: Center(
                        child: Text(model.isWeekType ? '周报' : '月报',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11.0))),
                  ),
                ],
              ),
            ),
            const Divider(
              color: AppColors.FFF4F5F8,
              thickness: 1,
              height: 1.0,
            ),
            //本周目标
            _ProgressView(
                count: model.target,
                current: model.target,
                color: AppColors.FFE6CFAE,
                title: model.isWeekType ? '本周目标' : '本月目标'),
            //本周累计
            _ProgressView(
                count: model.target,
                current: model.cumulative,
                color: AppColors.FFD9B887,
                title: model.isWeekType ? '本周累计' : '本月累计'),
            //本周实际
            _ProgressView(
                count: model.target,
                current: model.actual,
                color: AppColors.FFC08A3F,
                title: model.isWeekType ? '本周实际' : '本月实际'),
            const Divider(
                color: AppColors.FFEFEFF4,
                thickness: 1,
                indent: 10.0,
                endIndent: 10.0),
            _CellList(
                list: model.summary ?? [],
                title: model.isWeekType ? '本周区域重点工作总结' : '本月区域重点工作总结'),
            _CellList(
                list: model.plans ?? [],
                title: model.isWeekType ? '下周工作计划' : '下月工作计划'),
          ],
        ),
      ),
    );
  }
}

///进度
class _ProgressView extends StatelessWidget {
  final double count;
  final double current;
  final String title;
  final Color color;
  _ProgressView(
      {Key key,
      @required this.count,
      @required this.current,
        @required this.color,
      @required this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double r = current / count;
    if(r > 1)
      r = 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: Row(
        children: [
          Text((title ?? '') + '  ', style: const TextStyle(fontSize: 12.0)),
          Stack(
            children: [
              Container(
                height: 6,
                width: 200),
              Container(
                height: 6,
                width: 200 * r,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(2, 1),
                      color: color.withOpacity(0.3),
                      blurRadius: 1.5
                    )
                  ]
                ),
              ),
            ],
          ),
          Text('  ¥${_numTranfer(current)}',
              style:
                  const TextStyle(color: AppColors.FFC08A3F, fontSize: 10.0)),
        ],
      ),
    );
  }

  String _numTranfer(double num) {
    if (num ~/ 100000000 > 0)
      return (num / 100000000).toStringAsFixed(2) + '亿';
    else if (num ~/ 10000000 > 0)
      return (num / 10000000).toStringAsFixed(2) + '千万';
    else if (num ~/ 1000000 > 0)
      return (num / 1000000).toStringAsFixed(2) + '百万';
    else if (num ~/ 10000 > 0)
      return (num / 10000).toStringAsFixed(2) + '万';
    else
      return num.toStringAsFixed(2);
  }
}

///总结列表
class _CellList extends StatelessWidget {
  final List<String> list;
  final String title;
  _CellList({Key key, @required this.list, @required this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (list == null || list.isEmpty) {
      return Container();
    }
    List<Widget> _views = [];
    int i = 1;
    for (String title1 in list) {
      _views.add(Text.rich(TextSpan(
        text: '$i.',
        style: const TextStyle(color: AppColors.FF959EB1, fontSize: 12.0),
        children: [
          TextSpan(
              text: title1 ?? '',
              style: const TextStyle(color: AppColors.FF2F4058))
        ],
      )));
      if (i < list.length)
        _views.add(const Divider(color: Color(0xFFE3E3E7), thickness: 1));
      i++;
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(title ?? '',
                style:
                    const TextStyle(color: AppColors.FF959EB1, fontSize: 12.0)),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: AppColors.FFF4F5F8,
                borderRadius: BorderRadius.circular(4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _views,
            ),
          ),
        ],
      ),
    );
  }
}
