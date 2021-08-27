import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';

///底部输入反馈的视图
class PostDetailBottomReportView extends StatefulWidget {
  final Function(String text) sendAction;
  const PostDetailBottomReportView({Key key, @required this.sendAction})
      : super(key: key);

  @override
  _PostDetailBottomReportViewState createState() =>
      _PostDetailBottomReportViewState();
}

class _PostDetailBottomReportViewState
    extends State<PostDetailBottomReportView> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode
      ..addListener(() {
        if (!_focusNode.hasFocus) if (mounted) setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _editingController?.dispose();
    _focusNode?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.5),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                    color: AppColors.FFEFEFF4,
                    borderRadius: BorderRadius.circular(30 / 2)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: GestureDetector(
                    onTap: () => AppUtil.showInputDialog(
                      context: context,
                      text: _editingController.text,
                      hintText: '请输入反馈',
                      editingController: _editingController,
                      focusNode: _focusNode,
                      callBack: (text) => _onSend(text),
                    ),
                    child: Text(
                        _editingController.text.isNotEmpty
                            ? _editingController.text
                            : '请输入反馈',
                        style: TextStyle(
                            color: _editingController.text.isNotEmpty
                                ? AppColors.FF070E28
                                : AppColors.FF959EB1,
                            fontSize: 14),
                        textAlign: TextAlign.start),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _onSend(_editingController.text);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onSend(String text) {
    if (widget.sendAction != null) widget.sendAction(text);
  }
}
