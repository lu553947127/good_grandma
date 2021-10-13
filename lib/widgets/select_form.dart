import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/models/file_model.dart';
import 'package:good_grandma/pages/files/in_folder_page.dart';
import 'package:good_grandma/widgets/picture_big_view.dart';
import 'package:url_launcher/url_launcher.dart';

///OA单选选择页面
class SelectFormPage extends StatelessWidget {
  SelectFormPage({Key key,
    this.url,
    this.title,
    this.props
  }) : super(key: key);

  final String url;
  final String title;
  final Map props;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(title,style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: FutureBuilder(
        future: requestGet(url),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            var data = jsonDecode(snapshot.data.toString());
            LogUtil.d('请求结果---url----$data');
            List<Map> list = (data['data'] as List).cast();
            LogUtil.d('请求结果---list----$list');
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Center(
                    child: Text(list[index][props['label']], style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))),
                  ),
                  onTap: () {
                    String value = list[index][props['label']];
                    Navigator.of(context).pop(value);
                  }
                );
              }
            );
          }else {
            return Center(
              child: CircularProgressIndicator(color: AppColors.FFC68D3E),
            );
          }
        }
      )
    );
  }
}

///选择返回回调
Future<String> showSelect(BuildContext context, url, title, props) async {
  String result;
  result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SelectFormPage(
        url: url,
        title: title,
        props: props,
      ),
    ),
  );
  return result ?? "";
}

///跳转公共选择字典页
class SelectListFormPage extends StatelessWidget {
  SelectListFormPage({Key key,
    this.url,
    this.title,
    this.props
  }) : super(key: key);

  final String url;
  final String title;
  final String props;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(title,style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: FutureBuilder(
        future: requestGet(url),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            var data = jsonDecode(snapshot.data.toString());
            LogUtil.d('请求结果---$url----$data');
            List<Map> list = (data['data'] as List).cast();
            LogUtil.d('请求结果---list----$list');
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Center(
                    child: Text(list[index][props], style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(list[index]);
                  }
                );
              }
            );
          }else {
            return Center(
              child: CircularProgressIndicator(color: AppColors.FFC68D3E),
            );
          }
        },
      ),
    );
  }
}

///选择返回回调
Future<Map> showSelectList(BuildContext context, url, title, props) async {
  Map result;
  result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SelectListFormPage(
        url: url,
        title: title,
        props: props,
      )
    )
  );
  return result ?? "";
}

///跳转公共选择文件柜页
class SelectListFilePage extends StatefulWidget {
  const SelectListFilePage({Key key}) : super(key: key);

  @override
  _SelectListFilePageState createState() => _SelectListFilePageState();
}

class _SelectListFilePageState extends State<SelectListFilePage> {

  String id = '';
  String name = '';
  String path = '';
  String type = '';
  String iconName = '';

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> map = {
      'parentId': '1',
      'isDeleted': '0'
    };

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('我的文件柜', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
        actions: [
          TextButton(
              child: Text("确定", style: TextStyle(fontSize: 14, color: Color(0xFFC08A3F))),
              onPressed: () {
                if (id == ''){
                  Fluttertoast.showToast(msg: '选择不能为空哦', gravity: ToastGravity.CENTER);
                  return;
                }

                Map result = new Map();
                result['name'] = name;
                result['path'] = path;
                result['type'] = type;
                result['iconName'] = iconName;
                Navigator.of(context).pop(result);
              }
          )
        ],
      ),
      body: FutureBuilder(
        future: requestGet(Api.fileCabinetList, param: map),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            var data = jsonDecode(snapshot.data.toString());
            LogUtil.d('请求结果---fileCabinetList----$data');
            List<FileModel> fileCabinetList = [];
            final List<dynamic> list = data['data'];
            list.forEach((map) {
              FileModel model = FileModel.fromJson(map);
              fileCabinetList.add(model);
            });
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                FileModel model = fileCabinetList[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
                  child: Card(
                      child: ListTile(
                        onTap: () {
                          if (model.isFolder) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => InFolderPage(folderModel: model)));
                          } else {
                            if (model.type == 'png' || model.type == 'jpg' || model.type == 'jpeg'){
                              List<String> imagesList = [];
                              imagesList.add(model.path);
                              Navigator.of(context).push(FadeRoute(page: PhotoViewGalleryScreen(
                                images: imagesList,//传入图片list
                                index: 0,//传入当前点击的图片的index
                                heroTag: 'simple',//传入当前点击的图片的hero tag （可选）
                              )));
                            }else {
                              _launchURL(model.path);
                            }
                          }
                        },
                        leading: Image.asset(model.iconName, width: 25, height: 25),
                        title: Text(model.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(model.isFolder == true ? model.author : model.sizeString + ' ' + model.author),
                            SizedBox(height: 5),
                            Text(model.updateTime)
                          ],
                        ),
                        trailing: Visibility(
                            visible: !model.isFolder,
                            child: IconButton(
                                onPressed: () {
                                  id = model.id;
                                  name = model.name;
                                  path = model.path;
                                  type = model.type;
                                  iconName = model.iconName;

                                  setState(() {});
                                },
                                icon: id == model.id ?
                                Icon(Icons.radio_button_checked, color: AppColors.FFC08A3F):
                                Icon(Icons.radio_button_unchecked))),
                      )),
                );
              }
            );
          }else {
            return Center(
              child: CircularProgressIndicator(color: AppColors.FFC68D3E),
            );
          }
        }
      )
    );
  }

  ///用内置浏览器打开网页
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: 'Could not launch $url', gravity: ToastGravity.CENTER);
    }
  }
}

///选择返回回调
Future<Map> showSelectFileList(BuildContext context) async {
  Map result;
  result = await Navigator.push(context, MaterialPageRoute(builder: (context) => SelectListFilePage()));
  return result ?? "";
}