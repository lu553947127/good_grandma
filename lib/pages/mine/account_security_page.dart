import 'package:flutter/material.dart';
import 'package:good_grandma/pages/mine/alert_pwd_page.dart';
import 'package:good_grandma/pages/mine/my_info_page.dart';

///账号安全
class AccountSecurityPage extends StatelessWidget {
  const AccountSecurityPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('账号安全')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('账号信息'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => MyInfoPage())),
              ),
            ),
            SizedBox(height: 10.0),
            Card(
              child: ListTile(
                title: const Text('修改密码'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AlertPWDPAge())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
