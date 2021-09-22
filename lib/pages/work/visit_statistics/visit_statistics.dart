import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/work/visit_statistics/visit_statistics_list.dart';
import 'package:good_grandma/pages/work/visit_statistics/visit_statistics_select.dart';
import 'package:good_grandma/pages/work/visit_statistics/visit_statistics_type.dart';
import 'package:good_grandma/widgets/select_form.dart';

///拜访统计
class VisitStatistics extends StatefulWidget {
  const VisitStatistics({Key key}) : super(key: key);

  @override
  _VisitStatisticsState createState() => _VisitStatisticsState();
}

class _VisitStatisticsState extends State<VisitStatistics> {

  List<Map> customerVisitList = [];
  String type = '员工统计';
  List<Map> listTitle = [
    {'name': '员工统计'},
    {'name': '客户统计'},
  ];

  String customerName = '所有人';
  String time = '所有日期';

  ///拜访统计列表
  _customerVisitList(typeId){
    Map<String, dynamic> map = {'type': typeId, 'current': '1', 'size': '999'};
    requestGet(Api.customerVisitList, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---customerVisitList----$data');
      setState(() {
        if (typeId == '1'){
          type = listTitle[0]['name'];
        }else {
          type = listTitle[1]['name'];
        }
        customerVisitList = (data['data'] as List).cast();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _customerVisitList('1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("拜访统计",style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: CustomScrollView(
        slivers: [
          VisitStatisticsSelect(
            color: Colors.white,
            type: type,
            list: listTitle,
            onPressed: () {
              _customerVisitList('1');
            },
            onPressed2: () {
              _customerVisitList('2');
            }
          ),
          VisitStatisticsType(
            customerName: customerName,
            time: time,
            onPressed: ()async{
              Map select = await showSelectList(context, Api.customerList, '请选择客户名称', 'realName');
              setState(() {
                customerName = select['realName'];
              });
            },
            onPressed2: () async {
              showPickerDateRange(
                  context: Application.appContext,
                  callBack: (Map param){
                    setState(() {
                      time = param['startTime'] + param['endTime'];
                    });
                  }
              );
            },
          ),
          customerVisitList.length > 0 ?
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return VisitStatisticsList(data: customerVisitList[index]);
              }, childCount: customerVisitList.length)) :
          SliverToBoxAdapter(
              child: Container(
                  margin: EdgeInsets.all(40),
                  child: Image.asset('assets/images/icon_empty_images.png', width: 150, height: 150)
              )
          )
        ],
      )
    );
  }
}
