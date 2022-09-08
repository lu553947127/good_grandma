import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/examine/children_form/activity_feiyong.dart';
import 'package:good_grandma/pages/examine/children_form/chuchaimingxi.dart';
import 'package:good_grandma/pages/examine/children_form/activity_shichipin.dart';
import 'package:good_grandma/pages/examine/children_form/travel_schedule_apply.dart';
import 'package:good_grandma/pages/examine/children_form/zhifuduixiangxinxi.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/pages/examine/model/time_select_provider.dart';
import 'package:good_grandma/pages/stock/select_customer_page.dart';
import 'package:good_grandma/widgets/activity_add_text_cell.dart';
import 'package:good_grandma/widgets/add_content_input.dart';
import 'package:good_grandma/widgets/photos_cell.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:good_grandma/widgets/select_form.dart';
import 'package:good_grandma/widgets/select_tree.dart';
import 'package:good_grandma/widgets/time_select.dart';
import 'package:provider/provider.dart';

///自定义表单组件
class CustomFormView extends StatefulWidget {
  final String name;
  final String processId;
  final List list;
  final List group;
  final dynamic process;
  CustomFormView({Key key,
    this.name,
    this.processId,
    this.list,
    this.group,
    this.process
  }) : super(key: key);

  @override
  _CustomFormViewState createState() => _CustomFormViewState();
}

