import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/file_model.dart';

///新建文件夹
class AddFolderPage extends StatelessWidget {
  AddFolderPage({Key key, this.model}) : super(key: key);

  ///重命名传model
  final FileModel model;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if(model != null)
      _editingController.text = model.name;
    return Scaffold(
      appBar: AppBar(
        title: Text(model == null ? '新建文件夹' : '重命名'),
        actions: [
          TextButton(
              onPressed: () {
                if (_editingController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: '名称不能为空', gravity: ToastGravity.CENTER);
                  return;
                }
                if(model == null){
                  //新建文件夹
                  _addNewFolderRequest(context);
                }
                else{
                  //重命名
                  _renameRequest(context);
                }
              },
              child: const Text(
                '完成',
                style: TextStyle(color: AppColors.FF2F4058, fontSize: 14.0),
              )),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (model == null || model.isFolder) ? '文件夹名称' : '文件夹名称',
                  style: const TextStyle(fontSize: 14.0),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _editingController,
                  focusNode: _focusNode,
                  maxLines: 1,
                  selectionHeightStyle: BoxHeightStyle.max,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: '请填写名称',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.5),
                      borderSide:
                          BorderSide(color: AppColors.FFEFEFF4, width: 1),
                    ),
                    hintStyle: const TextStyle(
                        color: AppColors.FFC1C8D7, fontSize: 14),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  void _addNewFolderRequest(BuildContext context){
    Navigator.pop(context, '');
  }
  void _renameRequest(BuildContext context){
    Navigator.pop(context, _editingController.text);
  }
}
