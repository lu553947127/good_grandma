import 'package:flutter/material.dart';
import 'package:good_grandma/pages/contract/contract_detail_page.dart';
import 'package:good_grandma/widgets/contract_cell.dart';
import 'package:good_grandma/widgets/contract_select_type.dart';

///电子合同
class ContractPage extends StatefulWidget {
  const ContractPage({Key key}) : super(key: key);

  @override
  _ContractPageState createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  List<Map> _dataArray = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('电子合同')),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            //选择类别
            ContractSelectType(),
            //列表
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              Map map = _dataArray[index];
              String title = map['title'];
              bool signed = map['signed'];
              String type = map['type'];
              String signUser = map['signUser'];
              String signTime = map['signTime'];
              String endSignTime = map['endSignTime'];
              String id = map['id'];
              return ContractCell(
                title: title,
                signed: signed,
                type: type,
                signUser: signUser,
                signTime: signTime,
                endSignTime: endSignTime,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ContractDetailPage(id: id))),
              );
            }, childCount: _dataArray.length)),
          ],
        ),
      ),
    );
  }

  void _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _dataArray.clear();
    _dataArray.addAll([
      {
        'title': '合同名称合同名称合同名称合',
        'signed': false,
        'type': '销售合同',
        'signUser': '张三',
        'signTime': '2021-07-01',
        'endSignTime': '2021-07-01',
        'id': '1'
      },
      {
        'title': '合同名称合同名称合同名称合',
        'signed': true,
        'type': '销售合同',
        'signUser': '张三',
        'signTime': '2021-07-01',
        'endSignTime': '2021-07-01',
        'id': '2'
      },
    ]);
    if (mounted) setState(() {});
  }
}
