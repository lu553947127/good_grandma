import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/pages/work/freezer_statistics/freezer_statistics_type.dart';
import 'package:good_grandma/widgets/sales_statistics_cell.dart';
import 'package:good_grandma/widgets/select_form.dart';
import 'package:good_grandma/widgets/select_tree.dart';

///商品销量统计
class SalesStatisticsPage extends StatefulWidget {

  @override
  _SalesStatisticsPageState createState() => _SalesStatisticsPageState();
}

class _SalesStatisticsPageState extends State<SalesStatisticsPage> {

  String deptId = '';
  String areaName = '所有区域';
  String userId= '';
  String userName = '所有客户';
  String customerId = '';
  String customerName = '所有客户';

  List<Map> commoditySalesList = [];

  ///商品销量统计列表
  _commoditySalesList(){
    Map<String, dynamic> map = {
      'deptId': deptId,
      'userId': userId,
      'customerId': customerId
    };
    requestGet(Api.commoditySalesList, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---commoditySalesList----$data');

      commoditySalesList = (data['data'] as List).cast();
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _commoditySalesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('商品销量统计')),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            //顶部筛选按钮
            FreezerStatisticsType(
              areaName: areaName,
              customerName: userName,
              statusName: customerName,
              onPressed: () async{
                Map area = await showSelectTreeList(context, '');
                deptId = area['deptId'];
                areaName = area['areaName'];
                _commoditySalesList();
              },
              onPressed2: () async{
                Map select = await showSelectList(context, Api.customerList, '请选择员工名称', 'realName');
                userId = select['id'];
                userName = select['realName'];
                _commoditySalesList();
              },
              onPressed3: () async {
                Map select = await showSelectList(context, Api.customerList, '请选择客户名称', 'realName');
                customerId = select['id'];
                customerName = select['realName'];
                _commoditySalesList();
              },
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              Map map = commoditySalesList[index];
              String title = map['name'] + ' (规格: ${map['spec']})';
              String salesCount = map['orderDetailed']['count'].toString();
              String salesPrice = map['orderDetailed']['total'].toString();
              return SalesStatisticsCell(
                title: title,
                salesCount: salesCount,
                salesPrice: salesPrice,
                onTap: null,
              );
            }, childCount: commoditySalesList.length)),
            SliverSafeArea(sliver: SliverToBoxAdapter()),
          ],
        ),
      ),
    );
  }
}
