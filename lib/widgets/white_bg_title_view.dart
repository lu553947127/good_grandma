import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

class WhiteBGTitleView extends StatelessWidget {
  const WhiteBGTitleView({
    Key key,
    @required String title,
  })  : _title = title,
        super(key: key);

  final String _title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
      child: Text(
        _title,
        style: const TextStyle(color: AppColors.FF2F4058, fontSize: 14.0),
      ),
    );
  }
}