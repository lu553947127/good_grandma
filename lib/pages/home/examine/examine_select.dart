import 'package:flutter/material.dart';
import 'package:good_grandma/pages/home/examine/examine_add.dart';

class ExamineSelectDialog extends StatelessWidget {
  final List<Map> list;
  ExamineSelectDialog({Key key, @required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (context,setBottomSheetState){
          return Stack(
            children: [
              Container(
                height: 25,
                width: double.infinity,
                color: Colors.black54,
              ),
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (content, index){
                      return ListTile(
                        title: Center(
                          child: Text(list[index]['name'], style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))),
                        ),
                        onTap: (){
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder:(context)=> ExamineAdd(
                            name: list[index]['name'],
                            processId: list[index]['id'],
                          )));
                        },
                      );
                    }
                ),
              )
            ],
          );
        }
    );
  }
}
