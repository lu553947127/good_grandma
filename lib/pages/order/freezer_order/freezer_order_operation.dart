import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/order/freezer_order/freezer_order_model.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///冰柜订单发货/收货列表页
class FreezerOrderDetailOperation extends StatefulWidget {
  final String title;
  final String id;
  final String type;
  const FreezerOrderDetailOperation({Key key, this.title, this.id, this.type}) : super(key: key);

  @override
  _FreezerOrderDetailOperationState createState() => _FreezerOrderDetailOperationState();
}

class _FreezerOrderDetailOperationState extends State<FreezerOrderDetailOperation> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  List<Map> orderDetailList = [];
  FreezerOrderModel freezerOrderModel;

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    freezerOrderModel = Provider.of<FreezerOrderModel>(context);
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: MyEasyRefreshSliverWidget(
            controller: _controller,
            scrollController: _scrollController,
            dataCount: freezerOrderModel.freezerOrderDetailVOList.length,
            onRefresh: _refresh,
            onLoad: null,
            slivers: [
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    FreezerOModel model = freezerOrderModel.freezerOrderDetailVOList[index];
                    return Container(
                        margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                offset: Offset(2, 1),
                                blurRadius: 1.5,
                              )
                            ]
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('品牌: ${model.modelName}', style: TextStyle(fontSize: 15, color: Colors.black)),
                              SizedBox(height: 3),
                              Text('型号: ${model.brandName}', style: TextStyle(fontSize: 15, color: Colors.black)),
                              SizedBox(height: 3),
                              Text('订单数量: ${(model.longCount + model.returnCount)}', style: TextStyle(fontSize: 15, color: Colors.black)),
                              SizedBox(height: 3),
                              Text('总发货数量: ${model.sendCount}', style: TextStyle(fontSize: 15, color: Colors.black)),
                              SizedBox(height: 3),
                              Visibility(
                                visible: widget.title == '收货',
                                child: Text('本次发货数量: ${model.nowCount}', style: TextStyle(fontSize: 15, color: Colors.black)),
                              ),
                              Visibility(
                                  visible: widget.title == '发货',
                                  child: Row(
                                      children: [
                                        Text('本次发货数量: ${model.nowCount}', style: TextStyle(fontSize: 15, color: Colors.black)),
                                        TextButton(
                                            onPressed: () => AppUtil.showInputDialog(
                                                context: context,
                                                editingController: _editingController,
                                                focusNode: _focusNode,
                                                text: model.nowCount.toString(),
                                                hintText: '请输入本次发货数量',
                                                keyboardType: TextInputType.number,
                                                inputFormatters : [
                                                  WhitelistingTextInputFormatter.digitsOnly
                                                ],
                                                callBack: (text) {
                                                  if (int.parse(text) > (model.longCount + model.returnCount - model.sendCount)){
                                                    showToast("发货数量超出限制");
                                                    return;
                                                  }
                                                  model.nowCount = int.parse(text);
                                                  freezerOrderModel.editOrderModelWith(index, model);
                                                }),
                                            child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: AppColors.FFC08A3F, borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Text('编辑',
                                                    style: TextStyle(fontSize: 12, color: Colors.white))
                                            ))
                                      ]
                                  )
                              )
                            ]
                        )
                    );
                  }, childCount: freezerOrderModel.freezerOrderDetailVOList.length))
            ]
        ),
        bottomNavigationBar: SubmitBtn(
            horizontal: 95,
            width: 200,
            title: '确认',
            onPressed: () {
              if (widget.title == '发货'){
                _deliver(context, freezerOrderModel);
              }else {
                _freezerOrderOver(context);
              }
            }
        )
    );
  }

  Future<void> _refresh() async {
    await _downloadData();
  }

  ///发货、收货列表
  Future<void> _downloadData() async {
    try {
      Map<String, dynamic> map = {'id': widget.id, 'type': widget.type};
      final val = await requestGet(Api.freezerOrderGetOrderDetail, param: map);
      var data = jsonDecode(val.toString());
      LogUtil.d('请求结果---orderDetailList----$data');
      orderDetailList.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        orderDetailList.add(map);
      });

      EasyLoading.show();
      Future.delayed(Duration(milliseconds: 500)).then((e) {
        orderDetailList.forEach((element) {
          freezerOrderModel.addOrderModel(FreezerOModel(
              id: element['brand'],
              orderId: element['orderId'],
              brand: element['brand'],
              brandName: element['brandName'],
              model: element['model'],
              modelName: element['modelName'],
              longCount: element['longCount'],
              returnCount: element['returnCount'],
              sendCount: element['sendCount'],
              nowCount: element['nowCount']
          ));
        });

        EasyLoading.dismiss();
      });

      bool noMore = false;
      if (list == null || list.isEmpty) noMore = true;
      _controller.finishRefresh(success: true);
      _controller.finishLoad(success: true, noMore: noMore);
      if (mounted) setState(() {});
    } catch (error) {
      _controller.finishRefresh(success: false);
      _controller.finishLoad(success: false, noMore: false);
    }
  }

  ///发货
  void _deliver(BuildContext context, FreezerOrderModel freezerOrderModel) async{
    Map<String, dynamic> map = {
      'id': widget.id,
      'freezerOrderDetailVOList': freezerOrderModel.freezerOrderMapList
    };
    LogUtil.d('map----${freezerOrderModel.freezerOrderMapList}');
    requestPost(Api.freezerOrderSendCargo, formData: freezerOrderModel.freezerOrderMapList).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---freezerOrderSendCargo----$data');
      if (data['code'] == 200){
        showToast("成功");
        Navigator.pop(context, true);
      }else {
        showToast(data['msg']);
      }
    });
  }

  ///确认收货
  void _freezerOrderOver(BuildContext context) async {
    Map<String, dynamic> map = {'id': widget.id};
    requestGet(Api.freezerOrderOver, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---freezerOrderOver----$data');
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
    _focusNode.dispose();
    _editingController.dispose();
    _scrollController?.dispose();
    _controller?.dispose();
    super.dispose();
  }
}
