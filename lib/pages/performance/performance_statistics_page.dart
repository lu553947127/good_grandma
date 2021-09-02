import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/pages/performance/my_performance_page.dart';
import 'package:good_grandma/pages/performance/subordinate_performance_page.dart';
import 'package:good_grandma/widgets/statistics_cell.dart';
import 'package:good_grandma/widgets/statistics_head_widget.dart';

///业绩统计
class PerformanceStatisticsPage extends StatefulWidget {
  const PerformanceStatisticsPage({Key key}) : super(key: key);

  @override
  _PerformanceStatisticsPageState createState() =>
      _PerformanceStatisticsPageState();
}

class _PerformanceStatisticsPageState extends State<PerformanceStatisticsPage> {
  List<Map> _dataArray = [];
  double _target = 0;
  double _current = 0;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    Widget titleView = Text('我的业绩(元)',
        style: const TextStyle(
            color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold));
    bool showRightArrow = true;
    return Scaffold(
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            StatisticsHeadWidget(
              titleView: titleView,
              target: _target,
              current: _current,
              showRightArrow: showRightArrow,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => MyPerformancePage())),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              sliver: SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(10.0),
                  child: const Text('下级业绩',
                      style: const TextStyle(
                          color: AppColors.FFC1C8D7, fontSize: 12.0)),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                Map map = _dataArray[index];
                String avatar = map['avatar'];
                String name = map['name'];
                String target = map['target'];
                String current = map['current'];
                String id = map['id'];
                return StatisticsCell(
                    avatar: avatar,
                    name: name,
                    target: target,
                    current: current,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SubordinatePerformancePage(
                                id: id, name: name))));
              }, childCount: _dataArray.length)),
            )
          ],
        ),
      ),
    );
  }

  void _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _target = 500000.0;
    _current = 50000.0;
    _dataArray.clear();
    _dataArray.addAll([
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '张三',
        'target': '12120.00',
        'current': '1234.00',
        'id': '0'
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '张三',
        'target': '12120.00',
        'current': '1234.00',
        'id': '0'
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '张三',
        'target': '12120.00',
        'current': '1234.00',
        'id': '0'
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '张三',
        'target': '12120.00',
        'current': '1234.00',
        'id': '0'
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '张三',
        'target': '12120.00',
        'current': '1234.00',
        'id': '0'
      },
    ]);
    if (mounted) setState(() {});
  }
}