class _CustomFormViewState extends State<CustomFormView> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _editingController = TextEditingController();
  bool isFirst = false;

  _initCopyUser(TimeSelectProvider timeSelectProvider){
    String copyUser = widget.process['copyUser'];
    String copyUserName = widget.process['copyUserName'];

    List<String> copyUserList = copyUser.split(',');
    List<String> copyUserNameList = copyUserName.split(',');
    if (copyUser.isNotEmpty){
      for(int i = 0; i < copyUserList.length; i++){
        Map addData = new Map();
        addData['id'] = copyUserList[i];
        addData['name'] = copyUserNameList[i];
        timeSelectProvider.userMapList.add(addData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TimeSelectProvider timeSelectProvider = Provider.of<TimeSelectProvider>(context);
    if (!isFirst){
      isFirst = true;
      _initCopyUser(timeSelectProvider);
    }

    DateTime now = new DateTime.now();
    String nowTime = '${now.year}-${now.month}-${now.day}';

    Map addData = new Map();
    addData['processId'] = widget.processId;

    ///自定义表单控件显示
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
                      if (data['prop'] == 'chufadi'){
                        timeSelectProvider.addchufadi(text);
                      } else if (data['prop'] == 'mudidi'){
                        timeSelectProvider.addmudidi(text);
                      } else if (data['prop'] == 'chuchaishiyou'){
                        timeSelectProvider.addchuchaishiyou(text);
                      } else if (data['prop'] == 'money'){
                        timeSelectProvider.addmoney(text);
                      } else if (data['prop'] == 'nianduyusuan'){
                        timeSelectProvider.addnianduyusuan(text);
                      } else if (data['prop'] == 'hexiaojine'){
                        timeSelectProvider.addhexiaojine(text);
                      }
                    })
            );
          }
          break;
        case 'select':
          String value = '';
          if (data['prop'] == 'gongsi'){
            value = timeSelectProvider.gongsi;
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

              if (data['prop'] == 'gongsi'){
                timeSelectProvider.addgongsi(select);
              }else if (data['prop'] == 'fylb'){
                timeSelectProvider.addfylb(select);
              }else if (data['prop'] == 'type'){
                timeSelectProvider.addtype(select);
              }else {
                timeSelectProvider.addValue2(select);
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
                      if (data['prop'] == 'jine'){
                        timeSelectProvider.addjine(text);
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
              if (data['prop'] == 'xingchenganpai'){
                timeSelectProvider.addxingchenganpai(tex);
              } else if (data['prop'] == 'yujidachengxiaoguo'){
                timeSelectProvider.addyujidachengxiaoguo(tex);
              } else if (data['prop'] == 'zhuzhi'){
                timeSelectProvider.addzhuzhi(tex);
              } else if (data['prop'] == 'shuoming'){
                timeSelectProvider.addshuoming(tex);
              } else if (data['prop'] == 'purpose'){
                timeSelectProvider.addpurpose(tex);
              } else if (data['prop'] == 'desc'){
                timeSelectProvider.adddesc(tex);
              } else if (data['prop'] == 'reason'){
                timeSelectProvider.addreason(tex);
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
          if(data['component'] == 'wf-apply-select'){
            return Column(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 10.0),
                    height: 60,
                    color: Colors.white,
                    child: ListTile(
                      title: Text('请选择${data['label']}', style: TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                      trailing: IconButton(
                          onPressed: () async {
                            Map select = await showSelectCostList(context, Api.feeApplyPage, '请选择${data['label']}', 'id', data['params']['type']);
                            timeSelectProvider.addCostStringModel(select['id']);
                          },
                          icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
                    )
                ),
                ListView.builder(
                    shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                    physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                    itemCount: timeSelectProvider.costStringList.length,
                    itemBuilder: (context, index){
                      String str = timeSelectProvider.costStringList[index];
                      return Column(
                          children: [
                            SizedBox(height: 1),
                            ActivityAddTextCell(
                                title: str,
                                hintText: '',
                                value: '',
                                trailing: IconButton(
                                    onPressed: (){
                                      timeSelectProvider.deleteCostStringModelWith(index);
                                    },
                                    icon: Icon(Icons.delete, color: AppColors.FFDD0000)
                                ),
                                onTap: null
                            )
                          ]
                      );
                    }
                )
              ]
            );
          }else if (data['component'] == 'wf-upload'){
            return OaPhotoWidget(
                title: data['label'],
                sizeHeight: 10,
                url: data['action'],
                timeSelectProvider: timeSelectProvider
            );
          }else{
            return Container(
                child: Text('无法显示未知动态组件')
            );
          }
          break;
      }
    }

    ///市场活动自定义表单控件显示
    _activityChildWidget(data){
      switch(data['type']){
        case 'input':
          String value = '';
          TextInputType keyboardType;
          if (data['prop'] == 'name'){
            value = timeSelectProvider.name;
            keyboardType = TextInputType.text;
          }else if(data['prop'] == 'address'){
            value = timeSelectProvider.address;
            keyboardType = TextInputType.text;
          }else if(data['prop'] == 'phone'){
            value = timeSelectProvider.phone;
            keyboardType = TextInputType.number;
          }else if(data['prop'] == 'sketch'){
            value = timeSelectProvider.sketch;
            keyboardType = TextInputType.text;
          }else if(data['prop'] == 'costtotal'){
            value = timeSelectProvider.costtotal;
            keyboardType = TextInputType.number;
          }else if(data['prop'] == 'purchasemoney'){
            value = timeSelectProvider.purchasemoney;
            keyboardType = TextInputType.number;
          }else if(data['prop'] == 'purchaseratio'){
            value = timeSelectProvider.purchaseratio;
            keyboardType = TextInputType.number;
          }
          if (data['prop'] == 'deptName'){
            return Container();
          }else if (data['prop'] == 'customerName'){
            return Container();
          }else {
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
                    keyboardType: keyboardType,
                    hintText: '请输入${data['label']}',
                    callBack: (text) {
                      if (data['prop'] == 'name') {
                        timeSelectProvider.addName(text);
                      } else if (data['prop'] == 'address') {
                        timeSelectProvider.addAddress(text);
                      } else if (data['prop'] == 'phone') {
                        timeSelectProvider.addPhone(text);
                      } else if (data['prop'] == 'sketch') {
                        timeSelectProvider.addSketch(text);
                      } else if (data['prop'] == 'costtotal') {
                        timeSelectProvider.addCosttotal(text);
                      } else if (data['prop'] == 'purchasemoney') {
                        timeSelectProvider.addPurchasemoney(text);
                        timeSelectProvider.addPurchaseratio('${formatNum(((double.parse(timeSelectProvider.costtotal) / double.parse(text) * 100)), 2)}');
                      } else if (data['prop'] == 'purchaseratio') {
                        timeSelectProvider.addPurchaseratio(text);
                      }
                    })
            );
          }
          break;
        case 'tree':
          String value = '';
          if (data['prop'] == 'deptId'){
            value = timeSelectProvider.deptName;
          }else if (data['prop'] == 'customerId'){
            value = timeSelectProvider.customerName;
          }
          return PostAddInputCell(
              title: data['label'],
              value: value,
              hintText: '请选择${data['label']}',
              endWidget: Icon(Icons.chevron_right),
              onTap: () async {
                if (data['prop'] == 'deptId'){
                  Map area = await showSelectTreeList(context, '');
                  timeSelectProvider.addDeptId(area['deptId']);
                  timeSelectProvider.addDeptName(area['areaName']);
                }else if(data['prop'] == 'customerId'){
                  if(timeSelectProvider.deptId == ''){
                    showToast("请先选择区域，再选择客户");
                    return;
                  }
                  Map<String, dynamic> map = {'deptId': timeSelectProvider.deptId};
                  Map select = await showSelectListParameter(context, Api.deptIdUser, '请选择客户', 'corporateName', map);
                  timeSelectProvider.addCustomerId(select['id']);
                  timeSelectProvider.addCustomerName(select['corporateName']);
                  timeSelectProvider.addAddress(select['address']);
                }
              }
          );
          break;
        case 'datetime':
          String value = '';
          if (data['prop'] == 'starttime'){
            value = timeSelectProvider.starttime;
          }else if (data['prop'] == 'endtime'){
            value = timeSelectProvider.endtime;
          }
          return PostAddInputCell(
              title: data['label'],
              value: value,
              hintText: '请选择${data['label']}',
              endWidget: Icon(Icons.chevron_right),
              onTap: () async {
                String select = await showPickerDate(context);
                if (data['prop'] == 'starttime'){
                  timeSelectProvider.addStarttime(select);
                }else if(data['prop'] == 'endtime'){
                  timeSelectProvider.addEndtime(select);
                }
              }
          );
          break;
        case 'dynamic':
          if (data['prop'] == 'activityCosts'){
            return shichipinFrom(
                data: data,
                timeSelectProvider: timeSelectProvider
            );
          }else if (data['prop'] == 'activityCostList'){
            return feiyongFrom(
                data: data,
                timeSelectProvider: timeSelectProvider
            );
          }else {
            return Container(
                child: Text('无法显示未知子表单')
            );
          }
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
      ///日期
      timeSelectProvider.addValue(nowTime);

      ///基本数据
      for (Map map in widget.list) {
        if ('upload' == map['type']){
          if ('图片' == map['label']){
            if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.imagePath.length == 0){
              EasyLoading.showToast('${map['label']}不能为空');
              return;
            }
            addData[map['prop']] = timeSelectProvider.imagePath;
          }else {
            if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.filePath.length == 0){
              EasyLoading.showToast('${map['label']}不能为空');
              return;
            }
            addData[map['prop']] = timeSelectProvider.filePath;
          }
        }else if ('wf-upload' == map['component']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.filePath.length == 0){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.filePath;
        }else if ('date' == map['type']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.select == ''){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.select;
        }else if ('datetimerange' == map['type']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.startTime == ''){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          List<String> timeList = [];
          timeList.add(timeSelectProvider.startTime + ':00');
          timeList.add(timeSelectProvider.endTime + ':00');
          addData['yujichuchairiqi'] = timeList;
          addData['days'] = timeSelectProvider.dayNumber;
        }else if ('dynamic' == map['type']){
          if ('chuchairicheng' == map['prop']){
            if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.travelScheduleMapList.length == 0){
              EasyLoading.showToast('${map['label']}不能为空');
              return;
            }
            for (Map map in timeSelectProvider.travelScheduleMapList) {
              if ((map['rules'] != null && map['rules'].length > 0) && map['chufadi'] == ''){
                EasyLoading.showToast('出发地不能为空');
                return;
              }
              if ((map['rules'] != null && map['rules'].length > 0) && map['mudidi'] == ''){
                EasyLoading.showToast('目的地不能为空');
                return;
              }
              if ((map['rules'] != null && map['rules'].length > 0) && map['yujichuchairiqi'] == ''){
                EasyLoading.showToast('预计出差日期不能为空');
                return;
              }
            }
            addData[map['prop']] = timeSelectProvider.travelScheduleMapList;
          }else if ('zhifuduixiangxinxi' == map['prop']){
            if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.zhifuduixiangxinxiMapList.length == 0){
              EasyLoading.showToast('${map['label']}不能为空');
              return;
            }
            for (Map map in timeSelectProvider.zhifuduixiangxinxiMapList) {
              if ((map['rules'] != null && map['rules'].length > 0) && map['danweimingcheng'] == ''){
                EasyLoading.showToast('单位名称不能为空');
                return;
              }
              if ((map['rules'] != null && map['rules'].length > 0) && map['zhanghao'] == ''){
                EasyLoading.showToast('账号不能为空');
                return;
              }
              if ((map['rules'] != null && map['rules'].length > 0) && map['kaihuhangmingcheng'] == ''){
                EasyLoading.showToast('开户行名称不能为空');
                return;
              }
              if ((map['rules'] != null && map['rules'].length > 0) && map['jine'] == ''){
                EasyLoading.showToast('金额不能为空');
                return;
              }
              if ((map['rules'] != null && map['rules'].length > 0) && map['zhifufangshi'] == ''){
                EasyLoading.showToast('支付方式不能为空');
                return;
              }
              if ((map['rules'] != null && map['rules'].length > 0) && map['beizhu'] == ''){
                EasyLoading.showToast('备注不能为空');
                return;
              }
            }
            addData[map['prop']] = timeSelectProvider.zhifuduixiangxinxiMapList;
          }else if ('chuchaimingxi' == map['prop']){
            if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.chuchaimingxiMapList.length == 0){
              EasyLoading.showToast('${map['label']}不能为空');
              return;
            }
            for (Map map in timeSelectProvider.chuchaimingxiMapList) {
              if ((map['rules'] != null && map['rules'].length > 0) && map['qizhishijian'] == ''){
                EasyLoading.showToast('起止时间不能为空');
                return;
              }
              if ((map['rules'] != null && map['rules'].length > 0) && map['qizhididian'] == ''){
                EasyLoading.showToast('起止地点不能为空');
                return;
              }
              if ((map['rules'] != null && map['rules'].length > 0) && map['chuchaimudi'] == ''){
                EasyLoading.showToast('出差目的地不能为空');
                return;
              }
              if ((map['rules'] != null && map['rules'].length > 0) && map['jiaotongjine'] == ''){
                EasyLoading.showToast('交通金额不能为空');
                return;
              }
              if ((map['rules'] != null && map['rules'].length > 0) && map['shineijiaotong'] == ''){
                EasyLoading.showToast('市内交通不能为空');
                return;
              }
              if ((map['rules'] != null && map['rules'].length > 0) && map['zhusujine'] == ''){
                EasyLoading.showToast('住宿金额不能为空');
                return;
              }
              if ((map['rules'] != null && map['rules'].length > 0) && map['buzhujine'] == ''){
                EasyLoading.showToast('备注金额不能为空');
                return;
              }
              if ((map['rules'] != null && map['rules'].length > 0) && map['qitajine'] == ''){
                EasyLoading.showToast('其他金额不能为空');
                return;
              }
              if ((map['rules'] != null && map['rules'].length > 0) && map['beizhu'] == ''){
                EasyLoading.showToast('备注不能为空');
                return;
              }
            }
            addData[map['prop']] = timeSelectProvider.chuchaimingxiMapList;
          }
        }else if ('select' == map['type']){
          addData[map['prop']] = timeSelectProvider.value;
        }

        if ('chufadi' == map['prop']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.chufadi == ''){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.chufadi;
        }else if ('mudidi' == map['prop']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.mudidi == ''){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.mudidi;
        }else if ('chuchaishiyou' == map['prop']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.chuchaishiyou == ''){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.chuchaishiyou;
        }else if ('xingchenganpai' == map['prop']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.xingchenganpai == ''){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.xingchenganpai;
        }else if ('yujidachengxiaoguo' == map['prop']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.yujidachengxiaoguo == ''){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.yujidachengxiaoguo;
        }else if ('shenqingren' == map['prop']){
          addData[map['prop']] = '${Store.readPostName()}${Store.readNickName()}';
        }else if ('bumen' == map['prop']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.bumenName == ''){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.bumenName;
        }else if ('shuoming' == map['prop']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.shuoming == ''){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.shuoming;
        }else if ('zhuzhi' == map['prop']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.zhuzhi == ''){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.zhuzhi;
        }else if ('purpose' == map['prop']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.purpose == ''){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.purpose;
        }else if ('desc' == map['prop']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.desc == ''){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.desc;
        }else if ('money' == map['prop']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.money == ''){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.money;
        }else if ('feiyongshenqing' == map['prop']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.costStringList.isEmpty){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = listToString(timeSelectProvider.costStringList);
        }else if ('fylb' == map['prop']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.fylb == ''){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.fylb;
        }else if ('nianduyusuan' == map['prop']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.nianduyusuan == ''){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.nianduyusuan;
        }else if ('type' == map['prop']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.type == ''){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.type;
        }else if ('jine' == map['prop']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.jine == ''){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.jine;
        }else if ('gongsi' == map['prop']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.gongsi == ''){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.gongsi;
        }else if ('hexiaojine' == map['prop']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.hexiaojine == ''){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.hexiaojine;
        }else if ('reason' == map['prop']){
          if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.reason == ''){
            EasyLoading.showToast('${map['label']}不能为空');
            return;
          }
          addData[map['prop']] = timeSelectProvider.reason;
        }else if ('applyer' == map['prop']){
          addData[map['prop']] = '${Store.readPostName()}${Store.readNickName()}';
        }
      }

      ///活动数据保存
      if (timeSelectProvider.type == '活动申请费用'){
        for (Map map in widget.group) {
          if (map['prop'] == 'name'){
            if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.name == ''){
              EasyLoading.showToast('${map['label']}不能为空');
              return;
            }
            addData[map['prop']] = timeSelectProvider.name;
          }else if (map['prop'] == 'deptId'){
            if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.deptId == ''){
              EasyLoading.showToast('${map['label']}不能为空');
              return;
            }
            addData[map['prop']] = timeSelectProvider.deptId;
            addData['deptName'] = timeSelectProvider.deptName;
          }else if (map['prop'] == 'customerId'){
            if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.customerId == ''){
              EasyLoading.showToast('${map['label']}不能为空');
              return;
            }
            addData[map['prop']] = timeSelectProvider.customerId;
            addData['customerName'] = timeSelectProvider.customerName;
          }else if (map['prop'] == 'address'){
            if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.address == ''){
              EasyLoading.showToast('${map['label']}不能为空');
              return;
            }
            addData[map['prop']] = timeSelectProvider.address;
          }else if (map['prop'] == 'starttime'){
            if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.starttime == ''){
              EasyLoading.showToast('${map['label']}不能为空');
              return;
            }
            addData[map['prop']] = timeSelectProvider.starttime;
          }else if (map['prop'] == 'endtime'){
            if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.endtime == ''){
              EasyLoading.showToast('${map['label']}不能为空');
              return;
            }
            addData[map['prop']] = timeSelectProvider.endtime;
          }else if (map['prop'] == 'phone'){
            if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.phone == ''){
              EasyLoading.showToast('${map['label']}不能为空');
              return;
            }
            addData[map['prop']] = timeSelectProvider.phone;
          }else if (map['prop'] == 'sketch'){
            if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.sketch == ''){
              EasyLoading.showToast('${map['label']}不能为空');
              return;
            }
            addData[map['prop']] = timeSelectProvider.sketch;
          }else if (map['prop'] == 'activityCosts'){
            if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.sampleMapList.length == 0){
              EasyLoading.showToast('${map['label']}不能为空');
              return;
            }
            for (Map map in timeSelectProvider.sampleMapList) {
              if ((map['rules'] != null && map['rules'].length > 0) && map['materialId'] == ''){
                EasyLoading.showToast('${map['label']}不能为空');
                return;
              }
              if ((map['rules'] != null && map['rules'].length > 0) && map['sample'] == 0){
                EasyLoading.showToast('${map['label']}不能为空');
                return;
              }
              if ((map['rules'] != null && map['rules'].length > 0) && map['withGoods'] == 0){
                EasyLoading.showToast('${map['label']}不能为空');
                return;
              }
            }
            addData[map['prop']] = timeSelectProvider.sampleMapList;
          }else if (map['prop'] == 'activityCostList'){
            if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.costMapList.length == 0){
              EasyLoading.showToast('${map['label']}不能为空');
              return;
            }
            for (Map map in timeSelectProvider.costMapList) {
              if ((map['rules'] != null && map['rules'].length > 0) && map['costType'] == ''){
                EasyLoading.showToast('${map['label']}不能为空');
                return;
              }
              if ((map['rules'] != null && map['rules'].length > 0) && map['costDescribe'] == ''){
                EasyLoading.showToast('${map['label']}不能为空');
                return;
              }
              if ((map['rules'] != null && map['rules'].length > 0) && map['costCash'] == 0){
                EasyLoading.showToast('${map['label']}不能为空');
                return;
              }
            }
            addData[map['prop']] = timeSelectProvider.costMapList;
          }else if (map['prop'] == 'costtotal'){
            if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.costtotal == ''){
              EasyLoading.showToast('${map['label']}不能为空');
              return;
            }
            addData[map['prop']] = timeSelectProvider.costtotal;
          }else if (map['prop'] == 'purchasemoney'){
            if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.purchasemoney == ''){
              EasyLoading.showToast('${map['label']}不能为空');
              return;
            }
            addData[map['prop']] = timeSelectProvider.purchasemoney;
          }else if (map['prop'] == 'purchaseratio'){
            if ((map['rules'] != null && map['rules'].length > 0) && timeSelectProvider.purchaseratio == ''){
              EasyLoading.showToast('${map['label']}不能为空');
              return;
            }
            addData[map['prop']] = timeSelectProvider.purchaseratio;
          }
        }
      }

      ///抄送人数据添加
      List<String> idList = [];
      timeSelectProvider.userMapList.forEach((element) {
        idList.add(element['id']);
      });
      addData['copyUser'] = listToString(idList);

      LogUtil.d('addData----$addData');

      requestPost(Api.startProcess, json: addData).then((val) async{
        var data = json.decode(val.toString());
        LogUtil.d('请求结果---startProcess----$data');
        if (data['code'] == 200){
          EasyLoading.showToast("添加成功");
          Navigator.of(Application.appContext).pop('refresh');
        }else {
          EasyLoading.showToast(data['msg']);
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
          SliverVisibility(
            visible: timeSelectProvider.type == '活动申请费用',
            sliver: SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(top: 10.0),
                child: PostAddInputCellCore(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 6),
                  title: '活动',
                  value: '',
                  hintText: '',
                  endWidget: null,
                  end: '',
                  fontSize: 18.0,
                  titleColor: AppColors.FF070E28,
                )
              )
            )
          ),
          SliverVisibility(
            visible: timeSelectProvider.type == '活动申请费用',
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return _activityChildWidget(widget.group[index]);
                }, childCount: widget.group.length)
            )
          ),
          SliverToBoxAdapter(
              child: Container(
                  margin: EdgeInsets.only(top: 10.0),
                  height: 60,
                  color: Colors.white,
                  child: ListTile(
                    title: Text('请选择抄送人', style: TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                    trailing: IconButton(
                        onPressed: () async {
                          Map select = await showSelectUserList(context, Api.sendSelectUser, '请选择抄送人', 'corporateName');
                          timeSelectProvider.addUserModel(select['id'], select['name']);
                        },
                        icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
                  )
              )
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                Map userMap = timeSelectProvider.userMapList[index];
                return Column(
                    children: [
                      SizedBox(height: 1),
                      ActivityAddTextCell(
                          title: userMap['name'],
                          hintText: '',
                          value: '',
                          trailing: IconButton(
                              onPressed: (){
                                timeSelectProvider.deleteUserModelWith(index);
                              },
                              icon: Icon(Icons.delete, color: AppColors.FFDD0000)
                          ),
                          onTap: null
                      )
                    ]
                );
              }, childCount: timeSelectProvider.userMapList.length)),
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
