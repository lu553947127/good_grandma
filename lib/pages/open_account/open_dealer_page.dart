import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/add_dealer_model.dart';
import 'package:good_grandma/provider/image_provider.dart';
import 'package:good_grandma/widgets/photos_cell.dart';
import 'package:good_grandma/widgets/select_form.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///开通经销商
class OpenDealerPage extends StatefulWidget {
  const OpenDealerPage({Key key}) : super(key: key);
  @override
  _OpenDealerPageState createState() => _OpenDealerPageState();
}

class _OpenDealerPageState extends State<OpenDealerPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _editingController = TextEditingController();
  ImagesProvider _imagesProvider = new ImagesProvider();
  ImagesProvider _imagesProvider2 = new ImagesProvider();

  @override
  Widget build(BuildContext context) {
    final AddDealerModel _model = Provider.of<AddDealerModel>(context);
    List<Map> list1 = _getList1(_model);
    if (_model.postCode == 'ejkh'){
      list1.removeWhere((map) => map['title'] == '经销商级别');
    }

    List<Map> list2 = _getList2(_model);
    return WillPopScope(
      onWillPop: () => AppUtil.onWillPop(context),
      child: Scaffold(
        appBar: AppBar(title: Text('开通${_model.postName}')),
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
                TextInputType keyBoardType = map['keyBoardType'];

                return PostAddInputCell(
                  title: title,
                  value: value,
                  hintText: hintText,
                  endWidget: end.isNotEmpty ? Icon(Icons.chevron_right) : null,
                  onTap: () => _list1OnTap(
                      context: context,
                      index: index,
                      model: _model,
                      hintText: hintText,
                      keyBoardType: keyBoardType,
                      value: value),
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
                child: ChangeNotifierProvider<ImagesProvider>.value(
                    value: _imagesProvider,
                    child:  CustomPhotoWidget(
                        title: '上传身份证照片',
                        length: 1,
                        sizeHeight: 10,
                        url: Api.putFile
                    )
                )
              ),
              SliverToBoxAdapter(
                child: ChangeNotifierProvider<ImagesProvider>.value(
                    value: _imagesProvider2,
                    child:  CustomPhotoWidget(
                        title: '上传营业执照',
                        length: 1,
                        sizeHeight: 1,
                        url: Api.putFile
                    )
                )
              ),
              SliverToBoxAdapter(
                child: SubmitBtn(
                  title: '提  交',
                  onPressed: () => _openCustomer(context, _model),
                )
              )
            ]
          )
        )
      )
    );
  }

  void _list1OnTap(
      {BuildContext context,
      int index,
      AddDealerModel model,
      String hintText,
      TextInputType keyBoardType,
      String value}) async {
    if (index == 0) {
      //选择城市经理
      Map<String, dynamic> map = {'type': model.postCode};
      Map select = await showSelectListParameter(context, Api.allCsjlUser, '请选择城市经理', 'realName', map);
      model.setServiceCode(select['id']);
      model.setServiceCodeName(select['realName']);
    } else if (index == 1) {
      //选择岗位
      if(model.serviceCode == ''){
        showToast("请先选择城市经理后，再选择岗位");
        return;
      }

      Map<String, dynamic> map = {'userId': model.serviceCode};
      Map select = await showSelectListParameter(context, Api.allPostUserId, '请选择岗位', 'postName', map);
      model.setDeptId(select['deptId']);
      model.setDeptIdName(select['postName']);
    } else if (index == 2) {
      //选择经销商性质
      Map select = await showSelectList(context, Api.natureType, '请选择经销商性质', 'dictValue');
      model.setNature(select['dictKey']);
      model.setNatureName(select['dictValue']);
    } else if (index == 10) {
      //选择角色
      Map select = await showSelectList(context, Api.roleCustomer, '请选择所属角色', 'roleName');
      model.setRole(select['id']);
      model.setRoleName(select['roleName']);
    } else if (index == 11) {
      //选择经销商级别
      Map select = await showSelectList(context, Api.customer_type, '请选择经销商级别', 'dictValue');
      model.setCustomerType(select['dictKey']);
      model.setCustomerTypeName(select['dictValue']);
    } else {
      AppUtil.showInputDialog(
          context: context,
          editingController: _editingController,
          focusNode: _focusNode,
          text: value,
          hintText: hintText,
          keyboardType: keyBoardType,
          callBack: (text) {
            switch (index) {
              case 3: //公司名称
                model.setCorporateName(text);
                break;
              case 4: //公司地址
                model.setAddress(text);
                break;
              case 5: //营业执照号
                model.setLicenseNo(text);
                break;
              case 6: //联系手机
                model.setPhone(text);
                break;
              case 7: //法人姓名
                model.setJuridical(text);
                break;
              case 8: //法人身份证
                model.setJuridicalId(text);
                break;
              case 9: //法人电话
                model.setJuridicalPhone(text);
                break;
              case 12: //开户银行
                model.setBank(text);
                break;
              case 13: //银行账号
                model.setBankAccount(text);
                break;
              case 14: //开户人
                model.setBankUser(text);
                break;
              case 15: //开户人身份证号
                model.setBankCard(text);
                break;
            }
          });
    }
  }

  List<Map> _getList1(AddDealerModel _model) {
    List<Map> list1 = [
      {
        'title': '上级经理/客户',
        'value': _model.serviceCodeName,
        'hintText': '请选择上级经理/客户',
        'keyBoardType': null,
        'end': '>'
      },
      {
        'title': '区域',
        'value': _model.deptIdName,
        'hintText': '请选择区域',
        'keyBoardType': null,
        'end': '>'
      },
      {
        'title': '经销商性质',
        'value': _model.natureName,
        'hintText': '请选择经销商性质',
        'keyBoardType': null,
        'end': '>'
      },
      {
        'title': '企业名称',
        'value': _model.corporateName,
        'hintText': '请填写企业名称',
        'keyBoardType': TextInputType.text,
        'end': ''
      },
      {
        'title': '企业地址',
        'value': _model.address,
        'hintText': '请填写企业地址',
        'keyBoardType': TextInputType.text,
        'end': ''
      },
      {
        'title': '营业执照号',
        'value': _model.licenseNo,
        'hintText': '请填写营业执照号',
        'keyBoardType': TextInputType.text,
        'end': ''
      },
      {
        'title': '联系手机',
        'value': _model.phone,
        'hintText': '请填写手机号码',
        'keyBoardType': TextInputType.phone,
        'end': ''
      },
      {
        'title': '法人姓名',
        'value': _model.juridical,
        'hintText': '请填写法人姓名',
        'keyBoardType': TextInputType.text,
        'end': ''
      },
      {
        'title': '法人身份证',
        'value': _model.juridicalId,
        'hintText': '请填写法人身份证',
        'keyBoardType': TextInputType.text,
        'end': ''
      },
      {
        'title': '法人电话',
        'value': _model.juridicalPhone,
        'hintText': '请填写法人电话',
        'keyBoardType': TextInputType.phone,
        'end': ''
      },
      {
        'title': '所属角色',
        'value': _model.roleName,
        'hintText': '请选择所属角色',
        'keyBoardType': null,
        'end': '>'
      },
      {
        'title': '经销商级别',
        'value': _model.customerTypeName,
        'hintText': '请选择经销商级别',
        'keyBoardType': null,
        'end': '>'
      },
      {
        'title': '开户银行',
        'value': _model.bank,
        'hintText': '请填写开户银行',
        'keyBoardType': TextInputType.text,
        'end': ''
      },
      {
        'title': '银行账号',
        'value': _model.bankAccount,
        'hintText': '请填写银行账号',
        'keyBoardType': TextInputType.phone,
        'end': ''
      },
      {
        'title': '开户人',
        'value': _model.bankUser,
        'hintText': '请填写开户人',
        'keyBoardType': TextInputType.text,
        'end': ''
      },
      {
        'title': '开户人身份证号',
        'value': _model.bankCard,
        'hintText': '请填写开户人身份证号',
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

    if (model.post.isEmpty){
      AppUtil.showToastCenter('经销商类型不能为空');
      return;
    }

    if (model.serviceCode.isEmpty){
      AppUtil.showToastCenter('城市经理不能为空');
      return;
    }

    if (model.deptId.isEmpty){
      AppUtil.showToastCenter('岗位不能为空');
      return;
    }

    if (model.nature.isEmpty){
      AppUtil.showToastCenter('经销商性质不能为空');
      return;
    }

    // if (model.corporateName == ''){
    //   showToast("公司名称不能为空");
    //   return;
    // }

    if (model.address == ''){
      showToast("公司地址不能为空");
      return;
    }

    // if (model.licenseNo == ''){
    //   showToast("营业执照号不能为空");
    //   return;
    // }

    // if (model.phone == ''){
    //   showToast("联系手机不能为空");
    //   return;
    // }

    // if (model.juridical == ''){
    //   showToast("法人姓名不能为空");
    //   return;
    // }

    // if (model.juridicalId == ''){
    //   showToast("法人身份证不能为空");
    //   return;
    // }
    //
    // if (model.juridicalPhone == ''){
    //   showToast("法人电话不能为空");
    //   return;
    // }

    if (model.role == ''){
      showToast("所属角色不能为空");
      return;
    }

    // if (model.customerType == ''){
    //   showToast("经销商级别不能为空");
    //   return;
    // }

    // if (model.bank == ''){
    //   showToast("开户银行不能为空");
    //   return;
    // }

    // if (model.bankAccount == ''){
    //   showToast("银行账号不能为空");
    //   return;
    // }
    //
    // if (model.bankUser == ''){
    //   showToast("开户人不能为空");
    //   return;
    // }
    //
    // if (model.bankCard == ''){
    //   showToast("开户人身份证号不能为空");
    //   return;
    // }

    if (model.account == ''){
      showToast("登录账户不能为空");
      return;
    }

    if (model.pwd == ''){
      showToast("登录密码不能为空");
      return;
    }

    if (_imagesProvider.urlList.length == 0){
      showToast("身份证照片不能为空");
      return;
    }

    model.setIdCardImage(listToString(_imagesProvider.urlList));

    if (_imagesProvider2.urlList.length == 0){
      showToast("营业执照不能为空");
      return;
    }

    model.setLicenseImage(listToString(_imagesProvider2.urlList));

    Map<String, dynamic> map = {
      'deptId': model.deptId,
      'serviceCode': model.serviceCode,
      'postId': model.post,
      'nature': model.nature,
      'corporate': model.corporateName,
      'address': model.address,
      'license': model.licenseNo,
      'phone': model.phone,
      'juridical': model.juridical,
      'juridicalId': model.juridicalId,
      'juridicalPhone': model.juridicalPhone,
      'roleId': model.role,
      'customerType': model.customerType,
      'bank': model.bank,
      'bankAccount': model.bankAccount,
      'bankUser': model.bankUser,
      'bankCard': model.bankCard,
      'account': model.account,
      'password': model.pwd,
      'idImg': model.idCardImage,
      'licenseImg': model.licenseImage
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
