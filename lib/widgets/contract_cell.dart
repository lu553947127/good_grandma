import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///合同列表cell
class ContractCell extends StatelessWidget {
  const ContractCell({
    Key key,
    @required this.title,
    @required this.signed,
    @required this.type,
    @required this.signUser,
    @required this.signTime,
    @required this.endSignTime,
    @required this.onTap,
  }) : super(key: key);

  final String title;
  final bool signed;
  final String type;
  final String signUser;
  final String signTime;
  final String endSignTime;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color cardColor = !signed ? AppColors.FFE45C26 : AppColors.FF959EB1;
    return ListTile(
      onTap: onTap,
      title: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Image.asset('assets/images/contract_icon.png',
                      width: 30, height: 30),
                  Expanded(
                      child: Text('  ' + title,
                          style: const TextStyle(
                              color: AppColors.FF2F4058, fontSize: 14.0),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis)),
                  Card(
                    color: cardColor.withOpacity(0.1),
                    shadowColor: cardColor.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7.5, vertical: 5),
                      child: !signed
                          ? Text('未签署',
                              style: TextStyle(
                                  color: cardColor, fontSize: 11.0))
                          : Text('已签署',
                              style: TextStyle(
                                  color: cardColor, fontSize: 11.0)),
                    ),
                  )
                ],
              ),
            ),
            const Divider(color: AppColors.FFEFEFF4, thickness: 1, height: 1),
            Container(
              color: AppColors.FFEFEFF4.withOpacity(0.4),
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    '合同类型：' + type,
                    style: const TextStyle(
                        color: AppColors.FF959EB1, fontSize: 11.0),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: signed
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '签署人：' + signUser,
                          style: const TextStyle(
                              color: AppColors.FF959EB1, fontSize: 12.0),
                        ),
                        Text(
                          '签署时间：' + signTime,
                          style: const TextStyle(
                              color: AppColors.FF959EB1, fontSize: 12.0),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Image.asset('assets/images/contract_wait.png',
                            width: 10, height: 12),
                        Expanded(
                            child: Text(
                          ' 等待' + signUser + '审批',
                          style: const TextStyle(
                              color: AppColors.FFE45C26, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )),
                        Text(
                          '签署截止时间：' + endSignTime,
                          style: const TextStyle(
                              color: AppColors.FFDD0000, fontSize: 12),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
