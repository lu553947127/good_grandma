import 'package:flutter/material.dart';

///计数器
class NumberCounter extends StatelessWidget {
  const NumberCounter({
    Key key,
    @required this.num,
    @required this.subBtnOnTap,
    @required this.addBtnOnTap,
    @required this.numOnTap,
  }) : super(key: key);

  final int num;
  final VoidCallback subBtnOnTap;
  final VoidCallback addBtnOnTap;
  final VoidCallback numOnTap;

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.grey[400];
    return Container(
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: subBtnOnTap,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(4)),
              ),
              child: Center(
                  child: Text(
                '-',
                style: TextStyle(color: num == 0 ? borderColor : Colors.black),
              )),
            ),
          ),
          GestureDetector(
            onTap: numOnTap,
            child: Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                    border: Border.symmetric(
                        vertical: BorderSide(color: borderColor, width: 1))),
                child: Center(child: Text(num.toString()))),
          ),
          GestureDetector(
            onTap: addBtnOnTap,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.horizontal(right: Radius.circular(4)),
              ),
              child: Center(child: Text('+')),
            ),
          ),
        ],
      ),
    );
  }
}
