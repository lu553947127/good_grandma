import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/loading_widget.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/mine/alert_name_page.dart';
import 'package:good_grandma/pages/mine/alert_phone_page.dart';
import 'package:good_grandma/widgets/select_image.dart';

///我的信息
class MyInfoPage extends StatefulWidget {
  const MyInfoPage({Key key}) : super(key: key);

  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();
  String _avatar = '';
  String _name = '';
  String _gender = '';
  String _sex = '';
  String _phone = '';
  String _deptName = '';

  ///0:loading 1:success 2:fail
  int _state = 0;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final divider = const Divider(height: 1, indent: 10.0, endIndent: 10.0);
    return Scaffold(
      appBar: AppBar(title: const Text('我的信息')),
      body: _state == 0
          ? LoadingWidget()
          : _state == 2
              ? LoadFailWidget(
                  retryAction: () {
                    setState(() => _state = 0);
                    _refresh();
                  },
                )
              : Scrollbar(
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        sliver: SliverToBoxAdapter(
                          child: Card(
                            child: Column(
                              children: [
                                ListTile(
                                    title: Row(
                                        children: [
                                          const Text('头像'),
                                          Spacer(),
                                          ClipOval(
                                              child: MyCacheImageView(
                                                imageURL: _avatar,
                                                width: 40,
                                                height: 40,
                                              )
                                          )
                                        ]
                                    ),
                                    trailing: Icon(Icons.chevron_right),
                                    onTap: () async {
                                      aliSignature();
                                    }
                                ),
                                divider,
                                ListTile(
                                  title: Row(
                                    children: [
                                      const Text('姓名'),
                                      Expanded(
                                          child: Text(
                                        _name,
                                        textAlign: TextAlign.end,
                                      ))
                                    ]
                                  ),
                                  trailing: Icon(Icons.chevron_right),
                                  onTap: () async {
                                    String name = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                AlertNamePage(name: _name)));
                                    if (name != null &&
                                        name.isNotEmpty) {
                                      _name = name;
                                      _updateUser(context);
                                      setState(() {});
                                    }
                                  }
                                ),
                                divider,
                                ListTile(
                                  title: Row(
                                    children: [
                                      const Text('性别'),
                                      Spacer(),
                                      Text(_gender),
                                    ]
                                  ),
                                  trailing: Icon(Icons.chevron_right),
                                  onTap: () async {
                                    String result = await showPicker(['男', '女'], context);
                                    if (result != null)
                                      _sex = result == '男' ? '1' : '2';
                                    _gender = result;
                                    _updateUser(context);
                                    setState(() {});
                                  }
                                ),
                                divider,
                                ListTile(
                                  title: Row(
                                    children: [
                                      const Text('手机号'),
                                      Spacer(),
                                      Text(_phone),
                                    ]
                                  ),
                                  trailing: Icon(Icons.chevron_right),
                                  onTap: () async {
                                    String phone = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => AlertPhonePage()));
                                    if (phone != null &&
                                        phone.isNotEmpty &&
                                        phone.length == 11 &&
                                        phone != _phone) {
                                      _phone = phone;
                                      _updateUser(context);
                                      setState(() {});
                                    }
                                  }
                                ),
                                divider,
                                ListTile(
                                  title: Row(
                                    children: [
                                      const Text('大区'),
                                      Spacer(),
                                      Text(_deptName),
                                    ],
                                  ),
                                  trailing: null,
                                  onTap: null
                                )
                              ]
                            )
                          )
                        )
                      )
                    ]
                  )
                )
    );
  }

  ///刷新用户数据
  void _refresh() async {
    Map<String, dynamic> map = {
      'userId': Store.readUserId()
    };

    requestGet(Api.getUserInfoById, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---getUserInfoById----$data');
      await Future.delayed(Duration(seconds: 1));
      _avatar = data['data']['avatar'];
      _name = data['data']['name'];
      _gender = data['data']['sex'] == 1 ? '男' : '女';
      _phone = data['data']['phone'].toString();
      _deptName = data['data']['deptName'];
      _state = 1;
      if (mounted) setState(() {});
    });
  }

  ///修改用户信息
  void _updateUser(BuildContext context){
    Map<String, dynamic> map = {
      'name': _name,
      'sex': _sex,
      'phone': _phone,
      'avatar': _avatar
    };

    LogUtil.d('updateUser---map----$map');

    requestPost(Api.updateUser, formData: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---updateUser----$data');
      if (data['code'] == 200){
        showToast("成功");
        _refresh();
      }else {
        showToast(data['msg']);
      }
    });
  }

  ///获取阿里oss配置信息
  aliSignature(){
    Map<String, dynamic> map = {'dir': 'user'};
    requestPost(Api.aliSignature, json: jsonEncode(map)).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---aliSignature----$data');
      Store.saveOssAccessKeyId(data['data']['accessId']);
      Store.saveOssEndpoint(data['data']['host']);
      Store.saveOssPolicy(data['data']['policy']);
      Store.saveOssSignature(data['data']['signature']);
      Store.saveOssDir(data['data']['dir']);

      showImageRange(
          context: context,
          callBack: (Map param){
            _avatar = param['image'];
            _updateUser(context);
            setState(() {});
          }
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _editingController?.dispose();
    _focusNode?.dispose();
  }
}
