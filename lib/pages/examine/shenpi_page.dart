import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/models/main_provider.dart';
import 'package:good_grandma/pages/examine/examine_add.dart';
import 'package:good_grandma/pages/examine/examine_detail.dart';
import 'package:good_grandma/pages/examine/examine_select_process.dart';
import 'package:good_grandma/pages/examine/examine_view.dart';
import 'package:good_grandma/pages/examine/model/shenpi_type.dart';
import 'package:good_grandma/webview/webview.dart';
import 'package:provider/provider.dart';

///OA审批列表
class ShenPiPage extends StatefulWidget {
  const ShenPiPage({Key key}) : super(key: key);

  @override
  _ShenPiPageState createState() => _ShenPiPageState();
}

class _ShenPiPageState extends State<ShenPiPage> {

  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();

  int _current = 1;
  int _pageSize = 10;

  String type = '我申请的';
  List<Map> listTitle = [
    {'name': '我申请的'},
    {'name': '我的待办'},
    {'name': '我的已办'},
    {'name': '知会我的'},
  ];
  ///审批申请列表数据
  List<Map> examineList = [];

  MainProvider mainProvider;

  @override
  void initState() {
    super.initState();
    _refresh();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    mainProvider = Provider.of<MainProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('审批申请'),
      ),
      body: Column(
          children: [
            ExamineTypeTitle(
              color: null,
              type: type,
              list: listTitle,
              onPressed: (){
                type = listTitle[0]['name'];
                _controller.callRefresh();
              },
              onPressed2: (){
                type = listTitle[1]['name'];
                _controller.callRefresh();
              },
              onPressed3: (){
                type = listTitle[2]['name'];
                _controller.callRefresh();
              },
              onPressed4: (){
                type = listTitle[3]['name'];
                _controller.callRefresh();
              }
            ),
            Expanded(
              child: MyEasyRefreshSliverWidget(
                controller: _controller,
                scrollController: _scrollController,
                dataCount: examineList.length,
                onRefresh: _refresh,
                onLoad: _onLoad,
                slivers: [
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        String processIsFinished = '';
                        switch(examineList[index]['processIsFinished']){
                          case 'unfinished':
                            processIsFinished = '审核中';
                            break;
                          case 'finished':
                            processIsFinished = '已审核';
                            break;
                          case 'reject':
                            processIsFinished = '已驳回';
                            break;
                        }
                        return ExamineView(
                            data: examineList[index],
                            type: type,
                            onTap: () async{
                              String refresh = await Navigator.push(context, MaterialPageRoute(builder:(context)=> ExamineDetail(
                                processInsId: examineList[index]['processInstanceId'],
                                taskId: examineList[index]['taskId'],
                                type: type,
                                processIsFinished: processIsFinished,
                                status: examineList[index]['status']
                              )));
                              if(refresh != null && refresh == 'refresh') _controller.callRefresh();
                            }
                        );
                      }, childCount: examineList.length)
                  )
                ]
              )
            )
          ]
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFC68D3E),
        onPressed: () async{
          Map result = await showSelectProcessList(context);
          if(result != null){
            String refresh = await Navigator.push(context, MaterialPageRoute(builder:(context)=> ExamineAdd(
              name: result['name'],
              processId: result['id'],
            )));
            // String refresh = await Navigator.push(context, MaterialPageRoute(builder:(context)=> Webview(
            //   title: result['name'],
            //   id: result['id'],
            // )));
            if(refresh != null && refresh == 'refresh') _controller.callRefresh();
          }
        }
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

  ///审批申请列表
  Future<void> _downloadData() async {
    String url = Api.sendList;
    switch(type){
      case '我申请的':
        url = Api.sendList;
        break;
      case '我的待办':
        url = Api.todoList;
        break;
      case '我的已办':
        url = Api.myDoneList;
        break;
      case '知会我的':
        url = Api.copyList;
        break;
    }
    try {
      Map<String, dynamic> map = {'current': _current, 'size': _pageSize};
      final val = await requestGet(url, param: map);
      var data = jsonDecode(val.toString());
      LogUtil.d('请求结果---$url----$data');
      if (_current == 1) examineList.clear();
      final List<dynamic> list = data['data']['records'];
      if (type == '我的待办') mainProvider.setBadge(data['data']['total']);
      list.forEach((map) {
        examineList.add(map);
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