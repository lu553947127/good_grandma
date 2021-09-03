import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/widgets/submit_btn.dart';

///手机号码
class AlertPhonePage extends StatefulWidget {
  const AlertPhonePage({Key key}) : super(key: key);

  @override
  _AlertPhonePageState createState() => _AlertPhonePageState();
}

class _AlertPhonePageState extends State<AlertPhonePage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();
  FocusNode _focusNode1 = FocusNode();
  TextEditingController _editingController1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('手机号码')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                      '设置新手机号',
                      style: const TextStyle(color: AppColors.FF959EB1, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ))
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                TextField(
                  controller: _editingController,
                  focusNode: _focusNode,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  autofocus: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(),
                    hintText: '请输入新手机号',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: const TextStyle(
                        color: AppColors.FF959EB1, fontSize: 14),
                  ),
                ),
                const Divider(height: 1),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _editingController1,
                        focusNode: _focusNode1,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(),
                          hintText: '请输入验证码',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: const TextStyle(
                              color: AppColors.FF959EB1, fontSize: 14),
                        ),
                      ),
                    ),
                    SubmitBtn(
                        title: '获取验证码',
                        height: 30,
                        width: 90,
                        vertical: 0,
                        horizontal: 0,
                        elevation: 0,
                        fontSize: 12,
                        onPressed: () {
                          _focusNode1.requestFocus();
                        })
                  ],
                ),
              ],
            ),
          ),
          SubmitBtn(title: '确认', onPressed: () {
            Navigator.pop(context,_editingController.text);
          }),
        ],
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    _editingController?.dispose();
    _focusNode?.dispose();
    _editingController1?.dispose();
    _focusNode1?.dispose();
  }
}
