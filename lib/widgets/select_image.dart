import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/provider/image_provider.dart';
import 'package:good_grandma/widgets/picture_big_view.dart';
import 'package:good_grandma/widgets/select_form.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

///选择图片弹窗
void showImageRange({@required BuildContext context, @required Function(Map map) callBack}) async {
  final _picker = ImagePicker();
  Map param;

  final source = await showModalBottomSheet(
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

  ///获取图片路径并上传转化成url
  Future<bool> _getImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {

        var byte = await pickedFile.readAsBytes();
        print('pickedFile---size----${byte.length}');

        getPutFile(Api.putFile, pickedFile.path).then((val) async{
          var data = json.decode(val.toString());
          print('请求结果---uploadFile----$data');
          param = {'name': data['data']['originalName'], 'image': data['data']['link'], 'size': byte.length};

          ///回传图片数据
          if (param != null) {
            if (callBack != null) callBack(param);
          }
        });
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Pick image error: $e');
      return false;
    }
  }

  if (source == null) return;
  final bool result = await _getImage(source);
  if (!result) return;
}

///多图片上传
class SelectImagesView extends StatefulWidget {
  SelectImagesView({Key key,
    this.index,
    this.imagesProvider,
    this.url
  }) : super(key: key);

  final int index;
  final ImagesProvider imagesProvider;
  final String url;

  @override
  _SelectImagesViewState createState() => _SelectImagesViewState();
}

class _SelectImagesViewState extends State<SelectImagesView> {

  final ImagePicker _picker = ImagePicker();

  Future<bool> _getImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        getPutFile(widget.url, pickedFile.path).then((val) async{
          var data = json.decode(val.toString());
          print('请求结果---uploadFile----$data');
          widget.imagesProvider.fileList(data['data']['link'], 'png', '');
          widget.imagesProvider.addImageData(data['data']['link'], data['data']['originalName']);
        });
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Pick image error: $e');
      return false;
    }
  }

  Future<ImageSource> _showBottomSheet() async {
    return await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 240.0,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('拍照', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  }
                ),
                ListTile(
                  title: Text('从相册选择', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, ImageSource.gallery);
                  }
                ),
                ListTile(
                    title: Text('从文件柜选择', textAlign: TextAlign.center),
                    onTap: () async {
                      Navigator.pop(context);
                      Map select = await showSelectFileList(context);
                      print('请求结果---select----$select');
                      widget.imagesProvider.fileList(select['path'], select['type'], select['iconName']);
                      widget.imagesProvider.addImageData(select['path'], select['name']);
                    }
                ),
                ListTile(
                  title: Text('取消', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context);
                  }
                )
              ]
            )
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    if(widget.index == widget.imagesProvider.filePath.length){
      return GestureDetector(
        child: Image.asset('assets/images/icon_add_images.png', width: 192, height: 108),
        onTap: () async{
          //show
          final source = await _showBottomSheet();
          //image
          if (source == null) return;
          final bool result = await _getImage(source);
          if (!result) return;
          setState(() {});
        },
      );
    }else{
      return Container(
          child: widget.imagesProvider.filePath.length > widget.index ?
          InkWell(
            child: Stack(
              children: <Widget>[
                widget.imagesProvider.filePath[widget.index]['type'] == 'png' ||
                    widget.imagesProvider.filePath[widget.index]['type'] == 'jpg' ||
                    widget.imagesProvider.filePath[widget.index]['type'] == 'jpeg' ?
                Image.network(widget.imagesProvider.filePath[widget.index]['image'], width: 192, height: 108) :
                Image.asset(widget.imagesProvider.filePath[widget.index]['iconName'], width: 192, height: 108),
                Positioned(
                  right: 0,
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Image.asset('assets/images/icon_delete_images.png', width: 13, height: 13),
                    ),
                    onTap: (){
                      widget.imagesProvider.imagesListDelete(widget.index);
                    }
                  )
                )
              ]
            ),
            onTap: (){
              if (widget.imagesProvider.filePath[widget.index]['type'] == 'png' ||
                  widget.imagesProvider.filePath[widget.index]['type'] == 'jpg' ||
                  widget.imagesProvider.filePath[widget.index]['type'] == 'jpeg'){
                List<String> imagesList = [];
                imagesList.add(widget.imagesProvider.filePath[widget.index]['image']);
                Navigator.of(context).push(FadeRoute(page: PhotoViewGalleryScreen(
                  images: imagesList,//传入图片list
                  index: widget.index,//传入当前点击的图片的index
                  heroTag: 'simple',//传入当前点击的图片的hero tag （可选）
                )));
              }else {
                _launchURL(widget.imagesProvider.filePath[widget.index]['image']);
              }
            },
          ) :
          Container()
      );
    }
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

