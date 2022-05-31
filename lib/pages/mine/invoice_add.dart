import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:good_grandma/widgets/submit_btn.dart';

///发票添加
class InvoiceAddPage extends StatefulWidget {
  final String userId;
  final dynamic data;
  const InvoiceAddPage({Key key, this.userId, this.data}) : super(key: key);

  @override
  State<InvoiceAddPage> createState() => _InvoiceAddPageState();
}

class _InvoiceAddPageState extends State<InvoiceAddPage> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String titleType = '';
  String title = '';
  String taxNo = '';
  String userName = '';
  String phone = '';
  String address = '';
  String bank = '';
  String card = '';

  @override
  void initState() {
    super.initState();
    if (widget.data != null){
      titleType = widget.data['titleType'];
      title = widget.data['title'];
      taxNo = widget.data['taxNo'];
      userName = widget.data['userName'];
      phone = widget.data['phone'];
      address = widget.data['address'];
      bank = widget.data['bank'];
      card = widget.data['card'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('新增发票')),
        body: SingleChildScrollView(
          child: Column(
              children: [
                PostAddInputCell(
                    title: '抬头类型',
                    value: titleType,
                    hintText: '请选择抬头类型',
                    endWidget: Icon(Icons.chevron_right),
                    onTap: () async {
                      String select = await showPicker(['个人', '企业'], context);
                      titleType = select;
                      setState(() {});
                    }
                ),
                PostAddInputCell(
                    title: '抬头名称',
                    value: title,
                    hintText: '请输入抬头名称',
                    endWidget: Icon(Icons.chevron_right),
                    onTap: () => AppUtil.showInputDialog(
                        context: context,
                        editingController: _editingController,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.text,
                        text: title,
                        hintText: '请输入抬头名称',
                        callBack: (text) {
                          title = text;
                          setState(() {});
                        })
                ),
                PostAddInputCell(
                    title: '税号',
                    value: taxNo,
                    hintText: '请输入税号',
                    endWidget: Icon(Icons.chevron_right),
                    onTap: () => AppUtil.showInputDialog(
                        context: context,
                        editingController: _editingController,
                        focusNode: _focusNode,
                        text: taxNo,
                        hintText: '请输入税号',
                        callBack: (text) {
                          taxNo = text;
                          setState(() {});
                        })
                ),
                PostAddInputCell(
                    title: '收票人姓名',
                    value: userName,
                    hintText: '请输入收票人姓名',
                    endWidget: Icon(Icons.chevron_right),
                    onTap: () => AppUtil.showInputDialog(
                        context: context,
                        editingController: _editingController,
                        focusNode: _focusNode,
                        text: userName,
                        hintText: '请输入收票人姓名',
                        callBack: (text) {
                          userName = text;
                          setState(() {});
                        })
                ),
                PostAddInputCell(
                    title: '收票人电话',
                    value: phone,
                    hintText: '请输入收票人电话',
                    endWidget: Icon(Icons.chevron_right),
                    onTap: () => AppUtil.showInputDialog(
                        context: context,
                        editingController: _editingController,
                        focusNode: _focusNode,
                        text: phone,
                        hintText: '请输入收票人电话',
                        callBack: (text) {
                          phone = text;
                          setState(() {});
                        })
                ),
                PostAddInputCell(
                    title: '收票人地址',
                    value: address,
                    hintText: '请输入收票人地址',
                    endWidget: Icon(Icons.chevron_right),
                    onTap: () => AppUtil.showInputDialog(
                        context: context,
                        editingController: _editingController,
                        focusNode: _focusNode,
                        text: address,
                        hintText: '请输入收票人地址',
                        callBack: (text) {
                          address = text;
                          setState(() {});
                        })
                ),
                PostAddInputCell(
                    title: '开户行',
                    value: bank,
                    hintText: '请输入开户行',
                    endWidget: Icon(Icons.chevron_right),
                    onTap: () => AppUtil.showInputDialog(
                        context: context,
                        editingController: _editingController,
                        focusNode: _focusNode,
                        text: bank,
                        hintText: '请输入开户行',
                        callBack: (text) {
                          bank = text;
                          setState(() {});
                        })
                ),
                PostAddInputCell(
                    title: '开户行账号',
                    value: card,
                    hintText: '请输入开户行账号',
                    endWidget: Icon(Icons.chevron_right),
                    onTap: () => AppUtil.showInputDialog(
                        context: context,
                        editingController: _editingController,
                        focusNode: _focusNode,
                        text: card,
                        hintText: '请输入开户行账号',
                        callBack: (text) {
                          card = text;
                          setState(() {});
                        })
                ),
                SubmitBtn(title: '提  交', onPressed: () {
                  _addCustomerAddress();
                })
              ]
          )
        )
    );
  }

  ///新增给收货地址
  Future<void> _addCustomerAddress() async{
    if (titleType.isEmpty){
      showToast('抬头类型不能为空');
      return;
    }

    if (title.isEmpty){
      showToast('抬头名称不能为空');
      return;
    }

    if (taxNo.isEmpty){
      showToast('税号不能为空');
      return;
    }

    if (userName.isEmpty){
      showToast('收票人不能为空');
      return;
    }

    if (phone.isEmpty){
      showToast('收票人电话不能为空');
      return;
    }

    if (address.isEmpty){
      showToast('收票人地址不能为空');
      return;
    }

    if (bank.isEmpty){
      showToast('开户行不能为空');
      return;
    }

    if (card.isEmpty){
      showToast('开户行账号不能为空');
      return;
    }

    Map<String, dynamic> map = {
      'id': widget.data == null ? '' : widget.data['id'],
      'userId': widget.userId,
      'titleType': titleType,
      'title': title,
      'taxNo': taxNo,
      'userName': userName,
      'phone': phone,
      'address': address,
      'bank': bank,
      'card': card
    };

    String url = '';
    if (widget.data == null){
      url = Api.invoiceAdd;
    }else {
      url = Api.invoiceUpdate;
    }

    LogUtil.d('请求结果---map----$map');

    requestPost(url, formData: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---$url----$data');
      if (data['code'] == 200){
        Navigator.pop(context, true);
      }else {
        showToast(data['msg']);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _editingController.dispose();
  }
}
