import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/widgets/sales_statistics_detail_header.dart';
import 'package:good_grandma/widgets/sales_statistics_detail_shop_cell.dart';

///管理层详细页面
class SalesStatisticsDetailPage extends StatefulWidget {
  const SalesStatisticsDetailPage(
      {Key key,
      @required this.title,
      @required this.id,
      @required this.salesCount,
      @required this.salesPrice,
      this.limitArea = false,
      this.limitEmp = false,
      this.limitCus = false})
      : super(key: key);
  final String title;
  final String id;
  final String salesCount;
  final String salesPrice;

  ///限制了区域
  final bool limitArea;

  ///限制了员工
  final bool limitEmp;

  ///限制了客户
  final bool limitCus;

  @override
  _SalesStatisticsDetailPageState createState() =>
      _SalesStatisticsDetailPageState();
}

class _SalesStatisticsDetailPageState extends State<SalesStatisticsDetailPage> {
  List<Map> _dataArray1 = [];
  List<Map> _dataArray2 = [];
  List<Map> _dataArray3 = [];
  int _selIndex = 0;

  @override
  void initState() {
    if (widget.limitArea) {
      if (widget.limitEmp) {
        _selIndex = 2;
      } else {
        _selIndex = 1;
      }
    } else {
      _selIndex = 0;
    }
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    bool hasSafeArea = MediaQuery.of(context).padding.top > 40;
    List<String> names = ['区域', '人员', '客户'];
    List<bool> shows = [widget.limitArea, widget.limitEmp, widget.limitCus];
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
              sliver: SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: List.generate(
                        names.length,
                        (index) => Visibility(
                              visible: !shows[index],
                              child: Expanded(
                                child: TextButton(
                                    onPressed: () {
                                      if (_selIndex == index) return;
                                      setState(() {
                                        _selIndex = index;
                                      });
                                      _refresh();
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          names[index],
                                          style: TextStyle(
                                              color: _selIndex == index
                                                  ? AppColors.FFC08A3F
                                                  : AppColors.FF959EB1,
                                              fontSize: 14.0),
                                        ),
                                        SizedBox(height: 9),
                                        Visibility(
                                            visible: _selIndex == index,
                                            child: Container(
                                              width: 20,
                                              height: 2,
                                              color: AppColors.FFC08A3F,
                                            )),
                                      ],
                                    )),
                              ),
                            )),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                Map map = _getCurrentList()[index];
                String title = map['title'];
                String id = map['id'];
                String count = map['count'];
                String price = map['price'];
                return SalesStatisticsDetailShopCell(
                    title: title, count: count, price: price);
              }, childCount: _getCurrentList().length)),
            )
          ],
        ),
      ),
    );
  }

  List<Map> _getCurrentList() {
    if (_selIndex == 0) {
      return _dataArray1;
    } else if (_selIndex == 1) {
      return _dataArray2;
    }
    return _dataArray3;
  }

  void _refresh() {
    if (_selIndex == 0) {
      _getDataArray1();
    } else if (_selIndex == 1) {
      _getDataArray2();
    } else if (_selIndex == 2) {
      _getDataArray3();
    }
  }

  void _getDataArray1() async {
    await Future.delayed(Duration(seconds: 1));
    _dataArray1.clear();
    _dataArray1.addAll(List.generate(
        4,
        (index) => {
              'title': '汉堡店1$index',
              'id': '$index',
              'count': '52300',
              'price': '50220',
            }));
    if (mounted) setState(() {});
  }

  void _getDataArray2() async {
    await Future.delayed(Duration(seconds: 1));
    _dataArray2.clear();
    _dataArray2.addAll(List.generate(
        8,
        (index) => {
              'title': '汉堡店2$index',
              'id': '$index',
              'count': '52300',
              'price': '50220',
            }));
    if (mounted) setState(() {});
  }

  void _getDataArray3() async {
    await Future.delayed(Duration(seconds: 1));
    _dataArray3.clear();
    _dataArray3.addAll(List.generate(
        3,
        (index) => {
              'title': '汉堡店3$index',
              'id': '$index',
              'count': '52300',
              'price': '50220',
            }));
    if (mounted) setState(() {});
  }
}

class _BottomList extends StatefulWidget {
  const _BottomList({
    this.limitArea = false,
    this.limitEmp = false,
    this.limitCus = false,
    Key key,
    this.dataArray1,
    this.dataArray2,
    this.dataArray3,
  }) : super(key: key);

  ///限制了区域
  final bool limitArea;

  ///限制了员工
  final bool limitEmp;

  ///限制了客户
  final bool limitCus;
  final List<Map> dataArray1;
  final List<Map> dataArray2;
  final List<Map> dataArray3;

  @override
  _BottomListState createState() => _BottomListState();
}

class _BottomListState extends State<_BottomList> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    final double cellHeight = 50;
    final _tabPages = <Widget>[
      Container(
        width: double.infinity,
        height: cellHeight * widget.dataArray1.length,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          physics: NeverScrollableScrollPhysics(),
          children:
              List.generate(widget.dataArray1.length, (index) => Text('data')),
        ),
      ),
      Container(
        width: double.infinity,
        height: cellHeight * widget.dataArray2.length,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          physics: NeverScrollableScrollPhysics(),
          children:
              List.generate(widget.dataArray2.length, (index) => Text('data')),
        ),
      ),
      Container(
        width: double.infinity,
        height: cellHeight * widget.dataArray3.length,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          physics: NeverScrollableScrollPhysics(),
          children:
              List.generate(widget.dataArray3.length, (index) => Text('data')),
        ),
      ),
      // Container(height: 100,),
    ];
    final _tabs = <Tab>[
      Tab(text: '区域'),
      Tab(text: '人员'),
      Tab(text: '客户'),
    ];
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      sliver: SliverToBoxAdapter(
        child: DefaultTabController(
          length: _tabs.length,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 25,
                child: TabBar(
                  onTap: (index) {
                    setState(() {
                      _index = index;
                    });
                  },
                  tabs: _tabs,
                  indicatorColor: AppColors.FFE45C26,
                  indicatorPadding:
                      const EdgeInsets.symmetric(horizontal: 30.0),
                  indicatorWeight: 2.0,
                  unselectedLabelColor: AppColors.FF959EB1,
                  labelColor: AppColors.FFE45C26,
                  labelStyle: const TextStyle(fontSize: 12.0),
                  // indicatorSize: TabBarIndicatorSize(0,0),
                ),
              ),
              // TabBarView(children: _tabPages),
              Container(
                  width: double.infinity,
                  height: (_index == 0
                          ? widget.dataArray1.length
                          : (_index == 1
                              ? widget.dataArray2.length
                              : widget.dataArray3.length)) *
                      cellHeight,
                  child: TabBarView(children: _tabPages)),
            ],
          ),
        ),
      ),
    );
  }
}
