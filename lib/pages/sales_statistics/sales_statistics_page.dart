import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/employee_model.dart';
import 'package:good_grandma/pages/contract/select_customer_page.dart';
import 'package:good_grandma/pages/sales_statistics/sales_statistics_customer_page.dart';
import 'package:good_grandma/pages/sales_statistics/sales_statistics_detail_page.dart';
import 'package:good_grandma/pages/sales_statistics/sales_statistics_salesman_page.dart';
import 'package:good_grandma/pages/work/work_report/select_employee_page.dart';
import 'package:good_grandma/widgets/sales_statistics_cell.dart';

///商品销量统计
class SalesStatisticsPage extends StatefulWidget {
  const SalesStatisticsPage({Key key, this.userType = 1}) : super(key: key);

  ///分三种登录用户类型,不同类型显示状态不同 1：业务经理，2：管理层，3：客户登录
  final int userType;

  @override
  _SalesStatisticsPageState createState() => _SalesStatisticsPageState();
}

class _SalesStatisticsPageState extends State<SalesStatisticsPage> {
  List<Map> _dataArray = [];

  bool _limitArea = false;
  bool _limitEmp = false;
  bool _limitCus = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('商品销量统计')),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            //顶部筛选按钮
            SliverVisibility(
              visible: widget.userType != 3,
              sliver: SliverToBoxAdapter(
                child: _SelectView(
                  userType: widget.userType,
                  selBtnOnTap: (String selArea,
                      List<EmployeeModel> selEmployees,
                      List<CustomerModel> selCustoms) {
                    _limitArea = false;
                    if (selArea != '所有区域') {
                      _limitArea = true;
                    }
                    _limitEmp = false;
                    if (selEmployees.isNotEmpty) {
                      _limitEmp = true;
                    }
                    _limitCus = false;
                    if (selCustoms.isNotEmpty) {
                      _limitCus = true;
                    }
                    setState(() {});
                  },
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              Map map = _dataArray[index];
              String title = map['title'];
              String id = map['id'];
              String salesCount = map['salesCount'];
              String salesPrice = map['salesPrice'];
              return SalesStatisticsCell(
                title: title,
                salesCount: salesCount,
                salesPrice: salesPrice,
                onTap: () {
                  if (widget.userType == 1) {
                    //业务经理
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SalesStatisticsSalesManPage(
                                title: title,
                                id: id,
                                salesCount: salesCount,
                                salesPrice: salesPrice)));
                  } else if (widget.userType == 2) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SalesStatisticsDetailPage(
                                  title: title,
                                  id: id,
                                  salesCount: salesCount,
                                  salesPrice: salesPrice,
                                  limitArea: _limitArea,
                                  limitEmp: _limitEmp,
                                  limitCus: _limitCus,
                                )));
                  } else if (widget.userType == 3) {
                    //客户登录
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SalesStatisticsCustomerPage(
                                title: title,
                                id: id,
                                salesCount: salesCount,
                                salesPrice: salesPrice)));
                  }
                },
              );
            }, childCount: _dataArray.length)),
            SliverSafeArea(sliver: SliverToBoxAdapter()),
          ],
        ),
      ),
    );
  }

  void _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _dataArray.clear();
    _dataArray.addAll(List.generate(
        8,
        (index) => {
              'title': '商品$index',
              'id': '$index',
              'salesCount': '11212',
              'salesPrice': '50000',
            }));
    if (mounted) setState(() {});
  }
}

///顶部筛选按钮
class _SelectView extends StatefulWidget {
  const _SelectView({
    Key key,
    @required this.selBtnOnTap,
    @required this.userType,
  }) : super(key: key);
  final Function(String selArea, List<EmployeeModel> selEmployees,
      List<CustomerModel> selCustoms) selBtnOnTap;
  final int userType;

  @override
  _SelectViewState createState() => _SelectViewState();
}

