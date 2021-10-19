import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/widgets/select_form.dart';
import 'package:good_grandma/widgets/select_tree.dart';

///合同顶部筛选
class ContractSelectType extends StatefulWidget {
  const ContractSelectType({Key key, @required this.onSelect})
      : super(key: key);
  final Function(String areaId, String customerId,
      String signType, String status) onSelect;

  @override
  _ContractSelectTypeState createState() => _ContractSelectTypeState();
}

class _ContractSelectTypeState extends State<ContractSelectType> {

  String _btnName1 = '所有区域';
  String _btnName2 = '所有客户';
  String _btnName3 = '所有类型';
  String _btnName4 = '所有状态';
  String areaId = '';
  String customerId = '';
  String signType = '';
  String status = '';

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width / 4 - 1;
    final Widget div =
        Container(width: 1.0, height: 12.0, color: AppColors.FFC1C8D7);

    return Container(
      color: Colors.white,
      child: Row(
        children: [
          //所有区域
          Container(
            width: w,
            child: TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(_btnName1,
                        style:
                            TextStyle(fontSize: 14, color: AppColors.FF2F4058),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.5),
                    child: Image.asset('assets/images/ic_work_down.png',
                        width: 10, height: 10),
                  )
                ]
              ),
              onPressed: () async {
                Map area = await showSelectTreeList(context, '全国');
                areaId = area['deptId'];
                _btnName1 = area['areaName'];
                if (mounted) setState(() {});
                if (widget.onSelect != null)
                  widget.onSelect(areaId, customerId, signType, status);
              }
            )
          ),
          div,
          //所有客户
          Container(
            width: w,
            child: TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      _btnName2,
                      style: TextStyle(fontSize: 14, color: AppColors.FF2F4058),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.5),
                    child: Image.asset('assets/images/ic_work_down.png',
                        width: 10, height: 10),
                  )
                ]
              ),
              onPressed: () async {
                Map select = await showSelectList(context, Api.customerList, '请选择客户名称', 'realName');
                customerId = select['id'];
                _btnName2 = select['realName'];
                if (mounted) setState(() {});
                if (widget.onSelect != null)
                  widget.onSelect(areaId, customerId, signType, status);
              }
            )
          ),
          div,
          //所有类型
          Container(
            width: w,
            child: TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(
                        _btnName3,
                        style: TextStyle(fontSize: 14, color: AppColors.FF2F4058),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.5),
                    child: Image.asset('assets/images/ic_work_down.png',
                        width: 10, height: 10),
                  )
                ],
              ),
              onPressed: () async {
                String result = await showPicker(
                    ['所有类型', '经销商合同', '分销商合同', '冷冻设备借用协议', '冷冻设备借用协议（第三方）', '配送协议', '小型经销商合同'], context);
                if (result != null && result.isNotEmpty) {
                  switch(result){
                    case '所有类型':
                      signType = '';
                      break;
                    case '经销商合同':
                      signType = '0';
                      break;
                    case '分销商合同':
                      signType = '1';
                      break;
                    case '冷冻设备借用协议':
                      signType = '2';
                      break;
                    case '冷冻设备借用协议（第三方）':
                      signType = '3';
                      break;
                    case '配送协议':
                      signType = '4';
                      break;
                    case '小型经销商合同':
                      signType = '5';
                      break;
                  }
                  _btnName3 = result;
                  if (mounted) setState(() {});
                  if (widget.onSelect != null)
                    widget.onSelect(areaId, customerId, signType, status);
                }
              }
            )
          ),
          div,
          //所有状态
          Container(
            width: w,
            child: TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(
                        _btnName4,
                        style: TextStyle(fontSize: 14, color: AppColors.FF2F4058),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.5),
                    child: Image.asset('assets/images/ic_work_down.png',
                        width: 10, height: 10),
                  )
                ]
              ),
              onPressed: () async {
                String result =
                    await showPicker(['所有状态', '未签署完成', '待签署', '签署完成', '过期', '已撤销'], context);
                if (result != null && result.isNotEmpty) {
                  switch(result){
                    case '所有状态':
                      status = '';
                      break;
                    case '未签署完成':
                      status = '0';
                      break;
                    case '待签署':
                      status = '1';
                      break;
                    case '签署完成':
                      status = '2';
                      break;
                    case '过期':
                      status = '3';
                      break;
                    case '已撤销':
                      status = '4';
                      break;
                  }
                  _btnName4 = result;
                  if (mounted) setState(() {});
                  if (widget.onSelect != null)
                    widget.onSelect(areaId, customerId, signType, status);
                }
              }
            )
          )
        ]
      )
    );
  }
}
