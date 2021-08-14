import 'package:flutter/material.dart';

class WorkTypeTitle extends StatefulWidget {
  const WorkTypeTitle({Key key}) : super(key: key);

  @override
  _WorkTypeTitleState createState() => _WorkTypeTitleState();
}

class _WorkTypeTitleState extends State<WorkTypeTitle> {

  String type = '我收到的';

  @override
  Widget build(BuildContext context) {

    _setTextColor(title){
      if(title.contains(type)){
        return Colors.white;
      }else{
        return Color(0xFFC68D3E);
      }
    }

    _setBgColor(title){
      if(title.contains(type)){
        return Color(0xFFC68D3E);
      }else{
        return Colors.white;
      }
    }

    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 35,
                decoration: BoxDecoration(
                  color: _setBgColor('我收到的')
                  , borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0), topRight: Radius.circular(0.0), bottomRight: Radius.circular(0.0))
                  , border:  Border.all(width: 1, color: Color(0xFFC68D3E)),
                ),
                child: TextButton(
                  child: Text('我收到的', style: TextStyle(fontSize: 12, color: _setTextColor('我收到的'))),
                  onPressed: (){
                    setState(() {
                      type = '我收到的';
                    });
                  },
                ),
              ),
              Container(
                width: 100,
                height: 35,
                decoration: BoxDecoration(
                  color: _setBgColor('我提交的')
                  , border:  Border.all(width: 1, color: Color(0xFFC68D3E)),
                ),
                child: TextButton(
                  child: Text('我提交的', style: TextStyle(fontSize: 12, color: _setTextColor('我提交的'))),
                  onPressed: (){
                    setState(() {
                      type = '我提交的';
                    });
                  },
                ),
              ),
              Container(
                width: 100,
                height: 35,
                decoration: BoxDecoration(
                  color: _setBgColor('我的草稿')
                  , borderRadius: BorderRadius.only(topLeft: Radius.circular(0.0), bottomLeft: Radius.circular(0.0), topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0))
                  , border:  Border.all(width: 1, color: Color(0xFFC68D3E)),
                ),
                child: TextButton(
                  child: Text('我的草稿', style: TextStyle(fontSize: 12, color: _setTextColor('我的草稿'))),
                  onPressed: (){
                    setState(() {
                      type = '我的草稿';
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

