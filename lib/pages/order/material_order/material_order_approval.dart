import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/widgets/activity_add_text_cell.dart';
import 'package:good_grandma/widgets/submit_btn.dart';

///物料订单审批页面
class MaterialOrderApproval extends StatefulWidget {
  final dynamic data;
  const MaterialOrderApproval({Key key, this.data}) : super(key: key);

  @override
  State<MaterialOrderApproval> createState() => _MaterialOrderApprovalState();
}

class _MaterialOrderApprovalState extends State<MaterialOrderApproval> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _isAdopt = true;//通过
  bool _isReject = false;//驳回
  int status = 1;
  String opinion = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('物料订单审核')),
      body: Column(
        children: [
          Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              color: Colors.white,
              height: 60,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('通过',style: TextStyle(fontSize: 15, color: AppColors.FF070E28)),
                    Checkbox(
                        value: _isAdopt,
                        activeColor: Color(0xFFC68D3E),
                        onChanged: (value){
                          setState(() {
                            _isAdopt = value;
                            _isReject = false;
                            status = 1;
                          });
                        }
                    )
                  ]
              )
          ),
          Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              color: Colors.white,
              height: 60,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('驳回',style: TextStyle(fontSize: 15, color: AppColors.FF070E28)),
                    Checkbox(
                        value: _isReject,
                        activeColor: Color(0xFFC68D3E),
                        onChanged: (value){
                          setState(() {
                            _isReject = value;
                            _isAdopt = false;
                            status = 4;
                          });
                        }
                    )
                  ]
              )
          ),
          ActivityAddTextCell(
              title: '审核意见',
              hintText: '请输入审核意见',
              value: opinion,
              trailing: null,
              onTap: () => AppUtil.showInputDialog(
                  context: context,
                  editingController: _editingController,
                  focusNode: _focusNode,
                  text: opinion,
                  hintText: '请输入审核意见',
                  keyboardType: TextInputType.text,
                  callBack: (text) {
                    opinion = text;
                    setState(() {});
                  })
          ),
          SubmitBtn(
              title: '提  交',
              onPressed: () {
                _materialApprove(context);
              }
          )
        ],
      ),
    );
  }

  ///审核
  void _materialApprove(BuildContext context) async {
    if (opinion.isEmpty){
      showToast('审核意见不能为空');
      return;
    }

    Map<String, dynamic> map = {
      'id': widget.data['id'],
      'status': status,
      'opinion': opinion
    };

    requestPost(Api.materialApprove, formData: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---materialApprove----$data');
      if (data['code'] == 200){
        showToast('成功');
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
