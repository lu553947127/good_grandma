import 'package:flutter/cupertino.dart';

///图片上传
class ImagesProvider with ChangeNotifier{

  ///图片地址
  var imgPath;
  ///文件地址结合
  List<Map> filePath = [];
  ///map图片集合
  List<Map> imagePath = [];
  ///图片url集合
  List<String> urlList = [];

  //选择附件图片集合
  fileList(String image, String type, String iconName) async{
    Map addData = new Map();
    addData['image'] = image;
    addData['type'] = type;
    addData['iconName'] = iconName;
    filePath.add(addData);
    notifyListeners();
  }

  //生成接口添加的数据
  addImageData(images, name) async{
    Map addData = new Map();
    addData['label'] = name;
    addData['value'] = images;
    imagePath.add(addData);
    urlList.add(images);
    notifyListeners();
  }

  //选择图片集合删除
  imagesListDelete(int index) async{
    if(filePath.length > 0){
      filePath.removeAt(index);
      imagePath.removeAt(index);
      urlList.removeAt(index);
      notifyListeners();
    }
  }
}