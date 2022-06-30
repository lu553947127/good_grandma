import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/order/material_order/material_order_add.dart';
import 'package:good_grandma/pages/order/material_order/material_order_model.dart';
import 'package:good_grandma/widgets/marketing_activity_msg_cell.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///物料订单详情
class MaterialOrderDetail extends StatefulWidget {
  final dynamic data;
  const MaterialOrderDetail({Key key, this.data}) : super(key: key);

  @override
  _MaterialOrderDetailState createState() => _MaterialOrderDetailState();
}

class _MaterialOrderDetailState extends State<MaterialOrderDetail> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {

    List<Map> materialDetailsList = (widget.data['materialDetailsVOS'] as List).cast();

    _setTextStatus(status, Map map){
      switch(status){
        case 1:
          return '${map['authName']}';
          break;
        case 2:
          return '审核通过';
          break;
        case 3:
          return '已入库';
          break;
        case 4:
          return '驳回';
          break;
        case 5:
          return '已终止';
          break;
        case 6:
          if (map['ifsplit'] == 0){
            return '已发货';
          }else {
            return '已发货（部分发货）';
          }
          break;
        case 7:
          return '未发货';
          break;
        default:
          return '无';
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
          title: Text('物料订单详情'),
          actions: [
            Visibility(
              visible: widget.data['userId'] == Store.readUserId() && widget.data['status'] == 4,
              child: TextButton(
                  child: Text('编辑', style: TextStyle(fontSize: 14, color: Color(0xFFC08A3F))),
                  onPressed: () async {
                    MarketingOrderModel model = MarketingOrderModel();
                    bool needRefresh = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                            ChangeNotifierProvider<MarketingOrderModel>.value(
                              value: model,
                              child: MaterialOrderAddPage(id: widget.data['id'], data: widget.data, newKey: ''),
                            )));
                    if(needRefresh != null && needRefresh){
                      Navigator.pop(context, true);
                    }
                  }
              )
            )
          ]
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(2, 1), //x,y轴
                        color: Colors.black.withOpacity(0.1), //投影颜色
                        blurRadius: 1 //投影距离
                    )
                  ]
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.data['userName'],style: TextStyle(fontSize: 14, color: Color(0XFFE45C26))),
                          SizedBox(height: 3),
                          Text(widget.data['createTime'],style: TextStyle(fontSize: 12, color: Color(0XFF959EB1)))
                        ]
                    ),
                    Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xFFF1E1E2), borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(_setTextStatus(widget.data['status'], widget.data),
                            style: TextStyle(fontSize: 10, color: Color(0xFFDD0000)))
                    )
                  ]
              )
            )
          ),
          SliverToBoxAdapter(
            child: MarketingActivityMsgCell(title: '公司', value: '${widget.data['company']}'),
          ),
          SliverToBoxAdapter(
            child: MarketingActivityMsgCell(title: '总价', value: '${widget.data['totalPrice']}'),
          ),
          PostDetailGroupTitle(color: AppColors.FFC08A3F, name: '客户信息'),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              List<Map> materialDetails= (materialDetailsList[index]['materialDetails'] as List).cast();
              return Container(
                  margin: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        MarketingActivityMsgCell(title: '是否随货', value: materialDetailsList[index]['withGoods'] == 1 ? '是' : '否'),
                        MarketingActivityMsgCell(title: '区域', value: materialDetailsList[index]['deptName']),
                        MarketingActivityMsgCell(title: '经销商名称', value: materialDetailsList[index]['customerName']),
                        MarketingActivityMsgCell(title: '物料地址', value: materialDetailsList[index]['address']),
                        MarketingActivityMsgCell(title: '联系电话', value: materialDetailsList[index]['phone']),
                        DetailGroupTitle(color: AppColors.FFC08A3F, name: '物料信息'),
                        ListView.builder(
                            shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                            physics:NeverScrollableScrollPhysics(),//禁止滚动
                            itemCount: materialDetails.length,
                            itemBuilder: (content, index){
                              return Container(
                                  margin: EdgeInsets.only(left: 15.0, right: 15.0),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        MarketingActivityMsgCell(title: '物料名称', value: materialDetails[index]['materialName']),
                                        MarketingActivityMsgCell(title: '数量', value: materialDetails[index]['quantity'].toString()),
                                        MarketingActivityMsgCell(title: '单价', value: materialDetails[index]['unitPrice'].toString())
                                      ]
                                  )
                              );
                            }
                        )
                      ]
                  )
              );
            }, childCount: materialDetailsList.length),
          ),
          SliverVisibility(
            visible: widget.data['status'] == 1 && widget.data['opinion'] != null && widget.data['opinion'].toString().isNotEmpty ||
                widget.data['status'] == 4 && widget.data['opinion'].toString().isNotEmpty,
            sliver: SliverToBoxAdapter(child: MarketingActivityMsgCell(title: '审批意见', value: '${widget.data['opinion']}')),
          ),
          SliverSafeArea(
              sliver: SliverToBoxAdapter(
                  child: Visibility(
                    visible: widget.data['userId'] == Store.readUserId() && widget.data['status'] == 6,
                    child: SubmitBtn(
                        title: '入库',
                        onPressed: () {
                          _submitWarehousing(context);
                        }
                    )
                  )
              )
          ),
          SliverSafeArea(
              sliver: SliverToBoxAdapter(
                  child: Visibility(
                      visible: widget.data['status'] == 1 && widget.data['approve'] == true,
                      child: SubmitBtn(
                          title: '审核',
                          onPressed: () async {
                            AppUtil.showInputDialog(
                                context: context,
                                editingController: _editingController,
                                focusNode: _focusNode,
                                text: '',
                                hintText: '请输入审批意见',
                                keyboardType: TextInputType.text,
                                callBack: (text) {
                                  _materialApprove(context, '1', text);
                                });
                          }
                      )
                  )
              )
          ),
          SliverSafeArea(
              sliver: SliverToBoxAdapter(
                  child: Visibility(
                    visible: widget.data['status'] == 4 && widget.data['approve'] == true,
                    child: SubmitBtn(
                        title: '驳回',
                        onPressed: () async {
                          AppUtil.showInputDialog(
                              context: context,
                              editingController: _editingController,
                              focusNode: _focusNode,
                              text: '',
                              hintText: '请输入审批意见',
                              keyboardType: TextInputType.text,
                              callBack: (text) {
                                _materialApprove(context, '4', text);
                              });
                        }
                    )
                  )
              )
          )
        ]
      )
    );
  }

  ///入库
  void _submitWarehousing(BuildContext context) async {
    Map<String, dynamic> map = {'id': widget.data['id']};
    requestPost(Api.materialOrderWarehousing, formData: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---materialOrderWarehousing----$data');
      if (data['code'] == 200){
        showToast("成功");
        Navigator.pop(context, true);
      }else {
        showToast(data['msg']);
      }
    });
  }

  ///审核
  void _materialApprove(BuildContext context, status, opinion) async {
    Map<String, dynamic> map = {
      'id': widget.data['id'],
      'status': status,
      'opinion': opinion
    };

    requestPost(Api.materialApprove, formData: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---materialApprove----$data');
      if (data['code'] == 200){
        showToast("成功");
        Navigator.pop(context, true);
      }else {
        showToast(data['msg']);
      }
    });
  }

  ///驳回
  void _materialReject(BuildContext context) async {
    Map<String, dynamic> map = {'id': widget.data['id']};
    requestPost(Api.materialReject, formData: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---materialReject----$data');
      if (data['code'] == 200){
        showToast("成功");
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
