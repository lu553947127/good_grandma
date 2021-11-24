import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/provider/image_provider.dart';
import 'package:good_grandma/widgets/images_detail.dart';
import 'package:good_grandma/widgets/picture_big_view.dart';
import 'package:good_grandma/widgets/progerss_dialog.dart';
import 'package:good_grandma/widgets/select_form.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return NetLoadingDialog(
                requestCallBack: null,
                outsideDismiss: false,
                loadingText: '图片上传中...',
              );
            });
        var byte = await pickedFile.readAsBytes();
        print('pickedFile---size----${byte.length}');

        getPutFile(Api.putFile, pickedFile.path).then((val) async{
          var data = json.decode(val.toString());
          print('请求结果---uploadFile----$data');
          Navigator.pop(context);
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
    this.title,
    this.index,
    this.imagesProvider,
    this.url
  }) : super(key: key);

  final String title;
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
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return NetLoadingDialog(
                  requestCallBack: null,
                  outsideDismiss: false,
                  loadingText: '图片上传中...',
              );
            });
        final tempDir = await getTemporaryDirectory();
        CompressObject compressObject = CompressObject(
            imageFile: File(pickedFile.path),
            path: tempDir.path
        );
        Luban.compressImage(compressObject).then((_path) {
          getPutFile(widget.url, _path).then((val) async{
            var data = json.decode(val.toString());
            print('请求结果---uploadFile----$data');
            Navigator.pop(context);
            widget.imagesProvider.fileList(data['data']['link'], 'png', '');
            widget.imagesProvider.addImageData(data['data']['link'], data['data']['originalName']);
          });
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
          double w = 240.0;
          if (widget.title == '拜访图片'){
            w = 120.0;
          }else {
            w = 240.0;
          }
          return Container(
            height: w,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('拍照', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  }
                ),
                Visibility(
                  visible: widget.title == '拜访图片' ? false : true,
                  child: ListTile(
                      title: Text('从相册选择', textAlign: TextAlign.center),
                      onTap: () {
                        Navigator.pop(context, ImageSource.gallery);
                      }
                  )
                ),
                Visibility(
                    visible: widget.title == '拜访图片' ? false : true,
                    child: ListTile(
                        title: Text('从文件柜选择', textAlign: TextAlign.center),
                        onTap: () async {
                          Navigator.pop(context);
                          Map select = await showSelectFileList(context);
                          print('请求结果---select----$select');
                          widget.imagesProvider.fileList(select['path'], select['type'], select['iconName']);
                          widget.imagesProvider.addImageData(select['path'], select['name']);
                        }
                    )
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
                MyCacheImageView(
                  imageURL: widget.imagesProvider.filePath[widget.index]['image'],
                  width: 192,
                  height: 108,
                  errorWidgetChild: Image.asset('assets/images/icon_empty_user.png', width: 192.0, height: 108.0),
                ):
                // Image.network(widget.imagesProvider.filePath[widget.index]['image'], width: 192, height: 108) :
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
                // Navigator.of(context).push(FadeRoute(page: PhotoViewGalleryScreen(
                //   images: imagesList,//传入图片list
                //   index: widget.index,//传入当前点击的图片的index
                //   heroTag: 'simple',//传入当前点击的图片的hero tag （可选）
                // )));
                Navigator.push(context, MaterialPageRoute(builder:(context)=> ImagesDetailPage(images: imagesList[widget.index])));
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

