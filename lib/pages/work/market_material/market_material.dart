import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/pages/work/market_material/market_material_add.dart';
import 'package:good_grandma/pages/work/market_material/market_material_detail.dart';
import 'package:good_grandma/pages/work/market_material/market_material_model.dart';
import 'package:good_grandma/widgets/custom_progress_circle.dart';
import 'package:provider/provider.dart';

///市场物料
class MarketMaterial extends StatefulWidget {
  const MarketMaterial({Key key}) : super(key: key);

  @override
  _MarketMaterialState createState() => _MarketMaterialState();
}

class _MarketMaterialState extends State<MarketMaterial> {

  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();

  int _current = 1;
  int _pageSize = 10;
  List<Map> materialList = [];

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text("市场物料", style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
            actions: [
              new PopupMenuButton<String>(
                  child: Center(
                      child: Container(
                          margin: EdgeInsets.only(right: 10.0),
                          child: Text("出入库", style: TextStyle(fontSize: 14, color: Color(0xFFC08A3F))
                          )
                      )
                  ),
                  itemBuilder: (context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                          value: '出库',
                          child: Text('出库')
                      ),
                      PopupMenuItem<String>(
                          value: '入库',
                          child: Text('入库')
                      )
                    ];
                  },
                  onSelected: (name){
                    MarketMaterialModel model = MarketMaterialModel();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) =>
                            ChangeNotifierProvider<MarketMaterialModel>.value(
                              value: model,
                              child: MarketMaterialAdd(title: name))));
                  })
            ]
        ),
      body: MyEasyRefreshSliverWidget(
        controller: _controller,
        scrollController: _scrollController,
        dataCount: materialList.length,
        onRefresh: _refresh,
        onLoad: _onLoad,
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return InkWell(
                    child: Container(
                        margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                        padding: EdgeInsets.all(10.0),
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
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 200,
                                child: Text(materialList[index]['materialName'], style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                              ),
                              Row(
                                  children: [
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CustomProgressCircle(
                                            size: 25,
                                            ratio: double.parse(materialList[index]['used'].toString()) / double.parse(materialList[index]['quantity'].toString()),
                                            color: Color(0XFF959EB1),
                                            width: 30,
                                            height: 30,
                                          ),
                                          Container(
                                            width: 30,
                                            child: Text('使用', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                          )
                                        ]
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CustomProgressCircle(
                                            size: 25,
                                            ratio: double.parse(materialList[index]['stock'].toString()) / double.parse(materialList[index]['quantity'].toString()),
                                            color: Color(0XFF05A8C6),
                                            width: 30,
                                            height: 30,
                                          ),
                                          Container(
                                              width: 30,
                                              child: Text('可用', style: TextStyle(fontSize: 12, color: Color(0XFF05A8C6)))
                                          )
                                        ]
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CustomProgressCircle(
                                            size: 25,
                                            ratio: double.parse(materialList[index]['loss'].toString()) / double.parse(materialList[index]['quantity'].toString()),
                                            color: Color(0XFFE45C26),
                                            width: 30,
                                            height: 30,
                                          ),
                                          Container(
                                              width: 30,
                                              child: Text('耗损', style: TextStyle(fontSize: 12, color: Color(0XFFE45C26)))
                                          )
                                        ]
                                    )
                                  ]
                              )
                            ]
                        )
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder:(context)=> MarketMaterialDetail(
                        materialAreaId: materialList[index]['id'],
                      )));
                    }
                );
              }, childCount: materialList.length)),
        ]
      )
    );
  }

  Future<void> _refresh() async {
    _current = 1;
    await _downloadData();
  }

  Future<void> _onLoad() async {
    _current++;
    await _downloadData();
  }

  ///市场物料列表
  Future<void> _downloadData() async {
    try {
      Map<String, dynamic> map = {'current': _current, 'size': _pageSize};
      final val = await requestGet(Api.materialList, param: map);
      var data = jsonDecode(val.toString());
      LogUtil.d('请求结果---materialList----$data');
      if (_current == 1) materialList.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        materialList.add(map);
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

