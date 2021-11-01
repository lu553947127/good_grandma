import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/models/file_model.dart';
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
    this.props,
    this.param
  }) : super(key: key);

  final String url;
  final String title;
  final String props;
  final Map param;

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
        future: requestGet(url, param: param),
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
        }
      )
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
        props: props
      )
    )
  );
  return result ?? "";
}

///选择返回回调（带参数）
Future<Map> showSelectListParameter(BuildContext context, url, title, props, param) async {
  Map result;
  result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SelectListFormPage(
            url: url,
            title: title,
            props: props,
            param: param
          )
      )
  );
  return result ?? "";
}

///跳转公共选择文件柜页
class SelectListFilePage extends StatefulWidget {
  final String parentId;
  const SelectListFilePage({Key key, this.parentId}) : super(key: key);

  @override
  _SelectListFilePageState createState() => _SelectListFilePageState();
}

class _SelectListFilePageState extends State<SelectListFilePage> {

  String id = '';
  String name = '';
  String path = '';
  String type = '';
  String iconName = '';

  List<FileModel> fileCabinetList = [];

  ///文件柜列表
  _fileCabinetList(parentId){
    Map<String, dynamic> map = {
      'parentId': parentId,
      'isDeleted': '0',
      'status': '1'
    };
    requestGet(Api.fileCabinetList, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---fileCabinetList----$data');
      fileCabinetList.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        FileModel model = FileModel.fromJson(map);
        fileCabinetList.add(model);
      });
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _fileCabinetList(widget.parentId);
  }

  @override
  Widget build(BuildContext context) {
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
      body: fileCabinetList.length > 0 ?
      ListView.builder(
          itemCount: fileCabinetList.length,
          itemBuilder: (BuildContext context, int index) {
            FileModel model = fileCabinetList[index];
            return Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
              child: Card(
                  child: ListTile(
                    onTap: () {
                      if (model.isFolder) {
                        _fileCabinetList(model.id);
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
      ):
      Container(
          margin: EdgeInsets.all(40),
          child: Center(child: Image.asset('assets/images/icon_empty_images.png', width: 150, height: 150))
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
  result = await Navigator.push(context, MaterialPageRoute(builder: (context) => SelectListFilePage(parentId: '1')));
  return result ?? "";
}