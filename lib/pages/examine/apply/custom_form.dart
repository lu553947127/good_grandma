import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/examine/children_form/chuchaimingxi.dart';
import 'package:good_grandma/pages/examine/children_form/travel_schedule_apply.dart';
import 'package:good_grandma/pages/examine/children_form/zhifuduixiangxinxi.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/pages/examine/model/time_select_provider.dart';
import 'package:good_grandma/widgets/add_content_input.dart';
import 'package:good_grandma/widgets/photos_cell.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:good_grandma/widgets/select_form.dart';
import 'package:good_grandma/widgets/select_more_user.dart';
import 'package:good_grandma/widgets/select_tree.dart';
import 'package:good_grandma/widgets/time_select.dart';
import 'package:provider/provider.dart';

///自定义表单组件
class CustomFormView extends StatefulWidget {
  final String name;
  final String processId;
  final List list;
  final dynamic process;
  CustomFormView({Key key,
    this.name,
    this.processId,
    this.list,
    this.process
  }) : super(key: key);

  @override
  _CustomFormViewState createState() => _CustomFormViewState();
}

class _CustomFormViewState extends State<CustomFormView> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TimeSelectProvider timeSelectProvider = Provider.of<TimeSelectProvider>(context);

    String copyUser = widget.process['copyUser'];
    String copyUserName = widget.process['copyUserName'];

    if (copyUser.isNotEmpty){
      timeSelectProvider.addcopyUser(copyUser);
      timeSelectProvider.addcopyUserName(copyUserName);
    }

    DateTime now = new DateTime.now();
    String nowTime = '${now.year}-${now.month}-${now.day}';

    List<String> dataList = [];
    Map addData = new Map();
    addData['processId'] = widget.processId;

    for (Map map in widget.list) {
      dataList.add(map['prop']);
    }

    _childWidget(data){
      switch(data['type']){
        case 'date':
          addData[data['prop']] = nowTime;
          return PostAddInputCell(
              title: data['label'],
              value: nowTime,
              hintText: nowTime,
              endWidget: null,
              onTap: null
          );
          break;
        case 'input':
          if (data['label'] == '申请人'){
            return PostAddInputCell(
                title: data['label'],
                value: '${Store.readPostName()}${Store.readNickName()}',
                hintText: '${Store.readPostName()}${Store.readNickName()}',
                endWidget: null,
                onTap: null
            );
          }else if (data['prop'] == 'hejidaxie'){
            return Container();
          }else if (data['prop'] == 'hejixiaoxie'){
            return Container();
          }else if (data['prop'] == 'jiaotongjineheji'){
            return Container();
          }else if (data['prop'] == 'shineijiaotongheji'){
            return Container();
          }else if (data['prop'] == 'zhusujineheji'){
            return Container();
          }else if (data['prop'] == 'buzhujineheji'){
            return Container();
          }else if (data['prop'] == 'qitajineheji'){
            return Container();
          }else {
            String value = '';
            if (data['prop'] == 'chufadi'){
              value = timeSelectProvider.chufadi;
            }else if(data['prop'] == 'mudidi'){
              value = timeSelectProvider.mudidi;
            }else if(data['prop'] == 'chuchaishiyou'){
              value = timeSelectProvider.chuchaishiyou;
            }else if(data['prop'] == 'money'){
              value = timeSelectProvider.money;
            }else if(data['prop'] == 'nianduyusuan'){
              value = timeSelectProvider.nianduyusuan;
            }else if(data['prop'] == 'hexiaojine'){
              value = timeSelectProvider.hexiaojine;
            }
            return PostAddInputCell(
                title: data['label'],
                value: value,
                hintText: '请输入${data['label']}',
                endWidget: null,
                onTap: () => AppUtil.showInputDialog(
                    context: context,
                    editingController: _editingController,
                    focusNode: _focusNode,
                    text: value,
                    hintText: '请输入${data['label']}',
                    callBack: (text) {
                      for (String prop in dataList) {
                        if (data['prop'] == prop){
                          addData[prop] = text;
                        }

                        if (data['prop'] == 'chufadi'){
                          addData[prop] = text;
                          timeSelectProvider.addchufadi(text);
                        }

                        if (data['prop'] == 'mudidi'){
                          addData[prop] = text;
                          timeSelectProvider.addmudidi(text);
                        }

                        if (data['prop'] == 'chuchaishiyou'){
                          addData[prop] = text;
                          timeSelectProvider.addchuchaishiyou(text);
                        }

                        if (data['prop'] == 'money'){
                          addData[prop] = text;
                          timeSelectProvider.addmoney(text);
                        }

                        if (data['prop'] == 'nianduyusuan'){
                          addData[prop] = text;
                          timeSelectProvider.addnianduyusuan(text);
                        }

                        if (data['prop'] == 'hexiaojine'){
                          addData[prop] = text;
                          timeSelectProvider.addhexiaojine(text);
                        }
                      }
                    })
            );
          }
          break;
        case 'select':
          String value = '';
          if (data['prop'] == 'gongsi'){
            value = timeSelectProvider.gongsi;
          }else if(data['prop'] == 'feiyongshenqing'){
            value = timeSelectProvider.feiyongshenqing;
          }else if(data['prop'] == 'fylb'){
            value = timeSelectProvider.fylb;
          }else if(data['prop'] == 'type'){
            value = timeSelectProvider.type;
          }else {
            value = timeSelectProvider.value;
          }

          return PostAddInputCell(
            title: data['label'],
            value: value,
            hintText: '请选择${data['label']}',
            endWidget: Icon(Icons.chevron_right),
            onTap: () async {
              String select = '';
              if (data['dicData'] != null){
                List<Map> dicData = (data['dicData'] as List).cast();
                List<String> dicDataString = [];
                for (Map map in dicData) {
                  dicDataString.add(map['label']);
                }
                select = await showPicker(dicDataString, context);
              }else {
                select = await showSelect(context, data['dicUrl'], '请选择${data['label']}', data['props']);
              }

              for (String prop in dataList) {
                if (data['prop'] == prop){
                  addData[prop] = select;
                }

                if (data['prop'] == 'gongsi'){
                  timeSelectProvider.addgongsi(select);
                }else if (data['prop'] == 'feiyongshenqing'){
                  timeSelectProvider.addfeiyongshenqing(select);
                }else if (data['prop'] == 'fylb'){
                  timeSelectProvider.addfylb(select);
                }else if (data['prop'] == 'type'){
                  timeSelectProvider.addtype(select);
                }else {
                  timeSelectProvider.addValue2(select);
                }
              }
            }
          );
          break;
        case 'tree':
          return PostAddInputCell(
              title: data['label'],
              value: timeSelectProvider.bumenName,
              hintText: '请选择${data['label']}',
              endWidget: Icon(Icons.chevron_right),
              onTap: () async {
                Map area = await showSelectTreeList(context, '全国');
                timeSelectProvider.addbumen(area['deptId'], area['areaName']);
              }
          );
          break;
        case 'datetimerange':
          return TimeSelectView(
              leftTitle: data['label'],
              rightPlaceholder: '请选择${data['label']}',
              sizeHeight: 1,
              value: (timeSelectProvider.startTime.isNotEmpty && timeSelectProvider.endTime.isNotEmpty)
                  ? '${timeSelectProvider.startTime + '\n' + timeSelectProvider.endTime}'
                  : '',
              dayNumber: timeSelectProvider.dayNumber,
              isDays: true,
              onPressed: (param) {
                timeSelectProvider.addStartTime(param['startTime'], param['endTime'], param['days']);
                List<String> timeList = [];
                timeList.add(param['startTime']);
                timeList.add(param['endTime']);
                for (String prop in dataList) {
                  if (data['prop'] == prop){
                    addData[prop] = timeList;
                  }
                }
              }
          );
          break;
        case 'number':
          if (widget.name == '请假流程'){
            return Container();
          }else if (data['label'] == '出差天数'){
            return Container();
          }else {
            String value = '';
            if (data['prop'] == 'jine'){
              value = timeSelectProvider.jine;
            }
            return PostAddInputCell(
                title: data['label'],
                value: value,
                hintText: '请输入${data['label']}',
                endWidget: null,
                onTap: () => AppUtil.showInputDialog(
                    context: context,
                    editingController: _editingController,
                    focusNode: _focusNode,
                    text: value,
                    hintText: '请输入${data['label']}',
                    keyboardType: TextInputType.number,
                    callBack: (text) {
                      for (String prop in dataList) {
                        if (data['prop'] == prop){
                          addData[prop] = text;
                        }

                        if (data['prop'] == 'jine'){
                          addData[prop] = text;
                          timeSelectProvider.addjine(text);
                        }
                      }
                    })
            );
          }
          break;
        case 'textarea':
          return ContentInputView(
            color: Colors.white,
            leftTitle: data['label'],
            rightPlaceholder: '请输入${data['label']}',
            sizeHeight: 10,
            onChanged: (tex){
              for (String prop in dataList) {
                if (data['prop'] == prop){
                  addData[prop] = tex;
                }

                if (data['prop'] == 'xingchenganpai'){
                  addData[prop] = tex;
                  timeSelectProvider.addxingchenganpai(tex);
                }

                if (data['prop'] == 'yujidachengxiaoguo'){
                  addData[prop] = tex;
                  timeSelectProvider.addyujidachengxiaoguo(tex);
                }

                if (data['prop'] == 'zhuzhi'){
                  addData[prop] = tex;
                  timeSelectProvider.addzhuzhi(tex);
                }

                if (data['prop'] == 'shuoming'){
                  addData[prop] = tex;
                  timeSelectProvider.addshuoming(tex);
                }

                if (data['prop'] == 'purpose'){
                  addData[prop] = tex;
                  timeSelectProvider.addpurpose(tex);
                }

                if (data['prop'] == 'desc'){
                  addData[prop] = tex;
                  timeSelectProvider.adddesc(tex);
                }

                if (data['prop'] == 'reason'){
                  addData[prop] = tex;
                  timeSelectProvider.addreason(tex);
                }
              }
            }
          );
          break;
        case 'dynamic':
          if (data['prop'] == 'chuchairicheng'){
            return TravelScheduleFrom(
              data: data,
              timeSelectProvider: timeSelectProvider
            );
          }else if (data['prop'] == 'zhifuduixiangxinxi'){
            return zhifuduixiangxinxiFrom(
              data: data,
              timeSelectProvider: timeSelectProvider
            );
          }else if (data['prop'] == 'chuchaimingxi'){
            return chuchaimingxiForm(
                data: data,
                timeSelectProvider: timeSelectProvider
            );
          }else {
            return Container(
                child: Text('无法显示未知子表单')
            );
          }
          break;
        case 'upload':
          return OaPhotoWidget(
              title: data['label'],
              sizeHeight: 10,
              url: data['action'],
              timeSelectProvider: timeSelectProvider
          );
          break;
        default:
          return Container(
              child: Text('无法显示未知动态组件')
          );
          break;
      }
    }

    ///发起流程
    _startProcess(){
      timeSelectProvider.addValue(nowTime);

      for (Map map in widget.list) {
        if ('upload' == map['type']){
          if ('图片' == map['label']){
            if (timeSelectProvider.imagePath.length == 0){
              showToast('${map['label']}不能为空');
              return;
            }
            addData[map['prop']] = timeSelectProvider.imagePath;
          }else {
            if (timeSelectProvider.filePath.length == 0){
              showToast('${map['label']}不能为空');
              return;
            }
            addData[map['prop']] = timeSelectProvider.filePath;
          }
        }else if ('date' == map['type']){
          if (timeSelectProvider.select == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.select;
        }else if ('datetimerange' == map['type']){
          List<String> timeList = [];
          timeList.add(timeSelectProvider.startTime + ':00');
          timeList.add(timeSelectProvider.endTime + ':00');

          if (timeSelectProvider.startTime == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData['yujichuchairiqi'] = timeList;
          addData['days'] = timeSelectProvider.dayNumber;
        }else if ('dynamic' == map['type']){
          if ('chuchairicheng' == map['prop']){
            if (timeSelectProvider.travelScheduleMapList.length == 0){
              showToast('${map['label']}不能为空');
              return;
            }
            addData[map['prop']] = timeSelectProvider.travelScheduleMapList;
          }else if ('zhifuduixiangxinxi' == map['prop']){
            if (timeSelectProvider.zhifuduixiangxinxiMapList.length == 0){
              showToast('${map['label']}不能为空');
              return;
            }
            for (Map map in timeSelectProvider.zhifuduixiangxinxiMapList) {
              if (map['danweimingcheng'] == ''){
                showToast('单位名称不能为空');
                return;
              }
              if (map['zhanghao'] == ''){
                showToast('账号不能为空');
                return;
              }
              if (map['kaihuhangmingcheng'] == ''){
                showToast('开户行名称不能为空');
                return;
              }
              if (map['jine'] == ''){
                showToast('金额不能为空');
                return;
              }
              if (map['zhifufangshi'] == ''){
                showToast('支付方式不能为空');
                return;
              }
              if (map['beizhu'] == ''){
                showToast('备注不能为空');
                return;
              }
            }
            addData[map['prop']] = timeSelectProvider.zhifuduixiangxinxiMapList;
          }else if ('chuchaimingxi' == map['prop']){
            if (timeSelectProvider.chuchaimingxiMapList.length == 0){
              showToast('${map['label']}不能为空');
              return;
            }
            addData[map['prop']] = timeSelectProvider.chuchaimingxiMapList;
          }
        }else if ('select' == map['type']){
          addData[map['prop']] = timeSelectProvider.value;
        }

        if ('chufadi' == map['prop']){
          if (timeSelectProvider.chufadi == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.chufadi;
        }else if ('mudidi' == map['prop']){
          if (timeSelectProvider.mudidi == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.mudidi;
        }else if ('chuchaishiyou' == map['prop']){
          if (timeSelectProvider.chuchaishiyou == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.chuchaishiyou;
        }else if ('xingchenganpai' == map['prop']){
          if (timeSelectProvider.xingchenganpai == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.xingchenganpai;
        }else if ('yujidachengxiaoguo' == map['prop']){
          if (timeSelectProvider.yujidachengxiaoguo == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.yujidachengxiaoguo;
        }else if ('shenqingren' == map['prop']){
          addData[map['prop']] = '${Store.readPostName()}${Store.readNickName()}';
        }else if ('bumen' == map['prop']){
          if (timeSelectProvider.bumenName == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.bumenName;
        }else if ('shuoming' == map['prop']){
          if (timeSelectProvider.shuoming == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.shuoming;
        }else if ('zhuzhi' == map['prop']){
          if (timeSelectProvider.zhuzhi == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.zhuzhi;
        }else if ('purpose' == map['prop']){
          if (timeSelectProvider.purpose == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.purpose;
        }else if ('desc' == map['prop']){
          if (timeSelectProvider.desc == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.desc;
        }else if ('money' == map['prop']){
          if (timeSelectProvider.money == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.money;
        }else if ('feiyongshenqing' == map['prop']){
          if (timeSelectProvider.feiyongshenqing == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.feiyongshenqing;
        }else if ('fylb' == map['prop']){
          if (timeSelectProvider.fylb == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.fylb;
        }else if ('nianduyusuan' == map['prop']){
          if (timeSelectProvider.nianduyusuan == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.nianduyusuan;
        }else if ('type' == map['prop']){
          if (timeSelectProvider.type == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.type;
        }else if ('jine' == map['prop']){
          if (timeSelectProvider.jine == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.jine;
        }else if ('gongsi' == map['prop']){
          if (timeSelectProvider.gongsi == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.gongsi;
        }else if ('hexiaojine' == map['prop']){
          if (timeSelectProvider.hexiaojine == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.hexiaojine;
        }else if ('reason' == map['prop']){
          if (timeSelectProvider.reason == ''){
            showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.reason;
        }else if ('applyer' == map['prop']){
          addData[map['prop']] = '${Store.readPostName()}${Store.readNickName()}';
        }
      }

      addData['copyUser'] = timeSelectProvider.copyUser;

      LogUtil.d('addData----$addData');

      requestPost(Api.startProcess, json: addData).then((val) async{
        var data = json.decode(val.toString());
        LogUtil.d('请求结果---startProcess----$data');
        if (data['code'] == 200){
          showToast("添加成功");
          Navigator.of(Application.appContext).pop('refresh');
        }else {
          showToast(data['msg']);
        }
      });
    }

    return CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _childWidget(widget.list[index]);
              }, childCount: widget.list.length)
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 10.0),
              child: PostAddInputCell(
                  title: '抄送人',
                  value: timeSelectProvider.copyUserName,
                  hintText: '请选择抄送人',
                  endWidget: Icon(Icons.chevron_right),
                  onTap: () async {
                    Map area = await showMultiSelectList(context, timeSelectProvider, '请选择抄送人');
                    timeSelectProvider.addcopyUser(area['id']);
                    timeSelectProvider.addcopyUserName(area['name']);
                  }
              )
            )
          ),
          SliverToBoxAdapter(
              child: Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 30, left: 22, right: 22),
                  child: LoginBtn(
                      title: '提交',
                      onPressed: _startProcess
                  )
              )
          )
        ]
    );
  }

  @override
  void dispose() {
    super.dispose();
    _editingController?.dispose();
    _focusNode?.dispose();
  }
}
