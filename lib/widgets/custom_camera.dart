import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

///拍照图片生成文字水印
class WatermarkPhoto extends StatefulWidget {
  static const String SAVE_DIR = 'tempImage';

  final double aspectRatio;
  final double pixelRatio;
  final String address;

  WatermarkPhoto({this.aspectRatio, this.pixelRatio, this.address});

  @override
  _WatermarkPhotoState createState() => _WatermarkPhotoState();
}

class _WatermarkPhotoState extends State<WatermarkPhoto> with WidgetsBindingObserver {
  final GlobalKey _cameraKey = GlobalKey();
  CameraController _cameraController;
  String _time;
  String _address;
  TakeStatus _takeStatus = TakeStatus.preparing;
  XFile _curFile;
  Timer _timer;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _time = formatDate(DateTime.now(), [yyyy, '-', mm, '-' , dd, ' ', HH, ':', nn, ':', ss]);
    if (widget.address.isEmpty){
      _address = '未知位置';
    }else {
      _address = widget.address;
    }
    _initCamera();
  }

  void _initCamera() async {
    try {
      _timer?.cancel();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _time = formatDate(DateTime.now(), [yyyy, '-', mm, '-' , dd, ' ', HH, ':', nn, ':', ss]);
          });
        }
      });
      setState(() {
        _takeStatus = TakeStatus.preparing;
      });
      List cameras = await availableCameras();
      _cameraController = CameraController(cameras.first, ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      _cameraController.addListener(() {
        if (mounted) setState(() {});
      });
      await _cameraController.initialize();
      if (mounted) {
        setState(() {
          _takeStatus = TakeStatus.taking;
        });
      }
    } on CameraException catch (e) {
      print(e);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_cameraController != null) {
        _initCamera();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildCameraArea(),
          _buildTopBar(),
          _buildAction(),
        ],
      ),
    );
  }

  Widget _buildCameraArea() {
    Widget area;
    if (_takeStatus == TakeStatus.confirm && _curFile != null) {
      area = Image.file(File(_curFile.path), fit: BoxFit.fitWidth,);
    } else if (_cameraController != null && _cameraController.value.isInitialized) {
      final double screenWidth = MediaQuery.of(context).size.width;
      area = ClipRect(
        child: OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Container(
                  width: screenWidth,
                  height: screenWidth * _cameraController.value.aspectRatio,
                  child: CameraPreview(_cameraController),
                )
            )
        ),
      );
    } else {
      area = Container(color: Colors.black,);
    }

    return Center(
      child: RepaintBoundary(
        key: _cameraKey,
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: widget.aspectRatio ?? 4 / 3,
              child: area,
            ),
            Positioned(
                left: 120,
                right: 10,
                bottom: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_time ?? '', style: TextStyle(color: Colors.white, fontSize: 13),),
                    Text(_address ?? '', style: TextStyle(color: Colors.white, fontSize: 13),),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    String flashIcon = 'assets/images/icon-flash-auto.png';
    if (_cameraController != null && _cameraController.value.isInitialized) {
      switch (_cameraController.value.flashMode) {
        case FlashMode.auto:
          flashIcon = 'assets/images/icon-flash-auto.png';
          break;
        case FlashMode.off:
          flashIcon = 'assets/images/icon-flash-off.png';
          break;
        case FlashMode.always:
        case FlashMode.torch:
          flashIcon = 'assets/images/icon-flash-on.png';
          break;
      }
    }

    if (_takeStatus == TakeStatus.confirm) {
      return Container();
    }

    return Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 10,
        right: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                color: Colors.white,
                icon: Icon(Icons.arrow_back, size: 32,),
                onPressed: () => Navigator.of(context).pop()
            ),
            IconButton(
                color: Colors.white,
                icon: Image.asset(flashIcon, width: 32, height: 32,),
                onPressed: _toggleFlash
            )
          ],
        )
    );
  }

  Widget _buildAction() {
    Widget child;
    if (_takeStatus == TakeStatus.confirm) {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlineButton(
              shape: CircleBorder(),
              color: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.all(10),
              borderSide: BorderSide(color: Colors.grey),
              child: Image.asset('assets/images/icon-close.png', width: 24, height: 24,),
              onPressed: _cancel
          ),
          OutlineButton(
              shape: CircleBorder(),
              color: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.all(10),
              borderSide: BorderSide(color: Colors.grey),
              child: Image.asset('assets/images/icon-confirm.png', width: 24, height: 24,),
              onPressed: _confirm
          )
        ],
      );
    } else {
      child = OutlineButton(
          shape: CircleBorder(),
          color: Colors.black.withOpacity(0.5),
          padding: EdgeInsets.all(8),
          borderSide: BorderSide(color: Colors.grey),
          child: Icon(Icons.camera, color: Colors.white, size: 48,),
          onPressed: _takePicture
      );
    }

    return Positioned(
        bottom: 50,
        left: 50,
        right: 50,
        child: child
    );
  }

  /// 切换闪光灯
  void _toggleFlash() {
    if (_cameraController == null) return;

    switch (_cameraController.value.flashMode) {
      case FlashMode.auto:
        _cameraController.setFlashMode(FlashMode.always);
        break;
      case FlashMode.off:
        _cameraController.setFlashMode(FlashMode.auto);
        break;
      case FlashMode.always:
      case FlashMode.torch:
        _cameraController.setFlashMode(FlashMode.off);
        break;
    }
  }

  /// 拍照
  void _takePicture() async {
    if (_cameraController == null || _cameraController.value.isTakingPicture) return;
    _timer?.cancel();

    XFile file = await _cameraController.takePicture();
    setState(() {
      _curFile = file;
      _takeStatus = TakeStatus.confirm;
    });
  }

  /// 取消。重新拍照
  void _cancel() {
    setState(() {
      _takeStatus = TakeStatus.preparing;
    });
    _cameraController?.dispose();
    _initCamera();
  }

  /// 确认。返回图片数据
  void _confirm() async {
    if (_isCapturing) return;
    _isCapturing = true;
    try {
      RenderRepaintBoundary boundary = _cameraKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: widget.pixelRatio ?? 2.0);
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List imgBytes = byteData.buffer.asUint8List();
      String basePath = await findSavePath();
      File file = File('$basePath/${DateTime.now().millisecondsSinceEpoch}.jpg');
      file.writeAsBytesSync(imgBytes);
      print(file);
      Navigator.of(context).pop(file);
    } catch (e) {
      print(e);
    }
    _isCapturing = false;
  }
}

enum TakeStatus {
  /// 准备中
  preparing,
  /// 拍摄中
  taking,
  /// 待确认
  confirm,
  /// 已完成
  done
}

Future<File> takeWatermarkPhoto(BuildContext context, {
  double aspectRatio,
  double pixelRatio,
}) async  {
  return await Navigator.of(context).push(PageRouteBuilder(
    opaque:false,
    pageBuilder: (BuildContext context, Animation<double> animation,Animation<double> secondaryAnimation) {
      return WatermarkPhoto(aspectRatio: aspectRatio, pixelRatio: pixelRatio);
    },
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) => FadeTransition(
      opacity: animation,
      child: child,
    ),
  ));
}

/// 获取文件存储路径
Future<String> findSavePath() async {
  final directory = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationDocumentsDirectory();
  return directory.path;
}

