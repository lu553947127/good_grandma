import 'package:flutter/material.dart';
import 'package:good_grandma/common/clean_cache.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/pages/login/login.dart';
import 'package:good_grandma/pages/mine/about_us_page.dart';
import 'package:good_grandma/pages/mine/account_security_page.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:package_info/package_info.dart';

///设置
class SetUpPage extends StatefulWidget {
  const SetUpPage({Key key}) : super(key: key);

  @override
  _SetUpPageState createState() => _SetUpPageState();
}

class _SetUpPageState extends State<SetUpPage> {
  bool _notOn = false;
  String _version = '1.0.0';
  String _cacheSize = '';

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              sliver: SliverToBoxAdapter(
                child: Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('账号安全'),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => AccountSecurityPage())),
                      ),
                      const Divider(height: 1, indent: 10.0, endIndent: 10.0),
                      ListTile(
                        title: const Text('消息免打扰'),
                        trailing: Switch(
                            value: _notOn,
                            onChanged: (value) {
                              setState(() {
                                _notOn = value;
                              });
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              sliver: SliverToBoxAdapter(
                child: Card(
                  child: ListTile(
                    title: const Text('清理缓存'),
                    trailing: Text(_cacheSize.isEmpty ? '清理缓存' : _cacheSize),
                    onTap: () async {
                      _cacheSize = await CleanCache.cleanCache();
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              sliver: SliverToBoxAdapter(
                child: Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('当前版本'),
                        trailing: Text(_version),
                      ),
                      const Divider(height: 1, indent: 10.0, endIndent: 10.0),
                      ListTile(
                        title: const Text('关于我们'),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => AboutUsPage())),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SubmitBtn(
                  title: '退  出',
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            title: Text('温馨提示'),
                            content: Text('确认要退出登录吗？'),
                            actions: <Widget>[
                              TextButton(child: Text('取消',style: TextStyle(color: Color(0xFF999999))),onPressed: (){
                                Navigator.of(context).pop('cancel');
                              }),
                              TextButton(child: Text('确认',style: TextStyle(color: Color(0xFFC08A3F))),onPressed: (){
                                Navigator.of(context).pop('ok');
                                Store.removeToken();
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (_) => LoginPage()));
                              }),
                            ],
                          );
                        });
                  }),
            )
          ],
        ),
      ),
    );
  }

  void _refresh() async {
    _cacheSize = await CleanCache.loadCache();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;
    if (mounted) setState(() {});
  }
}
