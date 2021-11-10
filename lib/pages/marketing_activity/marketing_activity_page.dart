import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/models/marketing_activity_model.dart';
import 'package:good_grandma/pages/marketing_activity/add_marketing_activity_page.dart';
import 'package:good_grandma/pages/work/work_report/work_type_title.dart';
import 'package:good_grandma/widgets/marketing_activity_cell.dart';
import 'package:good_grandma/widgets/marketing_plan_activity_cell.dart';
import 'package:provider/provider.dart';

///市场活动
class MarketingActivityPage extends StatefulWidget {
  const MarketingActivityPage({Key key}) : super(key: key);

  @override
  _MarketingActivityPageState createState() => _MarketingActivityPageState();
}

class _MarketingActivityPageState extends State<MarketingActivityPage> {

  ///活动状态id
  String status = '1';

  ///活动状态名称
  String statusName = '未进行';

  ///未进行类型id
  String statusChild = '我发布的';

  ///活动状态集合
  List<Map> _listTitle = [
    {'name': '未进行'},
    {'name': '进行中'},
    {'name': '已完结'},
  ];

  ///活动列表
  List<MarketingActivityModel> activityList = [];
  List<Map> activityPlanList = [];

  ///市场活动列表
  _activityList(){
    Map<String, dynamic> map = {
      'status': status
    };
    requestGet(Api.activityList, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---fileCabinetList----$data');

      activityList.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        MarketingActivityModel model = MarketingActivityModel.fromJson(map);
        activityList.add(model);
      });
      setState(() {});
    });
  }

  ///行销规划列表
  _activityPlanList(){
    requestGet(Api.activityPlanList).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---activityPlanList----$data');

      activityPlanList = (data['data'] as List).cast();
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _activityList();
    _activityPlanList();
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
              type: statusName,
              list: _listTitle,
              onPressed: () {
                status = '1';
                statusName = '未进行';
                _activityList();
              },
              onPressed2: () {
                status = '2';
                statusName = '进行中';
                _activityList();
              },
              onPressed3: () {
                status = '3';
                statusName = '已完结';
                _activityList();
              },
            ),
            SliverVisibility(
              visible: statusName == '未进行' ? true : false,
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(onPressed: (){
                      setState(() {
                        statusChild = '我发布的';
                      });
                    }, child: Text('我发布的', style: TextStyle(color: statusChild == '我发布的' ? AppColors.FFC08A3F : AppColors.FF2F4058))),
                    TextButton(onPressed: (){
                      setState(() {
                        statusChild = '行销规划';
                      });
                    }, child: Text('行销规划', style: TextStyle(color: statusChild == '行销规划' ? AppColors.FFC08A3F : AppColors.FF2F4058))),
                  ]
                )
              )
            ),
            SliverVisibility(
                visible: statusName != '未进行' || statusChild == '我发布的' ? true : false,
                sliver: activityList.length > 0 ?
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return MarketingActivityCell(
                          model: activityList[index],
                          state: statusName
                      );
                    }, childCount: activityList.length)
                ):
                SliverToBoxAdapter(
                    child: Container(
                        margin: EdgeInsets.all(40),
                        child: Image.asset('assets/images/icon_empty_images.png', width: 150, height: 150)
                    )
                )
            ),
            SliverVisibility(
                visible: statusName == '未进行' ? statusChild == '行销规划' ? true : false : false,
                sliver: activityPlanList.length > 0 ?
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return MarketingPlanActivityCell(
                          model: activityPlanList[index]
                      );
                    }, childCount: activityPlanList.length)
                ):
                SliverToBoxAdapter(
                    child: Container(
                        margin: EdgeInsets.all(40),
                        child: Image.asset('assets/images/icon_empty_images.png', width: 150, height: 150)
                    )
                )
            ),
            SliverSafeArea(sliver: SliverToBoxAdapter()),
          ]
        )
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
            _activityList();
          }
        }
      )
    );
  }
}
