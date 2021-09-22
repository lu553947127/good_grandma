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
    }

    if (name == ''){
      showToast("物料名称不能为空");
    }

    if (quantity == ''){
      showToast("物料总量不能为空");
    }

    if (inuse == ''){
      showToast("物料使用量不能为空");
    }

    if (loss == ''){
      showToast("物料损耗量不能为空");
    }

    Map<String, dynamic> map = {
      'areaName': areaName,
      'areaId': areaId,
      'provinceId': provinceId,
      'cityId': cityId,
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
  String areaId = '';
  String provinceId = '';
  String cityId = '';
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
        areaName = data['data']['areaId'];
        name = data['data']['materialName'].isEmpty ? '请输入物料名称' : data['data']['materialName'];
        quantity = data['data']['quantity'].isEmpty ? '请输入物料总量' : data['data']['quantity'];
        inuse = data['data']['inuse'].isEmpty ? '请输入物料使用' : data['data']['inuse'];
        loss = data['data']['loss'].isEmpty ? '请输入物料耗损' : data['data']['loss'];
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
                  Map area = await showSelectTreeList(context);
                  setState(() {
                    areaName = area['areaName'];
                    areaId = area['areaId'];
                    provinceId = area['provinceId'];
                    cityId = area['cityId'];
                  });
                  return area['areaName'];
                }
              ),
              TextInputView(
                  rightLength: 120,
                  leftTitle: '物料',
                  rightPlaceholder: widget.id == '' ? '请输入物料名称' : name,
                  onChanged: (tex){
                    name = tex;
                  }
              ),
              TextInputView(
                  rightLength: 120,
                  leftTitle: '物料总量',
                  rightPlaceholder: widget.id == '' ? '请输入物料总量' : quantity,
                  type: TextInputType.number,
                  onChanged: (tex){
                    quantity = tex;
                  }
              ),
              TextInputView(
                  rightLength: 120,
                  leftTitle: '物料使用',
                  rightPlaceholder: widget.id == '' ? '请输入物料使用' : inuse,
                  type: TextInputType.number,
                  onChanged: (tex){
                    inuse = tex;
                  }
              ),
              TextInputView(
                  rightLength: 120,
                  leftTitle: '物料耗损',
                  rightPlaceholder: '请输入物料耗损',
                  text: widget.id == '' ? '' : loss,
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
