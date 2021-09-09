import 'package:good_grandma/common/clean_cache.dart';

class FileModel {
  bool isFolder;
  String name;
  //B
  double size;
  String author;
  String updateTime;
  String createTime;
  String id;
  String url;
  String path;
  String type;
  FileModel({
    this.name = '',
    this.size = 0,
    this.author = '',
    this.updateTime = '',
    this.isFolder = false,
    this.createTime = '',
    this.id = '',
    this.url = '',
    this.path = '',
    this.type = '',
  });

  String get iconName => _getTypeFromName(fileName: name);
  String get sizeString => CleanCache.renderSize(size);

  String _getTypeFromName({String fileName = ''}) {
    String name = 'assets/images/file_other.png';
    if (fileName == null && fileName.isEmpty) return name;
    if (isFolder) return 'assets/images/file_folder.png';
    String last = '';
    try {
      last = fileName.split('.').last;
      type = last;
    } on Exception catch (e, s) {
      print(s);
    }
    switch (last.toLowerCase()) {
      case 'cda':
      case 'wav':
      case 'aiff':
      case 'aif':
      case 'mp3':
      case 'mid':
      case 'wma':
      case 'ra':
      case 'vqf':
      case 'ogg':
      case 'amr':
      case 'ape':
      case 'flac':
      case 'aac':
        name = 'assets/images/file_audio.png';
        break;
      case 'wmv':
      case 'asf':
      case 'asx':
      // case 'rm':
      case 'rmvb':
      case 'mp4':
      case '3gp':
      case 'mov':
      case 'm4v':
      case 'avi':
      case 'dat':
      case 'mkv':
      case 'flv':
      case 'vob':
        name = 'assets/images/file_video.png';
        break;
      case 'docx':
      case 'docm':
      case 'dotx':
      case 'dotm':
      case 'doc':
        name = 'assets/images/file_doc.png';
        break;
      case 'xlsx':
      case 'xlsm':
      case 'xltx':
      case 'xltm':
      case 'xlsb':
      case 'xlam':
      case 'xls':
        name = 'assets/images/file_xls.png';
        break;
      case 'pptx':
      case 'pptm':
      case 'potx':
      case 'potm':
      case 'ppam':
      case 'ppsx':
      case 'ppsm':
      case 'sldx':
      case 'sldm':
      case 'thmx':
      case 'ppt':
        name = 'assets/images/file_ppt.png';
        break;
      case 'bmp':
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        name = 'assets/images/file_image.png';
        break;
      case 'zip':
      case 'rar':
        name = 'assets/images/file_package.png';
        break;
      case 'txt':
        name = 'assets/images/file_txt.png';
        break;
    }
    return name;
  }
}
