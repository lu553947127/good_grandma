import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

typedef OnChanged = void Function(String txt);

///搜索框
class SearchTextWidget extends StatelessWidget {
  const SearchTextWidget({
    Key key,
    this.hintText = '请输入员工姓名',
    @required TextEditingController editingController,
    @required FocusNode focusNode,
    this.onChanged,
    this.onSearch,
  })  : _editingController = editingController,
        _focusNode = focusNode,
        super(key: key);

  final String hintText;
  final TextEditingController _editingController;
  final FocusNode _focusNode;
  final Function(String text) onSearch;
  final OnChanged onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: Offset(0, 1),
            blurRadius: 5,
          )
        ]),
        child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
                color: AppColors.FFEFEFF4,
                borderRadius: BorderRadius.circular(30 / 2)),
            child: TextField(
                controller: _editingController,
                focusNode: _focusNode,
                maxLines: 1,
                selectionHeightStyle: BoxHeightStyle.max,
                textInputAction: TextInputAction.search,
                onSubmitted: onSearch,
                decoration: InputDecoration(
                  icon: Icon(Icons.search, size: 20, color: AppColors.FFC1C8D7),
                  contentPadding: const EdgeInsets.only(),
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30 / 2),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle:
                  const TextStyle(color: AppColors.FFC1C8D7, fontSize: 14),
                ),
                onChanged: (text) {
                  if(onChanged != null){
                    onChanged(text);
                  }
                }
            )
        )
    );
  }
}