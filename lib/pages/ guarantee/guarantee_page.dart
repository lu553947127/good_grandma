import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/widgets/guarantee_cell.dart';

///报修
class GuaranteePage extends StatefulWidget {
  const GuaranteePage({Key key}) : super(key: key);
  @override
  _GuaranteePageState createState() => _GuaranteePageState();
}

class _GuaranteePageState extends State<GuaranteePage> {
  List<Map> _dataArray = [];
  final List<Map> _typeTitles = [
    {'name': '全部', 'color': AppColors.FFE45C26},
    {'name': '未受理', 'color': AppColors.FFE45C26},
    {'name': '待处理', 'color': AppColors.FFC08A3F},
    {'name': '已超时', 'color': AppColors.FFDD0000},
    {'name': '待评价', 'color': AppColors.FF2F4058},
    {'name': '已完成', 'color': AppColors.FF959EB1},
  ];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('报修')),
      body: Scrollbar(
        child: CustomScrollView(slivers: [
          //切换选项卡
          _GuaranteeTypeTitle(
            color: AppColors.FFF4F5F8,
            type: _typeTitles.first['name'],
            list: _typeTitles,
            onTap: (title) {},
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            Map map = _dataArray[index];
            String id = map['id'];
            String type = map['type'];
            String shopName = map['shopName'];
            String name = map['name'];
            String phone = map['phone'];
            String location = map['location'];
            String time = map['time'];
            int state = map['state'];
            String stateName = _typeTitles[state]['name'];
            Color stateColor = _typeTitles[state]['color'];
            List<String> values = [
              id ?? '',
              type ?? '',
              shopName ?? '',
              name ?? '',
              phone ?? '',
              location ?? '',
              time ?? ''
            ];
            return GuaranteeCell(
                values: values, stateName: stateName, stateColor: stateColor);
          }, childCount: _dataArray.length)),
          SliverSafeArea(sliver: SliverToBoxAdapter()),
        ]),
      ),
    );
  }

  _refresh() async {
    _dataArray.clear();
    //state表示保修状态，对应_typeTitles的下标
    _dataArray.addAll([
      {
        'id': 'M00701170731',
        'type': '万宝2016sc',
        'shopName': '农家果园',
        'name': '杨杰',
        'phone': '13526264390',
        'location': '建设路终端',
        'time': '2021-07-01 17:00:00',
        'state': 1
      },
      {
        'id': 'M00701170731',
        'type': '万宝2016sc',
        'shopName': '农家果园',
        'name': '杨杰',
        'phone': '13526264390',
        'location': '建设路终端',
        'time': '2021-07-01 17:00:00',
        'state': 2
      },
      {
        'id': 'M00701170731',
        'type': '万宝2016sc',
        'shopName': '农家果园',
        'name': '杨杰',
        'phone': '13526264390',
        'location': '建设路终端',
        'time': '2021-07-01 17:00:00',
        'state': 3
      },
      {
        'id': 'M00701170731',
        'type': '万宝2016sc',
        'shopName': '农家果园',
        'name': '杨杰',
        'phone': '13526264390',
        'location': '建设路终端',
        'time': '2021-07-01 17:00:00',
        'state': 4
      },
      {
        'id': 'M00701170731',
        'type': '万宝2016sc',
        'shopName': '农家果园',
        'name': '杨杰',
        'phone': '13526264390',
        'location': '建设路终端',
        'time': '2021-07-01 17:00:00',
        'state': 5
      },
    ]);
    if (mounted) setState(() {});
  }
}
///切换选项卡
class _GuaranteeTypeTitle extends StatefulWidget {
  _GuaranteeTypeTitle(
      {Key key,
      @required this.color,
      @required this.type,
      @required this.list,
      @required this.onTap})
      : super(key: key);
  final Color color;
  final String type;
  final List<Map> list;
  final Function(String title) onTap;

  @override
  _GuaranteeTypeTitleState createState() => _GuaranteeTypeTitleState();
}

