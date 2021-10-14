import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/pages/contract/contract_detail_page.dart';
import 'package:good_grandma/pages/contract/select_customer_page.dart';
import 'package:good_grandma/widgets/contract_cell.dart';
import 'package:good_grandma/widgets/contract_select_type.dart';

///电子合同
class ContractPage extends StatefulWidget {
  const ContractPage({Key key}) : super(key: key);

  @override
  _ContractPageState createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  List<Map> contractList = [];
  int _current = 1;
  int _pageSize = 15;
  String _selArea = '';
  List<CustomerModel> _selCustomers = [];
  String _selType = '';
  String _selState = '';

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('电子合同'),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity,50),
          child: ContractSelectType(
            onSelect: (String selArea,List<CustomerModel> selCustomers,String selType,String selState){
              _selArea = selArea;
              _selCustomers = selCustomers;
              _selType = selType;
              _selState = selState;
              _controller.callRefresh();
            },
          ),
        ),
      ),
      body: MyEasyRefreshSliverWidget(
          controller: _controller,
          scrollController: _scrollController,
          dataCount: contractList.length,
          onRefresh: _refresh,
          onLoad: _onLoad,
          slivers: [
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  Map map = contractList[index];
                  String title = map['title'];
                  int status = map['status'];
                  String signType = map['signType'];
                  String signUser = map['customerId'];
                  String signTime = map['signTime'];
                  String id = map['id'];
                  return ContractCell(
                    title: title,
                    status: status,
                    signType: signType,
                    signUser: signUser,
                    signTime: signTime,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ContractDetailPage(id: id))),
                  );
                }, childCount: contractList.length)),
            SliverSafeArea(sliver: SliverToBoxAdapter()),
          ]),
    );
  }

  Future<void> _refresh() async {
    _current = 1;
    _downloadData();
  }
  Future<void> _onLoad() async{
    _current ++;
    _downloadData();
  }
  Future<void> _downloadData() async{
    try {
      Map<String, dynamic> map = {
        'current': _current,
        'size': _pageSize
      };
      final val = await requestPost(Api.contractList, json: map);
      var data = jsonDecode(val.toString());
      LogUtil.d('请求结果---contractList----$data');
      if (_current == 1) contractList.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        contractList.add(map);
      });
      bool noMore = false;
      if (list == null || list.isEmpty) noMore = true;
      _controller.finishRefresh(success: true);
      _controller.finishLoad(success: true, noMore: noMore);
      if (mounted) setState(() {});
    } catch (error) {
      _controller.finishRefresh(success: false);
      _controller.finishLoad(success: false, noMore: false);
    }
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _controller?.dispose();
    super.dispose();
  }
}
