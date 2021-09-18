import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/add_dealer_model.dart';
import 'package:good_grandma/models/employee_model.dart';
import 'package:good_grandma/pages/open_account/select_city_manager_page.dart';
import 'package:good_grandma/widgets/type_btn.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///开通经销商
class OpenDealerPage extends StatefulWidget {
  const OpenDealerPage({Key key, this.isSpecial = false}) : super(key: key);

  ///是否是特约经销商
  final bool isSpecial;
  @override
  _OpenDealerPageState createState() => _OpenDealerPageState();
}

class _OpenDealerPageState extends State<OpenDealerPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final AddDealerModel _model = Provider.of<AddDealerModel>(context);
    List<Map> list1 = _getList1(_model);
    List<Map> list2 = _getList2(_model);

    return WillPopScope(
      onWillPop: () => AppUtil.onWillPop(context),
      child: Scaffold(
        appBar: AppBar(title: const Text('开通经销商')),
        body: Scrollbar(
          child: CustomScrollView(
            slivers: [
              //类型
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                sliver: SliverToBoxAdapter(
                  child: _ChoseType(model: _model),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                Map map = list1[index];
                String title = map['title'];
                String value = map['value'];
                String hintText = map['hintText'];
                String end = map['end'];
                TextInputType keyBoardType = map['keyBoardType'];
                if (index == 7) {
                  //辖区级别
                  return _SelectAreaLevel(
                    title: title,
                    areaLevel: _model.areaLevel,
                    onTap: (areaLevel) => _model.setAreaLevel(areaLevel),
                  );
                }
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
                      }),
                );
              }, childCount: list2.length)),
              SliverToBoxAdapter(
                child: SubmitBtn(
                  title: '提  交',
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _list1OnTap(
      {BuildContext context,
      int index,
      AddDealerModel model,
      String hintText,
      TextInputType keyBoardType,
      String value}) async {
    if (index == 8) {
      //选择区域
      List<String> options = ['大区一', '大区2'];
      String result = await showPicker(options, context);
      if (result != null && result.isNotEmpty) model.setArea(result);
    } else if (index == 9) {
      //选择城市经理
      EmployeeModel result = await Navigator.push(
          context, MaterialPageRoute(builder: (_) => SelectCityManagerPage()));
      if (result != null) {
        model.setCityManager(result);
      }
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
              case 0: //公司名称
                model.setCorporateName(text);
                break;
              case 1: //营业执照号
                model.setLicenseNo(text);
                break;
              case 2: //法人姓名
                model.setLegalPerson(text);
                break;
              case 3: //法人身份证
                model.setCorporateIDCard(text);
                break;
              case 4: //开户银行
                model.setBankName(text);
                break;
              case 5: //银行账号
                model.setBankNo(text);
                break;
              case 6: //联系手机
                model.setPhone(text);
                break;
              case 10: //公司地址
                model.setAddress(text);
                break;
              case 11: //仓库地址
                model.setWarehouseAddress(text);
                break;
              case 12: //收货人
                model.setConsignee(text);
                break;
              case 13: //收货人手机
                model.setConsigneePhone(text);
                break;
            }
          });
    }
  }

  List<Map> _getList1(AddDealerModel _model) {
    List<Map> list1 = [
      {
        'title': '公司名称',
        'value': _model.corporateName,
        'hintText': '请填写公司名称',
        'keyBoardType': TextInputType.text,
        'end': ''
      },
      {
        'title': '营业执照号',
        'value': _model.licenseNo,
        'hintText': '请填写营业执照号',
        'keyBoardType': TextInputType.emailAddress,
        'end': ''
      },
      {
        'title': '法人姓名',
        'value': _model.legalPerson,
        'hintText': '请填写法人姓名',
        'keyBoardType': TextInputType.text,
        'end': ''
      },
      {
        'title': '法人身份证',
        'value': _model.corporateIDCard,
        'hintText': '请填写法人身份证',
        'keyBoardType': TextInputType.text,
        'end': ''
      },
      {
        'title': '开户银行',
        'value': _model.bankName,
        'hintText': '请填写开户银行',
        'keyBoardType': TextInputType.text,
        'end': ''
      },
      {
        'title': '银行账号',
        'value': _model.bankNo,
        'hintText': '请填写银行账号',
        'keyBoardType': TextInputType.emailAddress,
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
        'title': '辖区级别',
        'value': _model.areaLevel.toString(),
        'hintText': '',
        'keyBoardType': null,
        'end': ''
      },
      {
        'title': '所在区域',
        'value': _model.area,
        'hintText': '请选择所在区域',
        'keyBoardType': null,
        'end': '>'
      },
      {
        'title': '城市经理',
        'value': _model.cityManager.name,
        'hintText': '请选择城市经理',
        'keyBoardType': null,
        'end': '>'
      },
      {
        'title': '公司地址',
        'value': _model.address,
        'hintText': '请填写公司地址',
        'keyBoardType': TextInputType.text,
        'end': ''
      },
      {
        'title': '仓库地址',
        'value': _model.warehouseAddress,
        'hintText': '请填写仓库地址',
        'keyBoardType': TextInputType.text,
        'end': ''
      },
      {
        'title': '收货人',
        'value': _model.consignee,
        'hintText': '请填写收货人姓名',
        'keyBoardType': TextInputType.text,
        'end': ''
      },
      {
        'title': '收货人手机',
        'value': _model.consigneePhone,
        'hintText': '请填写收货人手机号码',
        'keyBoardType': TextInputType.phone,
        'end': ''
      },
    ];
    return list1;
  }

  List<Map> _getList2(AddDealerModel _model) {
    List<Map> list1 = [
      {
        'title': '登录账号',
        'value': _model.account,
        'hintText': '请填写登录账号',
        'end': ''
      },
      {'title': '登录密码', 'value': _model.pwd, 'hintText': '请填写登录密码', 'end': ''},
    ];
    return list1;
  }

  @override
  void dispose() {
    super.dispose();
    _editingController?.dispose();
    _focusNode?.dispose();
  }
}

