import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///合同内容顶部标题
class ContractContentTitle extends StatelessWidget {
  const ContractContentTitle({
    Key key,
    @required String title,
  })  : _title = title,
        super(key: key);

  final String _title;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.0))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 9.0),
                child: Image.asset('assets/images/contract_icon.png',
                    width: 30, height: 30),
              ),
              Expanded(
                child: Text(_title,
                    style: const TextStyle(
                        color: AppColors.FF2F4058, fontSize: 14.0)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
