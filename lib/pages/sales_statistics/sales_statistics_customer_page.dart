import 'package:flutter/material.dart';
import 'package:good_grandma/widgets/sales_statistics_detail_header.dart';
import 'package:good_grandma/widgets/sales_statistics_detail_order_cell.dart';

///客户详细页面
class SalesStatisticsCustomerPage extends StatefulWidget {
  const SalesStatisticsCustomerPage(
      {Key key,
      @required this.title,
      @required this.id,
      @required this.salesCount,
      @required this.salesPrice})
      : super(key: key);
  final String title;
  final String id;
  final String salesCount;
  final String salesPrice;

  @override
  _SalesStatisticsCustomerPageState createState() =>
      _SalesStatisticsCustomerPageState();
}

class _SalesStatisticsCustomerPageState
    extends State<SalesStatisticsCustomerPage> {
  List<Map> _dataArray = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    bool hasSafeArea = MediaQuery.of(context).padding.top > 40;
    return Scaffold(
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SalesStatisticsDetailHeader(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(2, (index) {
                    return Column(
                      children: [
                        Text(index == 0 ? widget.salesCount : widget.salesPrice,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 36)),
                        SizedBox(height: 10.0),
                        Text(index == 0 ? '销量' : '销售额',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12))
                      ],
                    );
                  }),
                ),
                bgImageName: hasSafeArea
                    ? 'assets/images/sign_in_bg_large.png'
                    : 'assets/images/sign_in_bg.png',
                title: widget.title),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    Map map = _dataArray[index];
                    String title = map['title'];
                    String id = map['id'];
                    String time = map['time'];
                    String count = map['count'];
                    String price = map['price'];
                    return SalesStatisticsDetailOrderCell(title: title, time: time, count: count, price: price);
                  }, childCount: _dataArray.length)),
            )
          ],
        ),
      ),
    );
  }
  void _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _dataArray.clear();
    _dataArray.addAll(List.generate(
        8,
            (index) => {
          'title': '巧克力口味冰淇淋（规格：1*40）$index',
          'id': '$index',
          'time': '2012-07-01',
              'count': '50',
          'price': '500',
        }));
    if (mounted) setState(() {});
  }
}
