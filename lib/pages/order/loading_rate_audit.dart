import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/pages/order/loading_rate_audit_detail.dart';

///装车率审核
class LoadingRateAudit extends StatefulWidget {
  const LoadingRateAudit({Key key}) : super(key: key);

  @override
  State<LoadingRateAudit> createState() => _LoadingRateAuditState();
}

class _LoadingRateAuditState extends State<LoadingRateAudit> {

  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  List<Map> _dataArray = [];

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('装车率审核')),
      body: MyEasyRefreshSliverWidget(
          controller: _controller,
          scrollController: _scrollController,
          dataCount: _dataArray.length,
          onRefresh: _refresh,
          onLoad: null,
          slivers: [
            //列表
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  Map model = _dataArray[index];
                  List<dynamic> orderTitle = (model['orderTitle'] as List).cast();
                  return Container(
                      margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              offset: Offset(2, 1),
                              blurRadius: 1.5,
                            )
                          ]
                      ),
                      child: InkWell(
                          child: Column(
                              mainAxisSize:MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${model['title']}',style: TextStyle(fontSize: 15, color: Color(0XFFE45C26))),
                                          Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(color: Color(0xFFFAEEEA), borderRadius: BorderRadius.circular(3)),
                                              child: Text('审核中', style: TextStyle(fontSize: 10, color: Color(0xFFE45C26)))
                                          )
                                        ]
                                    )
                                ),
                                // Container(
                                //   alignment: Alignment.centerLeft,
                                //   width: double.infinity,
                                //   padding: EdgeInsets.only(left: 10.0),
                                //   height: 40,
                                //   color: Color(0XFFEFEFF4),
                                //   child: Text('订单号: ${model['id']}',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                // ),
                                SizedBox(height: 5),
                                SizedBox(width: double.infinity, height: 1,
                                    child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFFF5F5F8)))),
                                Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ListView.builder(
                                        shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                                        physics:NeverScrollableScrollPhysics(),//禁止滚动
                                        itemCount: orderTitle.length,
                                        itemBuilder: (content, index){
                                          return Container(
                                              margin: EdgeInsets.only(top: 2),
                                              child: Text(
                                                '${orderTitle[index]}',
                                                style: const TextStyle(
                                                    color: AppColors.FF959EB1, fontSize: 12.0),
                                              )
                                          );
                                        }
                                    )
                                )
                              ]
                          ),
                          onTap: () async {
                            bool needRefresh = await Navigator.push(context,
                                MaterialPageRoute(builder:(context)=> LoadingRateAuditDetail(id: model['id'])));
                            if(needRefresh != null && needRefresh){
                              _controller.callRefresh();
                            }
                          }
                      )
                  );
                }, childCount: _dataArray.length)),
            SliverSafeArea(sliver: SliverToBoxAdapter()),
          ])
    );
  }

  Future<void> _refresh() async {
    _downloadData();
  }

  Future<void> _downloadData() async {
    try {
      final val = await requestPost(Api.orderFinanceCarList);
      LogUtil.d('amountList value = $val');
      var data = jsonDecode(val.toString());
      _dataArray.clear();
      final List<dynamic> list = data['data'];
      print(list.toString());
      list.forEach((map) {
        _dataArray.add(map as Map);
      });
      _controller.finishRefresh(success: true);
      if (mounted) setState(() {});
    } catch (error) {
      _controller.finishRefresh(success: false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
    _controller?.dispose();
  }
}
