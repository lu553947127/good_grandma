import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/goods_model.dart';
import 'package:good_grandma/models/marketing_activity_model.dart';
import 'package:good_grandma/pages/marketing_activity/add_marketing_activity_page.dart';
import 'package:good_grandma/pages/work/work_report/work_type_title.dart';
import 'package:good_grandma/widgets/marketing_activity_cell.dart';
import 'package:provider/provider.dart';

///市场活动
class MarketingActivityPage extends StatefulWidget {
  const MarketingActivityPage({Key key}) : super(key: key);

  @override
  _MarketingActivityPageState createState() => _MarketingActivityPageState();
}

class _MarketingActivityPageState extends State<MarketingActivityPage> {
  String _type = '待审核';
  List<Map> _listTitle = [
    {'name': '待审核'},
    {'name': '进行中'},
    {'name': '已完结'},
  ];
  List<MarketingActivityModel> _dataArray = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('市场活动')),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            //切换选项卡
            WorkTypeTitle(
              color: Colors.transparent,
              type: _type,
              list: _listTitle,
              onPressed: () {
                setState(() {
                  _type = _listTitle[0]['name'];
                });
              },
              onPressed2: () {
                setState(() {
                  _type = _listTitle[1]['name'];
                });
              },
              onPressed3: () {
                setState(() {
                  _type = _listTitle[2]['name'];
                });
              },
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return MarketingActivityCell(
                model: _dataArray[index],
                state: _type,
              );
            }, childCount: _dataArray.length)),
            SliverSafeArea(sliver: SliverToBoxAdapter()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: AppColors.FFC68D3E,
        onPressed: () async{
          MarketingActivityModel model = MarketingActivityModel();
          bool needRefresh = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      ChangeNotifierProvider<MarketingActivityModel>.value(
                        value: model,
                        child: AddMarketingActivityPage(),
                      )));
          if(needRefresh != null && needRefresh){
            _refresh();
          }
        },
      ),
    );
  }

  void _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _dataArray.clear();
    for (int i = 0; i < 2; i++) {
      MarketingActivityModel model = MarketingActivityModel();
      model.setTitle('活动名称活动名称活动名称活动名称');
      model.setType('活动类型');
      model.setLeading('负责人');
      model.setStartTime('2021-08-30 00:00:00');
      model.setEndTime('2021-08-30 00:00:00');
      model.setSponsor('主办方');
      model.setBudgetCurrent('12345');
      model.setBudgetCount('123456');
      model.setGoodsList([
        GoodsModel(
          name: '商品名称',
          image:
              'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
          count: 100,
          // spec: '规格：1*40',
        ),
        GoodsModel(
          name: '商品名称',
          image:
              'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
          count: 100,
          // spec: '规格：1*40',
        ),
      ]);
      _dataArray.add(model);
    }
    if (mounted) setState(() {});
  }
}
