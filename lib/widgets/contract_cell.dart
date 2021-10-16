import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///合同列表cell
class ContractCell extends StatelessWidget {
  const ContractCell({
    Key key,
    @required this.title,
    @required this.status,
    @required this.signType,
    @required this.signersList,
    @required this.onTap,
  }) : super(key: key);

  final String title;
  final int status;
  final String signType;
  final List<Map> signersList;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {

    ///签署状态颜色
    _setStatusColor(status){
      switch(status){
        case 0://未签署
          return AppColors.FFE45C26;
          break;
        case 1://已发送
          return AppColors.FF12BD95;
          break;
        case 2://签署完成
          return AppColors.FF959EB1;
          break;
        case 3://过期
          return AppColors.FF959EB1;
          break;
        case 4://撤销
          return AppColors.FF959EB1;
          break;
      }
    }

    _setStatusText(status){
      switch(status){
        case 0:
          return '未签署';
          break;
        case 1:
          return '已发送';
          break;
        case 2:
          return '签署完成';
          break;
        case 3:
          return '过期';
          break;
        case 4:
          return '撤销';
          break;
      }
    }

    final Color cardColor = _setStatusColor(status);

    _setTypeText(type){
      switch(type){
        case '0':
          return '经销商合同';
          break;
        case '1':
          return '分销商合同';
          break;
        case '2':
          return '冷冻设备借用协议';
          break;
        case '3':
          return '冷冻设备借用协议（第三方）';
          break;
        case '4':
          return '配送协议';
          break;
      }
    }
    
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
                      child: Text(_setStatusText(status),
                          style: TextStyle(
                              color: cardColor, fontSize: 11.0)),
                    )
                  )
                ]
              )
            ),
            const Divider(color: AppColors.FFEFEFF4, thickness: 1, height: 1),
            Container(
              color: AppColors.FFEFEFF4.withOpacity(0.4),
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    '合同类型：' + _setTypeText(signType),
                    style: const TextStyle(
                        color: AppColors.FF959EB1, fontSize: 11.0),
                  ),
                  Spacer()
                ]
              )
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                physics:NeverScrollableScrollPhysics(),//禁止滚动
                itemCount: signersList.length,
                itemBuilder: (content, index){
                  return Container(
                      margin: EdgeInsets.only(top: 2),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '签署人：' + signersList[index]['name'],
                              style: const TextStyle(
                                  color: AppColors.FF959EB1, fontSize: 12.0),
                            ),
                            Text(
                              '签署时间：' + signersList[index]['signTime'],
                              style: const TextStyle(
                                  color: AppColors.FF959EB1, fontSize: 12.0),
                            )
                          ]
                      )
                  );
                }
              )
            )
          ]
        )
      )
    );
  }
}
