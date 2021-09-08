import 'package:flutter/material.dart';
import 'package:good_grandma/pages/sales_statistics/sales_statistics_order_detail_page.dart';
import 'package:good_grandma/widgets/sales_statistics_detail_header.dart';
import 'package:good_grandma/widgets/sales_statistics_detail_shop_cell.dart';
import 'package:good_grandma/widgets/sales_statistics_detail_shop_order_cell.dart';

///业务经理详细页面
class SalesStatisticsSalesManPage extends StatefulWidget {
  const SalesStatisticsSalesManPage(
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
  _SalesStatisticsSalesManPageState createState() =>
      _SalesStatisticsSalesManPageState();
}

class _SalesStatisticsSalesManPageState
    extends State<SalesStatisticsSalesManPage> {
  List<Map> _dataArray1 = [];
  List<Map> _dataArray2 = [];

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
                Map map = _dataArray1[index];
                String title = map['title'];
                String id = map['id'];
                String count = map['count'];
                String price = map['price'];
                return SalesStatisticsDetailShopCell(
                    title: title, count: count, price: price);
              }, childCount: _dataArray1.length)),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                child: const Text('订货统计', style: TextStyle(fontSize: 12.0)),
              ),
            ),
            SliverSafeArea(
              top: false,
              sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                Map map = _dataArray2[index];
                String title = map['title'];
                String id = map['id'];
                String count = map['count'];
                String avatar = map['avatar'];
                return SalesStatisticsDetailShopOrderCell(
                  avatar: avatar,
                  title: title,
                  count: count,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SalesStatisticsOrderDetailPage(
                              avatar: avatar,
                                goodsName: widget.title + ' - 订货明细',
                                id: id,
                                count: count, shopName: title,)));
                  },
                );
              }, childCount: _dataArray2.length)),
            ),
          ],
        ),
      ),
    );
  }

  void _refresh() {
    _getDataArray1();
    _getDataArray2();
  }

  _getDataArray1() async {
    await Future.delayed(Duration(seconds: 1));
    _dataArray1.clear();
    _dataArray1.addAll(List.generate(
        8,
        (index) => {
              'title': '汉堡店$index',
              'id': '$index',
              'count': '52300',
              'price': '50220',
            }));
    if (mounted) setState(() {});
  }

  _getDataArray2() async {
    await Future.delayed(Duration(seconds: 1));
    _dataArray2.clear();
    _dataArray2.addAll(List.generate(
        8,
        (index) => {
              'avatar':
                  'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
              'title': '汉堡店$index',
              'id': '$index',
              'count': '5230',
            }));
    if (mounted) setState(() {});
  }
}
