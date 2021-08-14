import 'package:flutter/material.dart';
import 'package:good_grandma/models/msg_list_model.dart';
import 'package:good_grandma/pages/home/msg_duizhangdan_detail_page.dart';
import 'package:good_grandma/widgets/msg_list_cell.dart';
import 'package:provider/provider.dart';

///对账单列表
class MsgDuiZhangDanListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<MsgDuiZhangDanListPage> {
  List<MsgListModel> _dataArray = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('对账单')),
      body: Scrollbar(
        child: ListView.builder(
          itemBuilder: (context, index) {
            MsgListModel model = _dataArray[index];
            return ChangeNotifierProvider<MsgListModel>.value(
                value: model,
                child: MsgListCell(
                  cellOnTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return ChangeNotifierProvider<MsgListModel>.value(
                        value: model,
                        child: MsgDuiZhangDanDetailPage(),
                      );
                    }));
                  },
                ));
          },
          itemCount: _dataArray.length,
        ),
      ),
    );
  }

  void _refresh() {
    _dataArray.clear();
    for (int i = 0; i < 13; i++) {
      MsgListModel model = MsgListModel(
          time: '12:00:00',
          title: '关于财务发出的返利对账单中的应扣',
          content:
          '各位经理： 财务发出的返利对账单中有一项是应扣返利，是指冰柜总数减掉系统录入数和上报库存之间的差是指冰柜总数减掉系统录入数和上报库存之间的差是指冰柜总数减掉系统录入数和上报库存之间的差是指冰柜总数减掉系统录入数和上报库存之间的差是指冰柜总数减掉系统录入数和上报库存之间的差',
          enclosureName: '附件名称',
          enclosureSize: '1.2M',
          enclosureURL: 'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
          forDuiZhangDan: true,
      );
      if(i % 2 == 0)
        model.setSign(true);
      _dataArray.add(model);
    }
    if (mounted) setState(() {});
  }
}
