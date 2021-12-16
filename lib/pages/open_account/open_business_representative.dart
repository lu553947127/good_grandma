import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/add_dealer_model.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/select_form.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///开通业务代表页面
class OpenBusinessRepresentative extends StatefulWidget {
  const OpenBusinessRepresentative({Key key}) : super(key: key);

  @override
  _OpenBusinessRepresentativeState createState() => _OpenBusinessRepresentativeState();
}

class _OpenBusinessRepresentativeState extends State<OpenBusinessRepresentative> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AddDealerModel _model = Provider.of<AddDealerModel>(context);
    List<Map> list1 = _getList1(_model);
    List<Map> list2 = _getList2(_model);
    return Scaffold(
      appBar: AppBar(title: Text('开通业务代表')),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  Map map = list1[index];
                  String title = map['title'];
                  String value = map['value'];
                  String hintText = map['hintText'];
                  String end = map['end'];
                  return PostAddInputCell(
                    title: title,
                    value: value,
                    hintText: hintText,
                    endWidget: end.isNotEmpty ? Icon(Icons.chevron_right) : null,
                      onTap: () async {
                        switch (index) {
                          case 0: //选择角色
                            Map select = await showSelectList(context, Api.roleCustomer, '请选择所属角色', 'roleName');
                            _model.setRole(select['id']);
                            _model.setRoleName(select['roleName']);
                            break;
                          case 1: //选择经销商
                            Map select = await showSelectList(context, Api.customerList, '请选择经销商名称', 'realName');
                            _model.setServiceCode(select['id']);
                            _model.setServiceCodeName(select['realName']);
                            break;
                          case 2://业务类型
                            String select = await showPicker(['公司代表', '经销商代表'], context);
                            switch(select){
                              case "公司代表":
                                _model.setywdbType('1');
                                break;
                              case "经销商代表":
                                _model.setywdbType('2');
                                break;
                            }
                            _model.setywdbTypeName(select);
                            break;
                          default: //输入框
                            AppUtil.showInputDialog(
                                context: context,
                                editingController: _editingController,
                                focusNode: _focusNode,
                                text: value,
                                hintText: hintText,
                                callBack: (text) {
                                  switch (index) {
                                    case 3: //手机
                                      _model.setPhone(text);
                                      break;
                                    case 4: //姓名
                                      _model.setJuridical(text);
                                      break;
                                  }
                                });
                            break;
                        }
                      }
                  );
                }, childCount: list1.length)),
            PostDetailGroupTitle(color: null, name: 'APP登录相关'),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  Map map = list2[index];
                  String title = map['title'];
                  String value = map['value'];
                  String hintText = map['hintText'];
                  String end = map['end'];
                  return PostAddInputCell(
                      title: title,
                      value: value,
                      hintText: hintText,
                      endWidget: end.isNotEmpty ? Icon(Icons.chevron_right) : null,
                      onTap: () => AppUtil.showInputDialog(
                          context: context,
                          editingController: _editingController,
                          focusNode: _focusNode,
                          text: value,
                          hintText: hintText,
                          callBack: (text) {
                            switch (index) {
                              case 0: //登录账号
                                _model.setAccount(text);
                                break;
                              case 1: //登录密码
                                _model.setPWD(text);
                                break;
                            }
                          })
                  );
                }, childCount: list2.length)),
            SliverToBoxAdapter(
                child: SubmitBtn(
                  title: '提  交',
                  onPressed: () => _openCustomer(context, _model),
                )
            )
          ]
        )
      )
    );
  }

  List<Map> _getList1(AddDealerModel _model) {
    List<Map> list1 = [
      {
        'title': '所属角色',
        'value': _model.roleName,
        'hintText': '请选择所属角色',
        'keyBoardType': null,
        'end': '>'
      },
      {
        'title': '经销商',
        'value': _model.serviceCodeName,
        'hintText': '请选择经销商',
        'keyBoardType': null,
        'end': '>'
      },
      {
        'title': '业务类型',
        'value': _model.ywdbTypeName,
        'hintText': '请选择业务类型',
        'keyBoardType': null,
        'end': '>'
      },
      {
        'title': '手机',
        'value': _model.phone,
        'hintText': '请填写手机',
        'keyBoardType': TextInputType.number,
        'end': ''
      },
      {
        'title': '姓名',
        'value': _model.juridical,
        'hintText': '请填写姓名',
        'keyBoardType': TextInputType.text,
        'end': ''
      }
    ];
    return list1;
  }

  List<Map> _getList2(AddDealerModel _model) {
    List<Map> list1 = [
      {'title': '登录账号', 'value': _model.account, 'hintText': '请填写登录账号', 'end': ''},
      {'title': '登录密码', 'value': _model.pwd, 'hintText': '请填写登录密码', 'end': ''}
    ];
    return list1;
  }

  ///开通账户
  void _openCustomer(BuildContext context, AddDealerModel model) async {

    if (model.role == ''){
      showToast("所属角色不能为空");
      return;
    }

    if (model.serviceCode == ''){
      showToast("经销商不能为空");
      return;
    }

    if (model.ywdbType == ''){
      showToast("业务类型不能为空");
      return;
    }

    if (model.phone == ''){
      showToast("手机不能为空");
      return;
    }

    if (model.juridical == ''){
      showToast("姓名不能为空");
      return;
    }

    if (model.account == ''){
      showToast("登录账户不能为空");
      return;
    }

    if (model.pwd == ''){
      showToast("登录密码不能为空");
      return;
    }

    Map<String, dynamic> map = {
      'postId': model.post,
      'serviceCode': model.serviceCode,
      'ywdbType': model.ywdbType,
      'roleId': model.role,
      'phone': model.phone,
      'juridical': model.juridical,
      'account': model.account,
      'password': model.pwd
    };

    requestPost(Api.openCustomer, json: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---openCustomer----$data');
      if (data['code'] == 200){
        showToast("添加成功");
        Navigator.of(Application.appContext).pop();
      }else {
        showToast(data['msg']);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _editingController?.dispose();
    _focusNode?.dispose();
  }
}