class _GuaranteeTypeTitleState extends State<_GuaranteeTypeTitle> {
  String _type = '';
  @override
  void initState() {
    _type = widget.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _setTextColor(title) {
      if (title.contains(_type)) {
        return Colors.white;
      } else {
        return Color(0xFFC68D3E);
      }
    }

    _setBgColor(title) {
      if (title.contains(_type)) {
        return Color(0xFFC68D3E);
      } else {
        return Colors.white;
      }
    }

    final double w =
        (MediaQuery.of(context).size.width - 15 * 2) / widget.list.length;
    return SliverToBoxAdapter(
        child: Container(
            padding: EdgeInsets.all(10),
            color: widget.color,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: w,
                height: 35,
                decoration: BoxDecoration(
                  color: _setBgColor(widget.list[0]['name']),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0),
                      topRight: Radius.circular(0.0),
                      bottomRight: Radius.circular(0.0)),
                  border: Border.all(width: 1, color: Color(0xFFC68D3E)),
                ),
                child: TextButton(
                  child: Text(widget.list[0]['name'],
                      style: TextStyle(
                          fontSize: 12,
                          color: _setTextColor(widget.list[0]['name']))),
                  onPressed: () {
                    setState(() {
                      _type = widget.list[0]['name'];
                    });
                    if (widget.onTap != null) widget.onTap(_type);
                  },
                ),
              ),
              Container(
                width: w,
                height: 35,
                decoration: BoxDecoration(
                  color: _setBgColor(widget.list[1]['name']),
                  border: Border.all(width: 1, color: Color(0xFFC68D3E)),
                ),
                child: TextButton(
                  child: Text(widget.list[1]['name'],
                      style: TextStyle(
                          fontSize: 12,
                          color: _setTextColor(widget.list[1]['name']))),
                  onPressed: () {
                    setState(() {
                      _type = widget.list[1]['name'];
                    });
                    if (widget.onTap != null) widget.onTap(_type);
                  },
                ),
              ),
              Container(
                width: w,
                height: 35,
                decoration: BoxDecoration(
                  color: _setBgColor(widget.list[2]['name']),
                  border: Border.all(width: 1, color: Color(0xFFC68D3E)),
                ),
                child: TextButton(
                  child: Text(widget.list[2]['name'],
                      style: TextStyle(
                          fontSize: 12,
                          color: _setTextColor(widget.list[2]['name']))),
                  onPressed: () {
                    setState(() {
                      _type = widget.list[2]['name'];
                    });
                    if (widget.onTap != null) widget.onTap(_type);
                  },
                ),
              ),
              Container(
                width: w,
                height: 35,
                decoration: BoxDecoration(
                  color: _setBgColor(widget.list[3]['name']),
                  border: Border.all(width: 1, color: Color(0xFFC68D3E)),
                ),
                child: TextButton(
                  child: Text(widget.list[3]['name'],
                      style: TextStyle(
                          fontSize: 12,
                          color: _setTextColor(widget.list[3]['name']))),
                  onPressed: () {
                    setState(() {
                      _type = widget.list[3]['name'];
                    });
                    if (widget.onTap != null) widget.onTap(_type);
                  },
                ),
              ),
              Container(
                width: w,
                height: 35,
                decoration: BoxDecoration(
                  color: _setBgColor(widget.list[4]['name']),
                  border: Border.all(width: 1, color: Color(0xFFC68D3E)),
                ),
                child: TextButton(
                  child: Text(widget.list[4]['name'],
                      style: TextStyle(
                          fontSize: 12,
                          color: _setTextColor(widget.list[4]['name']))),
                  onPressed: () {
                    setState(() {
                      _type = widget.list[4]['name'];
                    });
                    if (widget.onTap != null) widget.onTap(_type);
                  },
                ),
              ),
              Container(
                width: w,
                height: 35,
                decoration: BoxDecoration(
                  color: _setBgColor(widget.list[5]['name']),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0.0),
                      bottomLeft: Radius.circular(0.0),
                      topRight: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0)),
                  border: Border.all(width: 1, color: Color(0xFFC68D3E)),
                ),
                child: TextButton(
                  child: Text(widget.list[5]['name'],
                      style: TextStyle(
                          fontSize: 12,
                          color: _setTextColor(widget.list[5]['name']))),
                  onPressed: () {
                    setState(() {
                      _type = widget.list[5]['name'];
                    });
                    if (widget.onTap != null) widget.onTap(_type);
                  },
                ),
              )
            ])));
  }
}
