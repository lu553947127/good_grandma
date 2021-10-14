import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/contract/select_customer_page.dart';
import 'package:good_grandma/pages/work/work_text.dart';

///合同顶部筛选
class ContractSelectType extends StatefulWidget {
  const ContractSelectType({Key key, @required this.onSelect})
      : super(key: key);
  final Function(String selArea, List<CustomerModel> selCustomers,
      String selType, String selState) onSelect;

  @override
  _ContractSelectTypeState createState() => _ContractSelectTypeState();
}

class _ContractSelectTypeState extends State<ContractSelectType> {
  List<CustomerModel> _customers = [];
  String _btnName1 = '所有区域';
  String _btnName2 = '所有客户';
  String _btnName3 = '所有类型';
  String _btnName4 = '所有状态';
  String _selArea = '';
  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width / 4 - 1;
    final Widget div =
        Container(width: 1.0, height: 12.0, color: AppColors.FFC1C8D7);

    int selCount = 0;
    if (_customers.isNotEmpty) {
      selCount = _customers.length;
      int i = 0;
      _btnName2 = '';
      _customers.forEach((employee) {
        _btnName2 += employee.name;
        if (i < _customers.length - 1) _btnName2 += ',';
        i++;
      });
    }

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
                ],
              ),
              onPressed: () async {
                String result = await showPickerModal(context, PickerData);
                if(result != null) {
                  _selArea = result;
                  String re = result.replaceFirst('[', '');
                  re = re.replaceFirst(']', '');
                  List<String> areas = re.split(',');
                  _btnName1 = areas[areas.length - 2] + ',' + areas.last;
                  if (mounted) setState(() {});
                  if (widget.onSelect != null)
                    widget.onSelect(_selArea, _customers, _btnName3, _btnName4);
                }
              },
            ),
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
                    ),
                  ),
                  Visibility(
                    visible: selCount > 0,
                    child: Text(
                      '($selCount)',
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.FF2F4058),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.5),
                    child: Image.asset('assets/images/ic_work_down.png',
                        width: 10, height: 10),
                  )
                ],
              ),
              onPressed: () async {
                List<CustomerModel> list = await Navigator.push(context,
                    MaterialPageRoute(builder: (_) {
                  return SelectCustomerPage(selCustomers: _customers);
                }));
                if (list != null && list.isNotEmpty) {
                  _customers.clear();
                  _customers.addAll(list);
                  if (mounted) setState(() {});
                  if (widget.onSelect != null)
                    widget.onSelect(_selArea, _customers, _btnName3, _btnName4);
                }
              },
            ),
          ),
          div,
          //所有类型
          Container(
            width: w,
            child: TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_btnName3,
                      style:
                          TextStyle(fontSize: 14, color: AppColors.FF2F4058)),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.5),
                    child: Image.asset('assets/images/ic_work_down.png',
                        width: 10, height: 10),
                  )
                ],
              ),
              onPressed: () async {
                String result =
                    await showPicker(['所有类型', '经销商合同', '分销商合同', '冷冻设备借用协议', '冷冻设备借用协议（第三方）', '配送协议'], context);
                if (result != null && result.isNotEmpty) {
                  setState(() => _btnName3 = result);
                  if (widget.onSelect != null)
                    widget.onSelect(_selArea, _customers, _btnName3, _btnName4);
                }
              },
            ),
          ),
          div,
          //所有状态
          Container(
            width: w,
            child: TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_btnName4,
                      style:
                          TextStyle(fontSize: 14, color: AppColors.FF2F4058)),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.5),
                    child: Image.asset('assets/images/ic_work_down.png',
                        width: 10, height: 10),
                  )
                ],
              ),
              onPressed: () async {
                String result =
                    await showPicker(['所有状态', '未签署', '签署完成', '已发送', '过期', '撤销'], context);
                if (result != null && result.isNotEmpty) {
                  setState(() => _btnName4 = result);
                  if (widget.onSelect != null)
                    widget.onSelect(_selArea, _customers, _btnName3, _btnName4);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
