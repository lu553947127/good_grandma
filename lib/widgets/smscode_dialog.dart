import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
///短信验证码的弹框
class SMSCodeDialog extends Dialog {
  final FocusNode focusNode;
  final TextEditingController editingController;
  final FocusNode focusNode2;
  final TextEditingController editingController2;
  final VoidCallback submitBtnOnTap;
  SMSCodeDialog({
    @required this.focusNode,
    @required this.editingController,
    @required this.focusNode2,
    @required this.editingController2,
    @required this.submitBtnOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 37.0),
          child: Container(
            height: 210,
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 46 / 2),
                  decoration: BoxDecoration(
                      color: AppColors.FFF8F9FC,
                      borderRadius: BorderRadius.circular(46 / 2)),
                  child: TextField(
                    focusNode: focusNode,
                    controller: editingController,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '请输入手机号',
                      hintStyle: const TextStyle(color: AppColors.FFC1C8D7),
                      // 未获得焦点下划线
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      //获得焦点下划线
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    padding: const EdgeInsets.only(left: 46 / 2),
                    decoration: BoxDecoration(
                        color: AppColors.FFF8F9FC,
                        borderRadius: BorderRadius.circular(46 / 2)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: focusNode2,
                            controller: editingController2,
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '请输入验证码',
                              hintStyle:
                                  const TextStyle(color: AppColors.FFC1C8D7),
                              // 未获得焦点下划线
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              //获得焦点下划线
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SubmitBtn(
                            title: '获取验证码',
                            height: 46,
                            width: 70,
                            vertical: 0,
                            horizontal: 0,
                            elevation: 0,
                            fontSize: 12,
                            onPressed: () {
                              focusNode2.requestFocus();
                            })
                      ],
                    ),
                  ),
                ),
                SubmitBtn(
                    title: '确  定',
                    height: 46,
                    vertical: 10,
                    horizontal: 0,
                    onPressed: () {
                      if(submitBtnOnTap != null)
                        submitBtnOnTap();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
