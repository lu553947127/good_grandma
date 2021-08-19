import 'package:flutter/material.dart';

class WorkTypeTitle extends StatefulWidget {

  Color color;
  String type;
  List<Map> list;
  final void Function() onPressed;
  final void Function() onPressed2;
  final void Function() onPressed3;

  WorkTypeTitle({Key key
    , @required this.color
    , @required this.type
    , @required this.list
    , @required this.onPressed
    , @required this.onPressed2
    , @required this.onPressed3
  }) : super(key: key);

  @override
  _WorkTypeTitleState createState() => _WorkTypeTitleState();
}

class _WorkTypeTitleState extends State<WorkTypeTitle> {

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

    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(10),
        color: widget.color,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
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
                width: 100,
                height: 35,
                decoration: BoxDecoration(
                  color: _setBgColor(widget.list[1]['name'])
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
              ),
              Container(
                width: 100,
                height: 35,
                decoration: BoxDecoration(
                  color: _setBgColor(widget.list[2]['name'])
                  , borderRadius: BorderRadius.only(topLeft: Radius.circular(0.0), bottomLeft: Radius.circular(0.0), topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0))
                  , border:  Border.all(width: 1, color: Color(0xFFC68D3E)),
                ),
                child: TextButton(
                  child: Text(widget.list[2]['name'], style: TextStyle(fontSize: 12, color: _setTextColor(widget.list[2]['name']))),
                  onPressed: (){
                    setState(() {
                      widget.type = widget.list[2]['name'];
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

