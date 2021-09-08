import 'package:flutter/material.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/widgets/sales_statistics_detail_header.dart';
import 'package:good_grandma/widgets/sales_statistics_detail_order_cell.dart';

///客户详细页面
class SalesStatisticsOrderDetailPage extends StatefulWidget {
  const SalesStatisticsOrderDetailPage(
      {Key key,
        @required this.avatar,
        @required this.goodsName,
        @required this.shopName,
        @required this.id,
        @required this.count,})
      : super(key: key);
  final String avatar;
  final String goodsName;
  final String shopName;
  final String id;
  final String count;

  @override
  _SalesStatisticsOrderDetailPageState createState() =>
      _SalesStatisticsOrderDetailPageState();
}

class _SalesStatisticsOrderDetailPageState
    extends State<SalesStatisticsOrderDetailPage> {
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      ClipOval(
                          child: MyCacheImageView(imageURL: widget.avatar, width: 35, height: 35)),
                      Expanded(
                          child: Text('  ' + widget.shopName, style: const TextStyle(color:Colors.white,fontSize: 14.0))),
                      Text('订货数量：${widget.count}',
                          style: const TextStyle(
                              fontSize: 12.0, color: Colors.white)),
                    ],
                  ),
                ),
                bgImageName: hasSafeArea
                    ? 'assets/images/sign_in_bg.png'
                    : 'assets/images/sign_in_bg.png',
                title: widget.goodsName),
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
