import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/provider/image_provider.dart';
import 'package:good_grandma/widgets/add_content_input.dart';
import 'package:good_grandma/widgets/add_text_input.dart';
import 'package:good_grandma/widgets/add_text_select.dart';
import 'package:good_grandma/widgets/photos_cell.dart';
import 'package:good_grandma/widgets/select_form.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

///客户拜访
class CustomerVisitAdd extends StatefulWidget {
  const CustomerVisitAdd({Key key}) : super(key: key);

  @override
  _CustomerVisitAddState createState() => _CustomerVisitAddState();
}

class _CustomerVisitAddState extends State<CustomerVisitAdd> {

  bool _isNewCustomer = false;//是否新客户

  ImagesProvider imagesProvider = new ImagesProvider();
  String customerId = '';
  String customerName = '';
  String visitContent = '';
  double latitude = 0.0;
  double longitude = 0.0;
  String address = '定位获取失败，请检查定位权限是否开启';
  String images = '';

  ///新增
  _customerVisitAdd(){

    if (customerName == ''){
      showToast('客户不能为空');
      return;
    }

    if (visitContent == ''){
      showToast('内容不能为空');
      return;
    }

    if (imagesProvider.urlList.length != 0){
      images = listToString(imagesProvider.urlList);
    }

    Map<String, dynamic> map = {
      'customerId': customerId,
      'customerName': customerName,
      'visitContent': visitContent,
      'ipicture': images,
      'latitude': latitude,
      'longitude': longitude,
      'address': address};

    LogUtil.d('请求结果---customerVisitAdd----$map');

    requestPost(Api.customerVisitAdd, json: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---customerVisitAdd----$data');
      if (data['code'] == 200){
        showToast("添加成功");
        Navigator.of(Application.appContext).pop('refresh');
      }else {
        showToast(data['msg']);
      }
    });
  }

  StreamSubscription<Map<String, Object>> _locationListener;
  AMapFlutterLocation _locationPlugin = new AMapFlutterLocation();

  @override
  void initState() {
    super.initState();

    /// 动态申请定位权限
    _requestPermission();

    AMapFlutterLocation.setApiKey(AppUtil.aMapAndroidKey, AppUtil.aMapiOSKey);

    ///iOS 获取native精度类型
    if (Platform.isIOS) _requestAccuracyAuthorization();

    ///注册定位结果监听
    _locationListener = _locationPlugin
        .onLocationChanged()
        .listen((Map<String, Object> result) {
      _locationResultDeal(result);
    });
  }

  @override
  void dispose() {
    super.dispose();

    ///移除定位监听
    if (null != _locationListener) {
      _locationListener?.cancel();
    }

    ///销毁定位
    _locationPlugin.destroy();
  }

  /// 动态申请定位权限
  void _requestPermission() async {
    // 申请权限
    bool hasLocationPermission = await _requestLocationPermission();
    if (hasLocationPermission) {
      _startLocation();
    } else {
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
    }
  }

  ///处理定位结果
  void _locationResultDeal(Map<String, Object> result) async {
    print('address${result['address']}');
    address = result['address'];
    // final streetNumber = result['streetNumber'];
    latitude = result['latitude'];
    longitude = result['longitude'];
    setState(() {});
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("客户拜访",style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                color: Colors.white,
                height: 60,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('是否新客户',style: TextStyle(fontSize: 15, color: AppColors.FF070E28)),
                      Checkbox(
                          value: _isNewCustomer,
                          activeColor: Color(0xFFC68D3E),
                          onChanged: (value){
                            setState(() {
                              _isNewCustomer = value;
                            });
                          }
                      )
                    ]
                )
            ),
            Offstage(
                offstage: _isNewCustomer ? false : true,
                child: TextInputView(
                    rightLength: 120,
                    leftTitle: '客户姓名',
                    rightPlaceholder: '请输入客户名称',
                    onChanged: (tex){
                      customerName = tex;
                    }
                )
            ),
            Offstage(
                offstage: _isNewCustomer ? true : false,
                child: TextSelectView(
                    sizeHeight: 1,
                    leftTitle: '客户名称',
                    rightPlaceholder: '请选择客户',
                    value: customerName,
                    onPressed: () async{
                      Map select = await showSelectList(context, Api.customerList, '请选择客户名称', 'realName');
                      LogUtil.d('请求结果---select----$select');
                      setState(() {
                        customerName = select['realName'];
                        customerId = select['id'];
                      });
                      return select['realName'];
                    }
                )
            ),
            ContentInputView(
              sizeHeight: 10,
              color: Colors.white,
              leftTitle: '行动过程',
              rightPlaceholder: '行动过程',
              onChanged: (tex){
                visitContent = tex;
              }
            ),
            ChangeNotifierProvider<ImagesProvider>.value(
                value: imagesProvider,
                child:  CustomPhotoWidget(
                  title: '拜访图片',
                  length: 3,
                  sizeHeight: 10,
                  url: Api.putFile
                )
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/icon_address.png', width: 12, height: 12),
                  SizedBox(width: 3),
                  Container(
                    width: 300,
                    child: Text(address == null ? '定位获取失败，请检查定位权限是否开启' : address, style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                  )
                ]
              )
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: LoginBtn(
                title: '提交',
                onPressed: _customerVisitAdd
              )
            )
          ]
        )
      )
    );
  }
}
