import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
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
  List<Map> _dataArray = [];
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
          dataCount: _dataArray.length,
          onRefresh: _refresh,
          onLoad: _onLoad,
          slivers: [
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  Map map = _dataArray[index];
                  String title = map['title'];
                  bool signed = map['signed'];
                  String type = map['type'];
                  String signUser = map['signUser'];
                  String signTime = map['signTime'];
                  String endSignTime = map['endSignTime'];
                  String id = map['id'];
                  return ContractCell(
                    title: title,
                    signed: signed,
                    type: type,
                    signUser: signUser,
                    signTime: signTime,
                    endSignTime: endSignTime,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ContractDetailPage(id: id))),
                  );
                }, childCount: _dataArray.length)),
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
    try{
      await Future.delayed(Duration(seconds: 1));
      if(_current == 0)
        _dataArray.clear();
      List list = [];
      for (int i = 0; i < 13; i++) {
        bool signed = false;
        if (i % 2 == 0) signed = true;
        Map model = {
          'title': '合同名称合同名称合同名称合',
          'signed': signed,
          'type': '销售合同',
          'signUser': '张三',
          'signTime': '2021-07-01',
          'endSignTime': '2021-07-01',
          'id': '1'
        };
        list.add(model);
        _dataArray.add(model);
      }
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
