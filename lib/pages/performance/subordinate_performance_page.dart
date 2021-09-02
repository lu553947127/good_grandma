import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/pages/performance/custom_performance_page.dart';
import 'package:good_grandma/widgets/statistics_cell.dart';
import 'package:good_grandma/widgets/statistics_head_widget.dart';

///下级业绩
class SubordinatePerformancePage extends StatefulWidget {
  const SubordinatePerformancePage(
      {Key key, @required this.id, @required this.name})
      : super(key: key);
  final String id;
  final String name;

  @override
  _SubordinatePerformancePageState createState() =>
      _SubordinatePerformancePageState();
}

class _SubordinatePerformancePageState
    extends State<SubordinatePerformancePage> {
  List<Map> _dataArray = [];
  String _position = '';
  double _target = 0;
  double _current = 0;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    Widget titleView = Text.rich(TextSpan(
        text: widget.name + '  ',
        style: const TextStyle(
            color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
        children: [
          TextSpan(text: _position, style: const TextStyle(fontSize: 12.0))
        ]));
    bool showRightArrow = false;
    return Scaffold(
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            StatisticsHeadWidget(
              titleView: titleView,
              title: widget.name + '业绩',
              target: _target,
              current: _current,
              showRightArrow: showRightArrow,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              sliver: SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(10.0),
                  child: const Text('客户业绩',
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
                            builder: (_) =>
                                CustomPerformancePage(id: id, name: name))));
              }, childCount: _dataArray.length)),
            )
          ],
        ),
      ),
    );
  }

  void _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _position = '业务经理';
    _target = 500000.0;
    _current = 50000.0;
    _dataArray.clear();
    _dataArray.addAll([
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '荣格超市',
        'target': '12120.00',
        'current': '1234.00',
        'id': '0'
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '荣格超市',
        'target': '12120.00',
        'current': '1234.00',
        'id': '0'
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '荣格超市',
        'target': '12120.00',
        'current': '1234.00',
        'id': '0'
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '荣格超市',
        'target': '12120.00',
        'current': '1234.00',
        'id': '0'
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '荣格超市',
        'target': '12120.00',
        'current': '1234.00',
        'id': '0'
      },
    ]);
    if (mounted) setState(() {});
  }
}
