import 'package:flutter/material.dart';

///切换选项卡
class SwitchTypeTitleWidget extends StatefulWidget {
  SwitchTypeTitleWidget(
      {Key key,
      @required this.backgroundColor,
      @required this.selIndex,
      @required this.list,
      @required this.onTap})
      : super(key: key);
  final Color backgroundColor;
  final int selIndex;

  ///数据格式[{'name': '全部'}],
  final List<Map> list;
  final Function(int index) onTap;

  @override
  _SwitchTypeTitleWidgetState createState() => _SwitchTypeTitleWidgetState();
}

class _SwitchTypeTitleWidgetState extends State<SwitchTypeTitleWidget> {
  int _selIndex = 0;
  @override
  void initState() {
    _selIndex = widget.selIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double w =
        (MediaQuery.of(context).size.width - 15 * 2) / widget.list.length;
    return Container(
        padding: EdgeInsets.all(10),
        color: widget.backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.list.length, (index) {
            return Container(
              width: w,
              height: 35,
              decoration: BoxDecoration(
                color: _selIndex == index ? Color(0xFFC68D3E) : Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(index == 0 ? 5.0 : 0.0),
                    bottomLeft: Radius.circular(index == 0 ? 5.0 : 0.0),
                    topRight: Radius.circular(
                        index == widget.list.length - 1 ? 5.0 : 0.0),
                    bottomRight: Radius.circular(
                        index == widget.list.length - 1 ? 5.0 : 0.0)),
                border: Border.all(width: 1, color: Color(0xFFC68D3E)),
              ),
              child: TextButton(
                child: Text(widget.list[index]['name'],
                    style: TextStyle(
                        fontSize: 12,
                        color: _selIndex == index
                            ? Colors.white
                            : Color(0xFFC68D3E))),
                onPressed: () {
                  setState(() => _selIndex = index);
                  if (widget.onTap != null) widget.onTap(_selIndex);
                },
              ),
            );
          }),
        ));
  }
}
