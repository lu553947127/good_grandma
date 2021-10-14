import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/employee_model.dart';
import 'package:good_grandma/pages/work/work_report/select_employee_page.dart';

class WorkSelectType extends StatefulWidget {
  const WorkSelectType(
      {Key key,
      @required this.selectAction,
      this.reset = false,
      this.showPeopleBtn = true})
      : super(key: key);

  ///重设数据为默认样式
  final bool reset;
  final bool showPeopleBtn;
  final Function(
    List<EmployeeModel> selEmployees,
    String typeName,
    String startTime,
    String endTime,
  ) selectAction;
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<WorkSelectType> {
  List<EmployeeModel> _employees = [];
  String _btnName1 = '所有人';
  String _btnName2 = '所有类型';
  String _btnName3 = '所有日期';
  String _startTime = '';
  String _endTime = '';

  @override
  void didUpdateWidget(covariant WorkSelectType oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reset) {
      setState(() {
        _btnName1 = '所有人';
        _btnName2 = '所有类型';
        _btnName3 = '所有日期';
        _startTime = '';
        _endTime = '';
        _employees.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double w = (MediaQuery.of(context).size.width - 15 * 2) / 3;

    int selCount = 0;
    if (_employees.isNotEmpty) {
      selCount = _employees.length;
      int i = 0;
      _btnName1 = '';
      _employees.forEach((employee) {
        _btnName1 += employee.name;
        if (i < _employees.length - 1) _btnName1 += ',';
        i++;
      });
    }

    List<Widget> list = [];
    if (widget.showPeopleBtn)
      //选人
      list.add(Container(
        width: w,
        child: TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: selCount > 0 ? 1 : 0,
                child: Text(
                  _btnName1,
                  style:
                      const TextStyle(fontSize: 14, color: AppColors.FF2F4058),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
              Visibility(
                visible: selCount > 0,
                child: Text(
                  '($selCount)',
                  style:
                      const TextStyle(fontSize: 14, color: AppColors.FF2F4058),
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
            List<EmployeeModel> list =
                await Navigator.push(context, MaterialPageRoute(builder: (_) {
              return SelectEmployeePage(selEmployees: _employees //_selEmployees
                  );
            }));
            if (list != null && list.isNotEmpty) {
              _employees.clear();
              _employees.addAll(list);
              if (widget.selectAction != null) {
                widget.selectAction(
                    _employees, _btnName2, _startTime, _endTime);
              }
              if (mounted) setState(() {});
            }
          },
        ),
      ));
    //所有类型
    list.add(Container(
      width: w,
      child: TextButton(
        child: Container(
          decoration: BoxDecoration(
              border: !widget.showPeopleBtn
                  ? null
                  : Border.symmetric(
                      vertical:
                          BorderSide(color: AppColors.FFC1C8D7, width: 1))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_btnName2,
                  style: TextStyle(fontSize: 14, color: AppColors.FF2F4058)),
              Padding(
                padding: const EdgeInsets.only(left: 4.5),
                child: Image.asset('assets/images/ic_work_down.png',
                    width: 10, height: 10),
              )
            ],
          ),
        ),
        onPressed: () async {
          String result = await showPicker(['所有类型', '日报', '周报', '月报'], context);
          if (result != null && result.isNotEmpty) {
            setState(() => _btnName2 = result);
            if (widget.selectAction != null) {
              widget.selectAction(_employees, _btnName2, _startTime, _endTime);
            }
          }
        },
      ),
    ));
    //所有日期
    list.add(Container(
      width: w,
      child: TextButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                _startTime.isEmpty || _endTime.isEmpty
                    ? _btnName3
                    : _startTime + '\n' + _endTime, //_btnName3,
                style: TextStyle(fontSize: 14, color: AppColors.FF2F4058)),
            Padding(
              padding: const EdgeInsets.only(left: 4.5),
              child: Image.asset('assets/images/ic_work_down.png',
                  width: 10, height: 10),
            )
          ],
        ),
        onPressed: () async {
          showPickerDateRange(
              context: context,
              type: PickerDateTimeType.kYMD,
              callBack: (Map param) {
                setState(() {
                  _startTime = param['startTime'];
                  final List<String> dates = _startTime.split(' ');
                  _startTime = dates.first;
                  _endTime = param['endTime'];
                  final List<String> times = _endTime.split(' ');
                  _endTime = times.first;
                });
                if (widget.selectAction != null) {
                  widget.selectAction(
                      _employees, _btnName2, _startTime, _endTime);
                }
              });
        },
      ),
    ));

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: list),
    );
  }
}
