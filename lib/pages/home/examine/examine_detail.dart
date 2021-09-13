import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/pages/home/examine/examine_detail_content.dart';
import 'package:good_grandma/pages/home/examine/examine_detail_title.dart';
import 'package:good_grandma/pages/home/examine/examine_reject.dart';
import 'examine_adopt.dart';
import 'examine_detail_list.dart';

///审批详情
class ExamineDetail extends StatefulWidget {
  final String processInsId;
  final String taskId;
  final String type;
  final String processIsFinished;
  final String status;
  ExamineDetail({Key key
    , this.processInsId
    , this.taskId
    , this.type
    , this.processIsFinished
    , this.status
  }) : super(key: key);

  @override
  _ExamineDetailState createState() => _ExamineDetailState();
}

class _ExamineDetailState extends State<ExamineDetail> {
  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> map = {'processInsId': widget.processInsId, 'taskId': widget.taskId};

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('审批详情', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: FutureBuilder(
          future: requestGet(Api.processDetail, param: map),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              var data = jsonDecode(snapshot.data.toString());
              LogUtil.d('请求结果---processDetail----$data');

              ///获取基本信息详情数据
              var process = data['data']['process'];
              LogUtil.d('process----$process');

              LogUtil.d('variables----${process['variables']}');

              ///获取详情表单数据
              // var form = jsonDecode(data['data']['form']['allForm']);
              // LogUtil.d('form----$form');
              // List list = (form['column'] as List).cast();
              // LogUtil.d('list----$list');

              List taskFormList = [];
              if(data['data']['form']['taskForm'] != null)
                taskFormList = (data['data']['form']['taskForm'] as List).cast();
              LogUtil.d('taskFormList----$taskFormList');

              ///获取审核流程列表数据
              List<Map> flowList = (data['data']['flow'] as List).cast();

              ///删除无用数据
              for(int i=0; i < flowList.length; i++) {
                if (flowList[i]['historyActivityType'] == 'candidate'){
                  flowList.removeAt(i);
                }
              }

              for(int i=0; i < flowList.length; i++) {
                if (flowList[i]['historyActivityType'] == 'sequenceFlow'){
                  flowList.removeAt(i);
                }
              }

              for(int i=0; i < flowList.length; i++) {
                if (flowList[i]['user']['id'] == null){
                  flowList.removeAt(i);
                  LogUtil.d('flowList--user--$i');
                }
              }

              LogUtil.d('flowList----$flowList');

              return Stack(
                  children: [
                    CustomScrollView(
                      slivers: [
                        ExamineDetailTitle(
                          avatar: process['user']['avatar'],
                          title: process['processDefinitionName'],
                          time: '提交时间: ${process['createTime']}',
                          wait: '等待${flowList[0]['user']['name']}审批',
                          status: widget.processIsFinished == '审核中' ? '审核中' : '已审核',
                          type: widget.type,
                        ),
                        ExamineDetailContent(
                          taskFormList: taskFormList,
                          variables: process['variables'],
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            margin: EdgeInsets.only(top: 15.0, left: 15.0),
                            child: Text('审核流程', style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(height: 15),
                        ),
                        SliverList(
                            delegate: SliverChildBuilderDelegate((context, index) {
                              bool isLast = index == flowList.length - 1;
                              return ExamineDetailList(flow: flowList[index], isLast: isLast);
                            }, childCount: flowList.length)
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(height: 55),
                        ),
                      ],
                    ),
                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Offstage(
                            offstage: widget.type == '我审批的' ? false : widget.status == 'todo' ? false : true,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(2, 1), //x,y轴
                                          color: Colors.black.withOpacity(0.1), //投影颜色
                                          blurRadius: 1 //投影距离
                                      )
                                    ]),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        child: Column(
                                          children: [
                                            Image.asset('assets/images/icon_examine_reject.png', width: 15, height: 15),
                                            SizedBox(height: 3),
                                            Text('驳回', style: TextStyle(fontSize: 13, color: Color(0XFFDD0000)))
                                          ]
                                        ),
                                        onPressed: () async{
                                          String refresh2 = await Navigator.push(context, MaterialPageRoute(builder:(context)=> ExamineReject(
                                            process: process,
                                            type: widget.type,
                                            processIsFinished: widget.processIsFinished,
                                            processInsId: widget.processInsId,
                                            taskId: widget.taskId,
                                            wait: '等待${flowList[0]['user']['name']}审批',
                                          )));
                                          if(refresh2 != null) Navigator.pop(context,'refresh');
                                        },
                                      ),
                                      SizedBox(
                                        width: 0.5,
                                        height: 40,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(color: Color(0xFFC1C8D7)),
                                        ),
                                      ),
                                      TextButton(
                                          child: Column(
                                            children: [
                                              Image.asset('assets/images/icon_examine_adopt.png', width: 15, height: 15),
                                              SizedBox(height: 3),
                                              Text('通过', style: TextStyle(fontSize: 13, color: Color(0XFF12BD95)))
                                            ],
                                          ),
                                          onPressed: () async{
                                            String refresh2 = await Navigator.push(context, MaterialPageRoute(builder:(context)=> ExamineAdopt(
                                              process: process,
                                              type: widget.type,
                                              processIsFinished: widget.processIsFinished,
                                              processInsId: widget.processInsId,
                                              taskId: widget.taskId,
                                              wait: '等待${flowList[0]['user']['name']}审批',
                                            )));
                                            if(refresh2 != null) Navigator.pop(context,'refresh');
                                          }
                                      )
                                    ]
                                )
                            )
                        )
                    )
                  ]
              );
            }else {
              return Center(
                  child: CircularProgressIndicator()
              );
            }
          }
      )
    );
  }
}