class _SelectViewState extends State<_SelectView> {
  List<EmployeeModel> _employees = [];
  List<CustomerModel> _customs = [];
  String _btnName1 = '所有区域';
  String _btnName2 = '所有员工';
  String _btnName3 = '所有客户';
  @override
  Widget build(BuildContext context) {
    final double w = (MediaQuery.of(context).size.width - 15 * 2) / 3 - 2;

    int selCount2 = 0;
    if (_customs.isNotEmpty) {
      selCount2 = _customs.length;
      int i = 0;
      _btnName3 = '';
      _customs.forEach((custom) {
        _btnName3 += custom.name;
        if (i < _customs.length - 1) _btnName3 += ',';
        i++;
      });
    }
    //客户
    Widget customView = Container(
      width: w,
      child: TextButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: selCount2 > 0 ? 1 : 0,
              child: Text(
                _btnName3,
                style: const TextStyle(fontSize: 14, color: AppColors.FF2F4058),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ),
            Visibility(
              visible: selCount2 > 0,
              child: Text(
                '($selCount2)',
                style: const TextStyle(fontSize: 14, color: AppColors.FF2F4058),
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
          List<CustomerModel> list =
              await Navigator.push(context, MaterialPageRoute(builder: (_) {
            List<CustomerModel> _selCustoms =
                _customs.where((custom) => custom.isSelected).toList();
            return SelectCustomerPage(selCustomers: _selCustoms);
          }));
          if (list != null && list.isNotEmpty) {
            _btnName1 = '所有区域';
            _btnName2 = '所有员工';
            _employees.clear();
            _customs.clear();
            _customs.addAll(list);
            if (widget.selBtnOnTap != null) {
              List<CustomerModel> _selCustoms =
                  _customs.where((custom) => custom.isSelected).toList();
              widget.selBtnOnTap(_btnName1, _employees, _selCustoms);
            }
            if (mounted) setState(() {});
          }
        },
      ),
    );

    int selCount1 = 0;
    if (_employees.isNotEmpty) {
      selCount1 = _employees.length;
      int i = 0;
      _btnName2 = '';
      _employees.forEach((employee) {
        _btnName2 += employee.name;
        if (i < _employees.length - 1) _btnName2 += ',';
        i++;
      });
    }

    return Container(
      height: 45,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: widget.userType == 2
          ? Row(
              children: [
                //区域
                Container(
                  width: w,
                  child: TextButton(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_btnName1,
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
                      String result = await showPicker(
                          ['所有区域', '区域1', '区域2', '区域3'], context);
                      if (result != null && result.isNotEmpty) {
                        setState(() {
                          _btnName2 = '所有员工';
                          _employees.clear();
                          _btnName3 = '所有客户';
                          _customs.clear();
                          _btnName1 = result;
                          if (widget.selBtnOnTap != null) {
                            widget.selBtnOnTap(_btnName1, _employees, _customs);
                          }
                        });
                      }
                    },
                  ),
                ),
                Container(width: 1, height: 12, color: AppColors.FFC1C8D7),
                //选人
                Container(
                  width: w,
                  child: TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: selCount1 > 0 ? 1 : 0,
                          child: Text(
                            _btnName2,
                            style: const TextStyle(
                                fontSize: 14, color: AppColors.FF2F4058),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Visibility(
                          visible: selCount1 > 0,
                          child: Text(
                            '($selCount1)',
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
                        return SelectEmployeePage(selEmployees: _selEmployees);
                      }));
                      if (list != null && list.isNotEmpty) {
                        _btnName1 = '所有区域';
                        _btnName3 = '所有客户';
                        _customs.clear();
                        _employees.clear();
                        _employees.addAll(list);
                        if (widget.selBtnOnTap != null) {
                          List<EmployeeModel> _selEmployees = _employees
                              .where((employee) => employee.isSelected)
                              .toList();
                          widget.selBtnOnTap(
                              _btnName1, _selEmployees, _customs);
                        }
                        if (mounted) setState(() {});
                      }
                    },
                  ),
                ),
                Container(width: 1, height: 12, color: AppColors.FFC1C8D7),
                //客户
                customView,
              ],
            )
          : customView,
    );
  }
}
