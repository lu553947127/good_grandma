import 'dart:convert';
import 'dart:io';

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
import 'package:image_picker/image_picker.dart';

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
  String _phone = '';
  String _area = '';

  @override
  Widget build(BuildContext context) {
    final divider = const Divider(height: 1, indent: 10.0, endIndent: 10.0);
    return Scaffold(
      appBar: AppBar(title: const Text('我的信息')),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: FutureBuilder(
          future: requestGet(Api.getUserInfoById,
              param: {'userId': Store.readUserId()}),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              LogUtil.d('getUserInfoById value = ${snapshot.data}');
              Map result = jsonDecode(snapshot.data.toString());
              Map data = result['data'];
              _avatar = data['avatar'] ?? '';
              _name = data['name'] ?? '';
              int sex = data['sex'] ?? 1;
              if (sex == 1)
                _gender = '男';
              else
                _gender = '女';
              _phone = data['phone'] ?? '';
              _area = data['deptName'] ?? '';
              return Scrollbar(
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      sliver: SliverToBoxAdapter(
                        child: Card(
                          child: Column(
                            children: [
                              AvatarCell(avatar: _avatar),
                              divider,
                              ListTile(
                                title: Row(
                                  children: [
                                    const Text('姓名'),
                                    Expanded(
                                        child: Text(_name,
                                            textAlign: TextAlign.end)),
                                  ],
                                ),
                                trailing: Icon(Icons.chevron_right),
                                onTap: () async {
                                  String name = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              AlertNamePage(name: _name)));
                                  if (name != null &&
                                      name.isNotEmpty &&
                                      name.length == 11 &&
                                      name != _phone) {
                                    setState(() => _name = name);
                                  }
                                },
                              ),
                              divider,
                              ListTile(
                                title: Row(
                                  children: [
                                    const Text('性别'),
                                    Spacer(),
                                    Text(_gender)
                                  ],
                                ),
                                trailing: Icon(Icons.chevron_right),
                                onTap: () async {
                                  String result =
                                      await showPicker(['男', '女'], context);
                                  if (result != null && result.isNotEmpty)
                                    setState(() => _gender = result);
                                },
                              ),
                              divider,
                              ListTile(
                                title: Row(
                                  children: [
                                    const Text('手机号'),
                                    Spacer(),
                                    Text(_phone),
                                  ],
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
                                    setState(() => _phone = phone);
                                  }
                                },
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
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text('大区'),
                                trailing: Text(_area),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return NoDataWidget(emptyRetry: () => setState(() {}));
            }
            return LoadingWidget();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _editingController?.dispose();
    _focusNode?.dispose();
  }
}

class AvatarCell extends StatefulWidget {
  const AvatarCell({Key key, this.avatar = ''}) : super(key: key);
  final String avatar;

  @override
  _AvatarCellState createState() => _AvatarCellState();
}

class _AvatarCellState extends State<AvatarCell> {
  final _picker = ImagePicker();
  File _image;
  String _imageUrl;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          const Text('头像'),
          Spacer(),
          ClipOval(
            child: MyCacheImageView(
              imageURL: widget.avatar,
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () async {
        //show
        final source = await _showBottomSheet();
        //image
        if (source == null) return;
        final bool result = await _getImage(source);
        if (!result) return;
        setState(() {});
      },
    );
  }

  Future<ImageSource> _showBottomSheet() async {
    return await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 180.0,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('拍照', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                ),
                ListTile(
                  title: Text('从相册选择', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, ImageSource.gallery);
                  },
                ),
                ListTile(
                  title: Text('取消', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<bool> _getImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Pick image error: $e');
      return false;
    }
  }
}
