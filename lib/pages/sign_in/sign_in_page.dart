import 'dart:async';
import 'dart:io';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/pages/sign_in/sign_in_census_page.dart';
import 'package:permission_handler/permission_handler.dart';

///签到
class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<SignInPage> {
  final avatar =
      'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg';
  final name = '黑夜骑士';
  final position = '黑夜骑士';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //签到页面顶部标题栏和用户信息区域
          _SignInHeader(avatar: avatar, name: name, position: position),
          //签到按钮
          _SignInButton(
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

///签到按钮
class _SignInButton extends StatefulWidget {
  const _SignInButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);
  final VoidCallback onPressed;
  @override
  State<StatefulWidget> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<_SignInButton> {
  Timer _timer;
  String _currentTime = '';
  String _locationStr = '未获取到位置信息，点击获取';

  ///标记是否可以签到
  bool _canSignIn = false;

  StreamSubscription<Map<String, Object>> _locationListener;

  AMapFlutterLocation _locationPlugin = new AMapFlutterLocation();

  @override
  void initState() {
    super.initState();
    _currentTime =
        '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';
    _startTimer();

    /// 动态申请定位权限
    _requestPermission();

    ///todo:key都是暂时的
    AMapFlutterLocation.setApiKey(
        'aeb06cd10ca91bc2c77a3a70d89bd6c8', '275249e60a6b2da6b74615bce89e23e9');

    ///iOS 获取native精度类型
    if (Platform.isIOS) _requestAccuracyAuthorization();

    ///注册定位结果监听
    _locationListener = _locationPlugin
        .onLocationChanged()
        .listen((Map<String, Object> result) {
      _locationResultDeal(result);
    });

    _startLocation();
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Color(0xFF959EB1),
      Color(0xFFC1C8D7),
    ];
    if (_canSignIn) {
      colors.clear();
      colors.addAll([
        Color(0xFFC08A3F),
        Color(0xFFCDA161),
      ]);
    }
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            //签到按钮
            TextButton(
              onPressed: () {
                _stopLocation();
                if (widget.onPressed != null) widget.onPressed();
              },
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(150 / 2))),
              child: ClipOval(
                child: Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: colors,
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 17),
                            child: Text(
                              _canSignIn ? '签到打卡' : '无法打卡',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                          ),
                          Text(
                            _currentTime,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 29.0),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            //定位信息
            Padding(
              padding: const EdgeInsets.only(top: 27),
              child: TextButton(
                onPressed: () {
                  _startLocation();
                },
                child: Wrap(
                  children: [
                    Image.asset('assets/images/sign_in_local.png',
                        width: 16, height: 16),
                    Text(' ' + _locationStr,
                        style: const TextStyle(
                            color: AppColors.FF2F4058, fontSize: 14.0)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///开始定位
  void _startLocation() {
    ///开始定位之前设置定位参数
    _setLocationOption();
    _locationPlugin.startLocation();
  }

  ///停止定位
  void _stopLocation() {
    _locationPlugin.stopLocation();
  }

  ///设置定位参数
  void _setLocationOption() {
    AMapLocationOption locationOption = new AMapLocationOption();

    ///是否单次定位
    locationOption.onceLocation = false;

    ///是否需要返回逆地理信息
    locationOption.needAddress = true;

    ///逆地理信息的语言类型
    locationOption.geoLanguage = GeoLanguage.DEFAULT;

    locationOption.desiredLocationAccuracyAuthorizationMode =
        AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;

    locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

    ///设置Android端连续定位的定位间隔
    locationOption.locationInterval = 2000;

    ///设置Android端的定位模式<br>
    ///可选值：<br>
    ///<li>[AMapLocationMode.Battery_Saving]</li>
    ///<li>[AMapLocationMode.Device_Sensors]</li>
    ///<li>[AMapLocationMode.Hight_Accuracy]</li>
    locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

    ///设置iOS端的定位最小更新距离<br>
    locationOption.distanceFilter = -1;

    ///设置iOS端期望的定位精度
    /// 可选值：<br>
    /// <li>[DesiredAccuracy.Best] 最高精度</li>
    /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
    /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
    /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
    /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
    locationOption.desiredAccuracy = DesiredAccuracy.Best;

    ///设置iOS端是否允许系统暂停定位
    locationOption.pausesLocationUpdatesAutomatically = false;

    ///将定位参数设置给定位插件
    _locationPlugin.setLocationOption(locationOption);
  }

  ///获取iOS native的accuracyAuthorization类型
  void _requestAccuracyAuthorization() async {
    AMapAccuracyAuthorization currentAccuracyAuthorization =
        await _locationPlugin.getSystemAccuracyAuthorization();
    if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationFullAccuracy) {
      print("精确定位类型");
    } else if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationReducedAccuracy) {
      print("模糊定位类型");
    } else {
      print("未知定位类型");
      if (mounted)
        setState(() {
          _canSignIn = false;
        });
    }
  }

  /// 动态申请定位权限
  void _requestPermission() async {
    // 申请权限
    bool hasLocationPermission = await _requestLocationPermission();
    if (hasLocationPermission) {
      print("定位权限申请通过");
    } else {
      if (mounted)
        setState(() {
          _canSignIn = false;
        });
      bool result = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('未获取到定位权限'),
              content: Text('无法签到打卡，是否打开定位设置？'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('取消')),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('确定')),
              ],
            );
          });
      if (result != null && result) {
        AppSettings.openAppSettings();
      }
    }
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<bool> _requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  ///处理定位结果
  void _locationResultDeal(Map<String, Object> result) async {
    // final country = result['country'];
    // final province = result['province'];
    // final city = result['city'];
    // final district = result['district'];
    // final street = result['street'];
    final address = result['address'];
    // final streetNumber = result['streetNumber'];
    // final latitude = result['latitude'];
    // final longitude = result['longitude'];
    // //海拔高度 Android: 定位类型为非GPS时，返回0
    // final altitude = result['altitude'];
    final int errorCode = result['errorCode'];
    // print('result = ${result.toString()}');

    if (errorCode == null || errorCode == 0) {
      setState(() {
        _canSignIn = true;
        _locationStr = address ?? '未获取到位置信息，点击获取';
      });
      return;
    }
    String msg = '定位失败，原因未知。errorCode = $errorCode';
    if (Platform.isIOS) {
      if (errorCode < 2 || errorCode > 10) {
        setState(() {
          _canSignIn = true;
          _locationStr = address ?? '未获取到位置信息，点击获取';
        });
        return;
      }
      switch (errorCode) {
        case 2:
          msg = '系统定位发生错误';
          break;
        case 3:
          msg = '获取逆地理编码发生错误';
          break;
        case 4:
          msg = '访问超时，网络情况差，请稍候再试';
          break;
        case 5:
          msg = '取消了单次定位的消息';
          break;
        case 6:
          msg = '服务异常SDK找不到主机，请稍后再试';
          break;
        case 7:
          msg = 'URL可能已被篡改，请检查程序的安全性';
          break;
        case 8:
          msg = '网络异常，无法联网';
          break;
        case 9:
          msg = '传输链路出现问题，请检查您的host是否正常';
          break;
        case 10:
          msg = '地理围栏监测出现异常，请注销掉围栏重新注册围栏使用';
          break;
      }
    } else if (Platform.isAndroid) {
      switch (errorCode) {
        case 1:
          msg = '一些重要参数为空';
          break;
        case 2:
          msg = '定位失败，由于仅扫描到单个wifi，且没有基站信息';
          break;
        case 3:
          msg = '获取到的请求参数为空，可能获取过程中出现异常';
          break;
        case 4:
          msg = '请求服务器过程中的异常';
          break;
        case 5:
          msg = '请求被恶意劫持，定位结果解析失败';
          break;
        case 6:
          msg = '定位服务返回定位失败';
          break;
        case 7:
          msg = 'KEY鉴权失败';
          break;
        case 8:
          msg = 'Android exception常规错误';
          break;
        case 9:
          msg = '定位初始化时出现异常';
          break;
        case 10:
          msg = '定位客户端启动失败';
          break;
        case 11:
          msg = '定位时的基站信息错误，请检查是否安装SIM卡，设备很有可能连入了伪基站网络';
          break;
        case 12:
          msg = '缺少定位权限，请在设备的设置中开启app的定位权限';
          break;
        case 13:
          msg = '定位失败，由于未获得WIFI列表和基站信息，且GPS当前不可用';
          break;
        case 14:
          msg = 'GPS 定位失败，由于设备当前 GPS 状态差';
          break;
        case 15:
          msg = '定位结果被模拟导致定位失败';
          break;
        case 16:
          msg = '当前POI检索条件、行政区划检索条件下，无可用地理围栏';
          break;
        case 18:
          msg = '定位失败，由于手机WIFI功能被关闭同时设置为飞行模式';
          break;
        case 19:
          msg = '定位失败，由于手机没插sim卡且WIFI功能被关闭';
          break;
      }
    }
    _stopLocation();
    if (mounted)
      setState(() {
        _canSignIn = false;
      });
    if (Platform.isAndroid) {
      bool result = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('未获取到定位权限'),
              content: Text(msg + ',无法签到打卡，是否打开定位设置？'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('取消')),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('确定')),
              ],
            );
          });
      if (result != null && result) {
        if (errorCode == 12)
          AppSettings.openLocationSettings();
        else if (errorCode == 4) AppSettings.openWIFISettings();
      }
      return;
    }
    Fluttertoast.showToast(msg: msg);
  }

  ///开始计时器
  void _startTimer() {
    if (_timer != null) {
      return;
    }
    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      if (mounted)
        setState(() {
          _currentTime =
              '${DateTime.now().hour}:${DateTime.now().minute < 10 ? '0' : ''}${DateTime.now().minute}:${DateTime.now().second < 10 ? '0' : ''}${DateTime.now().second}';
        });
    });
  }

  ///销毁计时器
  void _cancelCountTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    super.dispose();
    _cancelCountTimer();

    ///移除定位监听
    if (null != _locationListener) {
      _locationListener?.cancel();
    }

    ///销毁定位
    _locationPlugin.destroy();
  }
}

