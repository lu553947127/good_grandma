import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

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
                    onTap: _showDi,
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

  ///显示输入弹框
  void _showDi() {
    final top = 0.0; //12.0;
    final txBottom = 40.0;
    final txHeight = 30.0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx2, state) {
          return Container(
            height: MediaQuery.of(ctx2).viewInsets.bottom +
                txHeight +
                top +
                txBottom,
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.5),
            child: Stack(
              children: <Widget>[
                Positioned(
                    left: 0,
                    bottom: (MediaQuery.of(ctx2).viewInsets.bottom < 0)
                        ? 0
                        : MediaQuery.of(ctx2).viewInsets.bottom,
                    right: 0,
                    top: top,
                    child: Container(
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                              child: Container(
                            height: txHeight,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            decoration: BoxDecoration(
                                color: AppColors.FFEFEFF4,
                                borderRadius: BorderRadius.circular(30 / 2)),
                            child: TextField(
                              controller: _editingController,
                              focusNode: _focusNode,
                              maxLines: 1,
                              selectionHeightStyle: BoxHeightStyle.max,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (text) {
                                Navigator.pop(ctx2);
                                _onSend(text);
                              },
                              // onTap: _showDi,
                              autofocus: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(),
                                hintText: '请输入反馈',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30 / 2),
                                  borderSide: BorderSide.none,
                                ),
                                hintStyle: const TextStyle(
                                    color: AppColors.FF959EB1, fontSize: 12),
                              ),
                            ),
                          )),
                          IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              Navigator.pop(ctx2);
                              _onSend(_editingController.text);
                            },
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          );
        });
      },
    );
  }
}
