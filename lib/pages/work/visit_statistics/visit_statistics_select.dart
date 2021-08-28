import 'package:flutter/material.dart';

class VisitStatisticsSelect extends StatefulWidget {

  Color color;
  String type;
  List<Map> list;
  final void Function() onPressed;
  final void Function() onPressed2;

  VisitStatisticsSelect({Key key
    , @required this.color
    , @required this.type
    , @required this.list
    , @required this.onPressed
    , @required this.onPressed2
  }) : super(key: key);

  @override
  _VisitStatisticsSelectState createState() => _VisitStatisticsSelectState();
}

class _VisitStatisticsSelectState extends State<VisitStatisticsSelect> {

  @override
  Widget build(BuildContext context) {

    _setTextColor(title){
      if(title.contains(widget.type)){
        return Colors.white;
      }else{
        return Color(0xFFC68D3E);
      }
    }

    _setBgColor(title){
      if(title.contains(widget.type)){
        return Color(0xFFC68D3E);
      }else{
        return Colors.white;
      }
    }
    final double w = (MediaQuery.of(context).size.width - 15 * 2) / 3;
    return SliverToBoxAdapter(
        child: Container(
            padding: EdgeInsets.all(10),
            color: widget.color,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: w,
                    height: 35,
                    decoration: BoxDecoration(
                      color: _setBgColor(widget.list[0]['name'])
                      , borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0), topRight: Radius.circular(0.0), bottomRight: Radius.circular(0.0))
                      , border:  Border.all(width: 1, color: Color(0xFFC68D3E)),
                    ),
                    child: TextButton(
                      child: Text(widget.list[0]['name'], style: TextStyle(fontSize: 12, color: _setTextColor(widget.list[0]['name']))),
                      onPressed: (){
                        setState(() {
                          widget.type = widget.list[0]['name'];
                        });
                      },
                    ),
                  ),
                  Container(
                    width: w,
                    height: 35,
                    decoration: BoxDecoration(
                      color: _setBgColor(widget.list[1]['name'])
                      , borderRadius: BorderRadius.only(topLeft: Radius.circular(0.0), bottomLeft: Radius.circular(0.0), topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0))
                      , border:  Border.all(width: 1, color: Color(0xFFC68D3E)),
                    ),
                    child: TextButton(
                      child: Text(widget.list[1]['name'], style: TextStyle(fontSize: 12, color: _setTextColor(widget.list[1]['name']))),
                      onPressed: (){
                        setState(() {
                          widget.type = widget.list[1]['name'];
                        });
                      },
                    ),
                  )
                ]
            )
        )
    );
  }
}