///签到页面顶部标题栏和用户信息区域
class _SignInHeader extends StatelessWidget {
  const _SignInHeader({
    Key key,
    @required this.avatar,
    @required this.name,
    @required this.position,
  }) : super(key: key);

  final String avatar;
  final String name;
  final String position;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = MediaQuery.of(context).padding;
    // print('padding = $padding');
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          padding.top > 40
              ? Image.asset('assets/images/sign_in_bg_large.png')
              : Image.asset('assets/images/sign_in_bg.png'),
          SafeArea(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                          Platform.isIOS
                              ? Icons.arrow_back_ios
                              : Icons.arrow_back,
                          size: 24,
                          color: Colors.white)),
                  const Text('签到',
                      style: TextStyle(color: Colors.white, fontSize: 18.0)),
                  TextButton(
                    onPressed: null,
                    child: Container(width: 24, height: 24),
                  )
                ],
              ),
              ListTile(
                // contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                leading: ClipOval(
                  child: Container(
                    child: MyCacheImageView(
                      imageURL: avatar,
                      width: 50,
                      height: 50,
                      errorWidgetChild: const Icon(
                          Icons.supervised_user_circle_rounded,
                          size: 50,
                          color: AppColors.FF2F4058),
                    ),
                  ),
                ),
                title: Text(name ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 16.0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                subtitle: Text(position ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 12.0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                trailing: SizedBox(
                  width: 71,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return SignInCensusPage();
                      }));
                    },
                    child: Row(
                      children: [
                        Image.asset('assets/images/sign_in_statistic.png',
                            width: 18, height: 18),
                        const Text(
                          ' 统计',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
