import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/widgets/contract_cell.dart';
import 'package:good_grandma/widgets/contract_select_type.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String _selCustomers = '';
  String _selType = '';
  String _selState = '';

  ///电子合同签署h5链接
  _contractSignUrl(id){
    Map<String, dynamic> map = {
      'id': id
    };
    requestPost(Api.contractSignUrl, json: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---contractSignUrl----$data');
      if(data['code'] == 200){
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ContractUrlPage(url: data['msg'])));
        _launchURL(data['msg']);
      }else{
        AppUtil.showToastCenter(data['msg']);
      }
    });
  }

  ///用内置浏览器打开网页
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: 'Could not launch $url', gravity: ToastGravity.CENTER);
    }
  }

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
            onSelect: (String areaId, String customerId, String signType, String status){
              _selArea = areaId;
              _selCustomers = customerId;
              _selType = signType;
              _selState = status;
              _controller.callRefresh();
            }
          )
        )
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
                  String id = map['id'];
                  List<Map> signersList = (map['signerslist'] as List).cast();
                  return ContractCell(
                    title: title,
                    status: status,
                    signType: signType,
                    signersList: signersList,
                    onTap: () {
                      _contractSignUrl(id);
                    }
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
        'areaId': _selArea,
        'customerId': _selCustomers,
        'signType': _selType,
        'status': _selState,
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
