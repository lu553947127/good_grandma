import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:good_grandma/widgets/submit_btn.dart';

///收货地址添加
class ReceivingAddressAdd extends StatefulWidget {
  final String userId;
  final dynamic data;
  const ReceivingAddressAdd({Key key, this.userId, this.data}) : super(key: key);

  @override
  _ReceivingAddressAddState createState() => _ReceivingAddressAddState();
}

class _ReceivingAddressAddState extends State<ReceivingAddressAdd> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String linkMain = '';
  String phone = '';
  String address = '';

  @override
  void initState() {
    super.initState();
    if (widget.data != null){
      linkMain = widget.data['linkMain'];
      phone = widget.data['phone'];
      address = widget.data['address'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('收货地址')),
      body: Column(
        children: [
          PostAddInputCell(
              title: '联系人',
              value: linkMain,
              hintText: '请输入联系人',
              endWidget: Icon(Icons.chevron_right),
              onTap: () => AppUtil.showInputDialog(
                  context: context,
                  editingController: _editingController,
                  focusNode: _focusNode,
                  text: linkMain,
                  hintText: '请输入联系人',
                  callBack: (text) {
                    linkMain = text;
                    setState(() {});
                  })
          ),
          PostAddInputCell(
              title: '联系电话',
              value: phone,
              hintText: '请输入联系电话',
              endWidget: Icon(Icons.chevron_right),
              onTap: () => AppUtil.showInputDialog(
                  context: context,
                  editingController: _editingController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.phone,
                  text: phone,
                  hintText: '请输入联系电话',
                  callBack: (text) {
                    phone = text;
                    setState(() {});
                  })
          ),
          PostAddInputCell(
              title: '联系地址',
              value: address,
              hintText: '请输入联系地址',
              endWidget: Icon(Icons.chevron_right),
              onTap: () => AppUtil.showInputDialog(
                  context: context,
                  editingController: _editingController,
                  focusNode: _focusNode,
                  text: address,
                  hintText: '请输入联系地址',
                  callBack: (text) {
                    address = text;
                    setState(() {});
                  })
          ),
          SubmitBtn(title: '提  交', onPressed: () {
            _addCustomerAddress();
          })
        ]
      )
    );
  }

  ///新增给收货地址
  Future<void> _addCustomerAddress() async{
    if (linkMain.isEmpty){
      showToast('联系人不能为空');
      return;
    }

    if (phone.isEmpty){
      showToast('联系电话不能为空');
      return;
    }

    if (address.isEmpty){
      showToast('联系地址不能为空');
      return;
    }

    Map<String, dynamic> map = {
      'userId': widget.userId,
      'linkMain': linkMain,
      'phone': phone,
      'address': address
    };

    String url = '';
    if (widget.data == null){
      url = Api.addCustomerAddress;
    }else {
      url = Api.editCustomerAddress;
    }

    requestPost(url, formData: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---addCustomerAddress----$data');
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
