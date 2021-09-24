import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/widgets/add_text_input.dart';
import 'package:good_grandma/widgets/add_text_select.dart';
import 'package:good_grandma/widgets/select_tree.dart';

///新增市场物料
class MarketMaterialAdd extends StatefulWidget {
  final String id;
  MarketMaterialAdd({Key key, this.id}) : super(key: key);

  @override
  _MarketMaterialAddState createState() => _MarketMaterialAddState();
}

class _MarketMaterialAddState extends State<MarketMaterialAdd> {

  ///添加
  _materialAdd(){

    if (areaName == ''){
      showToast("区域不能为空");
      return;
    }

    if (name == ''){
      showToast("物料名称不能为空");
      return;
    }

    if (quantity == ''){
      showToast("物料总量不能为空");
      return;
    }

    if (inuse == ''){
      showToast("物料使用量不能为空");
      return;
    }

    if (loss == ''){
      showToast("物料损耗量不能为空");
      return;
    }

    Map<String, dynamic> map = {
      'id': widget.id,
      'deptId': deptId,
      'materialName': name,
      'quantity': quantity,
      'inuse': inuse,
      'loss': loss,
      'stock': double.parse(quantity) - double.parse(inuse) - double.parse(loss)
    };

    requestPost(Api.materialAdd, json: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---materialAdd----$data');
      if (data['code'] == 200){
        showToast("添加成功");
        Navigator.of(Application.appContext).pop();
      }else {
        showToast(data['msg']);
      }
    });
  }

  String title = '新增市场物料';
  String areaName = '';
  String deptId = '';
  String name = '';
  String quantity = '';
  String inuse = '';
  String loss = '';

  ///市场物料详情
  _materialDetail(){
    Map<String, dynamic> map = {'id': widget.id};
    requestGet(Api.materialDetail, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---materialDetail----$data');
      setState(() {
        deptId = data['data']['deptId'];
        areaName = data['data']['deptName'];
        name = data['data']['materialName'].isEmpty ? '请输入物料名称' : data['data']['materialName'];
        quantity = data['data']['quantity'].isEmpty ? '请输入物料总量' : data['data']['quantity'];
        inuse = data['data']['inuse'].isEmpty ? '请输入物料使用' : data['data']['inuse'];
        loss = data['data']['loss'].isEmpty ? '请输入物料耗损' : data['data']['loss'];

        controller_name.text = name;
        controller_quantity.text = quantity;
        controller_inuse.text = inuse;
        controller_loss.text = loss;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.id != ''){
      title = '编辑市场物料';
      _materialDetail();
    }
  }

  TextEditingController controller_name = new TextEditingController();
  TextEditingController controller_quantity = new TextEditingController();
  TextEditingController controller_inuse = new TextEditingController();
  TextEditingController controller_loss = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(title, style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextSelectView(
                leftTitle: '区域',
                rightPlaceholder: widget.id == '' ? '请选择区域' : areaName,
                value: areaName,
                onPressed: () async{
                  Map area = await showSelectTreeList(context, '');
                  setState(() {
                    areaName = area['areaName'];
                    deptId = area['deptId'];
                  });
                  return area['areaName'];
                }
              ),
              TextInputView(
                  rightLength: 120,
                  leftTitle: '物料',
                  controller: controller_name,
                  rightPlaceholder: '请输入物料名称',
                  onChanged: (tex){
                    name = tex;
                  }
              ),
              TextInputView(
                  rightLength: 120,
                  leftTitle: '物料总量',
                  controller: controller_quantity,
                  rightPlaceholder: '请输入物料总量',
                  type: TextInputType.number,
                  onChanged: (tex){
                    quantity = tex;
                  }
              ),
              TextInputView(
                  rightLength: 120,
                  leftTitle: '物料使用',
                  controller: controller_inuse,
                  rightPlaceholder: '请输入物料使用',
                  type: TextInputType.number,
                  onChanged: (tex){
                    inuse = tex;
                  }
              ),
              TextInputView(
                  rightLength: 120,
                  leftTitle: '物料耗损',
                  controller: controller_loss,
                  rightPlaceholder: '请输入物料耗损',
                  type: TextInputType.number,
                  onChanged: (tex){
                    loss = tex;
                  }
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: LoginBtn(
                  title: '提交',
                  onPressed: _materialAdd
                )
              )
            ]
          )
        )
      )
    );
  }
}
