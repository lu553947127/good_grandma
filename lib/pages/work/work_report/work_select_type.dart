import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/work/work_report/select_employee_page.dart';

class WorkSelectType extends StatefulWidget {
  const WorkSelectType({Key key, @required this.selEmpBtnOnTap})
      : super(key: key);
  final Function(List<EmployeeModel> selEmployees) selEmpBtnOnTap;
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<WorkSelectType> {
  List<EmployeeModel> _employees = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final double w = (MediaQuery.of(context).size.width - 15 * 2) / 3;

    String btnName = '所有人';
    int selCount = 0;
    if (_employees.isNotEmpty) {
      List<EmployeeModel> _selEmployees =
          _employees.where((employee) => employee.isSelected).toList();
      if (_selEmployees.isNotEmpty &&
          _selEmployees.length < _employees.length) {
        selCount = _selEmployees.length;
        int i = 0;
        btnName = '';
        _selEmployees.forEach((employee) {
          btnName += employee.name;
          if (i < _selEmployees.length - 1) btnName += ',';
          i++;
        });
      }
    }
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          children: [
            //选人
            Container(
              width: w,
              child: TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: selCount > 0 ? 1 : 0,
                      child: Text(
                        btnName,
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.FF2F4058),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
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
                  List<EmployeeModel> list = await Navigator.push(context,
                      MaterialPageRoute(builder: (_) {
                    List<EmployeeModel> _selEmployees = _employees
                        .where((employee) => employee.isSelected)
                        .toList();
                    return SelectEmployeePage(
                      selEmployees: _selEmployees,
                    );
                  }));
                  if (list != null && list.isNotEmpty) {
                    _employees.clear();
                    _employees.addAll(list);
                    if (widget.selEmpBtnOnTap != null) {
                      List<EmployeeModel> _selEmployees = _employees
                          .where((employee) => employee.isSelected)
                          .toList();
                      widget.selEmpBtnOnTap(_selEmployees);
                    }
                    if (mounted) setState(() {});
                  }
                },
              ),
            ),
            //所有类型
            Container(
              width: w,
              child: TextButton(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.symmetric(
                          vertical:
                              BorderSide(color: AppColors.FFC1C8D7, width: 1))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('所有类型',
                          style: TextStyle(
                              fontSize: 14, color: AppColors.FF2F4058)),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.5),
                        child: Image.asset('assets/images/ic_work_down.png',
                            width: 10, height: 10),
                      )
                    ],
                  ),
                ),
                onPressed: () async {
                  String result =
                      await showPicker(['所有类型', '日报', '周报', '月报'], context);
                  if (result != null && result.isNotEmpty) {
                    print('result = $result');
                  }
                },
              ),
            ),
            //所有日期
            Container(
              width: w,
              child: TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('所有日期',
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
                      await showPicker(['所有日期', '上周', '上月'], context);
                  if (result != null && result.isNotEmpty) {
                    print('result = $result');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