///辖区级别cell
class _SelectAreaLevel extends StatelessWidget {
  const _SelectAreaLevel({
    Key key,
    @required this.title,
    @required this.areaLevel,
    @required this.onTap,
  }) : super(key: key);

  final String title;
  final int areaLevel;
  final Function(int areaLevel) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14.0),
              title: Row(
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: AppColors.FF2F4058,
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal)),
                  Spacer(),
                  TypeBtn(
                      isSelected: areaLevel == 1,
                      title: '市级',
                      onPressed: () {
                        if (areaLevel != 1 && onTap != null) onTap(1);
                      }),
                  TypeBtn(
                      isSelected: areaLevel == 2,
                      title: '区级',
                      onPressed: () {
                        if (areaLevel != 2 && onTap != null) onTap(2);
                      }),
                ],
              )),
          const Divider(
              color: AppColors.FFF4F5F8,
              thickness: 1,
              height: 1,
              indent: 15.0,
              endIndent: 15.0)
        ],
      ),
    );
  }
}

///顶部选择类别
class _ChoseType extends StatelessWidget {
  const _ChoseType({
    Key key,
    @required AddDealerModel model,
  })  : _model = model,
        super(key: key);

  final AddDealerModel _model;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('类型',
            style: TextStyle(color: AppColors.FF959EB1, fontSize: 12.0)),
        Spacer(),
        TypeBtn(
            isSelected: _model.type == 1,
            title: '企业',
            onPressed: () {
              if (_model.type != 1) _model.setType(1);
            }),
        TypeBtn(
            isSelected: _model.type == 2,
            title: '个体',
            onPressed: () {
              if (_model.type != 2) _model.setType(2);
            }),
        TypeBtn(
            isSelected: _model.type == 3,
            title: '自然人',
            onPressed: () {
              if (_model.type != 3) _model.setType(3);
            }),
      ],
    );
  }
}
