import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';

///库存详细
class StockDetailPage extends StatefulWidget {
  const StockDetailPage({Key key, @required this.id}) : super(key: key);
  final String id;

  @override
  _StockDetailPageState createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  List<Map> _dataArray = [];
  String _avatar = '';
  String _shopName = '';
  String _name = '';
  String _phone = '';
  String _address = '';
  String _boxNum = '';
  String _unboxNum = '';

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('库存详细')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              //顶部显示信息的视图
              _StockDetailHeader(
                  avatar: _avatar,
                  shopName: _shopName,
                  name: _name,
                  phone: _phone,
                  address: _address),
              _GroupTitle(boxNum: _boxNum, unboxNum: _unboxNum),
              //列表
              SliverSafeArea(
                sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  Map map = _dataArray[index];
                  String month = map['month'];
                  List<Map> goods = map['goods'];
                  return _StockDetailCell(
                    month: month,
                    goods: goods,
                  );
                }, childCount: _dataArray.length)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _avatar =
        'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg';
    _shopName = '荣格超市';
    _name = '荣格超市111';
    _phone = '13244445555';
    _address = '济阳高速服务区';
    _boxNum = '1234';
    _unboxNum = '12345';

    _dataArray.clear();
    _dataArray.addAll([
      {
        'month': '8月',
        'goods': [
          {'name': '巧克力口味冰淇淋', 'num1': '12', 'num2': '222', 'num3': '333'},
          {'name': '巧克力口味冰淇淋', 'num1': '12', 'num2': '222', 'num3': '333'},
          {'name': '巧克力口味冰淇淋', 'num1': '12', 'num2': '222', 'num3': '333'},
          {'name': '巧克力口味冰淇淋', 'num1': '12', 'num2': '222', 'num3': '333'},
        ]
      },
      {
        'month': '7月',
        'goods': [
          {'name': '巧克力口味冰淇淋', 'num1': '12', 'num2': '222', 'num3': '333'},
          {'name': '巧克力口味冰淇淋', 'num1': '12', 'num2': '222', 'num3': '333'},
          {'name': '巧克力口味冰淇淋', 'num1': '12', 'num2': '222', 'num3': '333'},
          {'name': '巧克力口味冰淇淋', 'num1': '12', 'num2': '222', 'num3': '333'},
        ]
      },
      {
        'month': '6月',
        'goods': [
          {'name': '巧克力口味冰淇淋', 'num1': '12', 'num2': '222', 'num3': '333'},
          {'name': '巧克力口味冰淇淋', 'num1': '12', 'num2': '222', 'num3': '333'},
          {'name': '巧克力口味冰淇淋', 'num1': '12', 'num2': '222', 'num3': '333'},
        ]
      },
    ]);
    setState(() {});
  }
}

class _StockDetailCell extends StatelessWidget {
  const _StockDetailCell({
    Key key,
    @required this.month,
    @required this.goods,
  }) : super(key: key);

  final String month;
  final List<Map> goods;

  @override
  Widget build(BuildContext context) {
    List<Widget> views = [];
    goods.forEach((map) {
      String name = map['name'];
      String num1 = map['num1'];
      String num2 = map['num2'];
      String num3 = map['num3'];
      views.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Text(name,
                style:
                    const TextStyle(color: AppColors.FF2F4058, fontSize: 14.0)),
          ),
          Text.rich(TextSpan(
              text: '整箱(40支)：',
              style: const TextStyle(color: AppColors.FF959EB1, fontSize: 12.0),
              children: [
                TextSpan(
                  text: num1,
                  style:
                  const TextStyle(color: AppColors.FFE45C26, fontSize: 14.0),
                ),
                TextSpan(text: '   整箱(20支)：'),
                TextSpan(
                  text: num2,
                  style:
                  const TextStyle(color: AppColors.FFE45C26, fontSize: 14.0),
                ),
                TextSpan(text: '   非整箱：'),
                TextSpan(
                  text: num3,
                  style:
                  const TextStyle(color: AppColors.FFE45C26, fontSize: 14.0),
                ),
                TextSpan(text: '支')
              ])),
          const Divider(color: AppColors.FFEFEFF4, thickness: 1.0)
        ],
      ));
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 16.0),
                child: Text(month,
                    style: const TextStyle(
                        color: AppColors.FF2F4058, fontSize: 14.0)),
              ),
              Column(children: views),
            ],
          ),
          const Divider(color: AppColors.FFEFEFF4, thickness: 1.0, height: 1.0)
        ],
      ),
    );
  }
}

class _GroupTitle extends StatelessWidget {
  const _GroupTitle({
    Key key,
    @required String boxNum,
    @required String unboxNum,
  })  : _boxNum = boxNum,
        _unboxNum = unboxNum,
        super(key: key);

  final String _boxNum;
  final String _unboxNum;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Row(
              children: [
                Text('最近6个月库存',
                    style: const TextStyle(
                        color: AppColors.FF959EB1, fontSize: 12.0)),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                        text: '总库存整箱：',
                        style: const TextStyle(
                            color: AppColors.FF2F4058, fontSize: 12.0),
                        children: [
                          TextSpan(
                            text: _boxNum,
                            style: const TextStyle(
                                color: AppColors.FFE45C26, fontSize: 14.0),
                          ),
                          TextSpan(text: '   非整箱：'),
                          TextSpan(
                            text: _unboxNum,
                            style: const TextStyle(
                                color: AppColors.FFE45C26, fontSize: 14.0),
                          ),
                          TextSpan(text: '支'),
                        ]),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 13.0),
              child: Container(
                width: double.infinity,
                color: AppColors.FFEFEFF4,
                padding: const EdgeInsets.all(10.0),
                child: const Text('月份    商品名称',
                    style:
                        TextStyle(color: AppColors.FF2F4058, fontSize: 12.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///顶部显示信息的视图
class _StockDetailHeader extends StatelessWidget {
  const _StockDetailHeader({
    Key key,
    @required String avatar,
    @required String shopName,
    @required String name,
    @required String phone,
    @required String address,
  })  : _avatar = avatar,
        _shopName = shopName,
        _name = name,
        _phone = phone,
        _address = address,
        super(key: key);

  final String _avatar;
  final String _shopName;
  final String _name;
  final String _phone;
  final String _address;

  @override
  Widget build(BuildContext context) {
    List<Map> values = [
      {
        'image': 'assets/images/ic_login_name.png',
        'title': '店主姓名：',
        'value': _name
      },
      {
        'image': 'assets/images/ic_login_phone.png',
        'title': '联系电话：',
        'value': _phone
      },
      {
        'image': 'assets/images/sign_in_local2.png',
        'title': '所在地址：',
        'value': _address
      },
    ];
    List<Widget> views = [];
    values.forEach((map) {
      String image = map['image'];
      String title = map['title'];
      String value = map['value'];
      views.add(Row(
        children: [
          Image.asset(image, width: 12, height: 12),
          Expanded(
              child: Text(title + value,
                  style:
                      const TextStyle(color: AppColors.FF959EB1, fontSize: 12)))
        ],
      ));
    });
    return SliverToBoxAdapter(
      child: Card(
        child: ListTile(
          leading: ClipOval(
              child:
                  MyCacheImageView(imageURL: _avatar, width: 50, height: 50)),
          title: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 10),
            child: Text(_shopName,
                style:
                    const TextStyle(color: AppColors.FF2F4058, fontSize: 14)),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: views),
          ),
        ),
      ),
    );
  }
}
