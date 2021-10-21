import 'dart:convert';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/employee_model.dart';
import 'package:good_grandma/models/track_model.dart';
import 'package:good_grandma/pages/track/select_user_page.dart';
import 'package:good_grandma/widgets/map_util.dart';

///行动轨迹
class TrackPage extends StatefulWidget {
  const TrackPage({Key key}) : super(key: key);

  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  static const AMapApiKey _aMapApiKey = AMapApiKey(
      androidKey: AppUtil.aMapAndroidKey, iosKey: AppUtil.aMapiOSKey);
  List<TrackModel> _dataArray = [];
  List<EmployeeModel> _userList = [];
  EmployeeModel _selUserModel;
  Map<String, Polyline> _polyLines = <String, Polyline>{};
  //需要先设置一个空的map赋值给AMapWidget的markers，否则后续无法添加marker
  final Map<String, Marker> _markers = <String, Marker>{};
  AMapController _mapController;
  String _startTime = '';
  String _endTime = '';

  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _startTime = now.year.toString() +
        '-' +
        AppUtil.dateForZero(now.month) +
        '-' +
        AppUtil.dateForZero(now.day) +
        ' ' +
        '00:00';
    _endTime = now.year.toString() +
        '-' +
        AppUtil.dateForZero(now.month) +
        '-' +
        AppUtil.dateForZero(now.day) +
        ' ' +
        '23:59';
    _getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(title: const Text('行动轨迹')),
      body: Stack(
        children: [
          AMapWidget(
            apiKey: _aMapApiKey,
            rotateGesturesEnabled: false,
            polylines: Set<Polyline>.of(_polyLines.values),
            markers: Set<Marker>.of(_markers.values),
            onMapCreated: (controller) => _mapController = controller,
          ),
          Visibility(
            visible: _selUserModel != null,
            child: Positioned(
                top: 15,
                left: 15,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border:
                      Border.all(color: AppColors.FFC1C8D7, width: 1)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 9.0),
                  child: GestureDetector(
                    onTap: () async {
                      EmployeeModel result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  SelectUserPage(userList: _userList)));
                      if (result != null) {
                        setState(() => _selUserModel = result);
                        _getTrackWithUser(result);
                      }
                    },
                    child: Row(
                      children: [
                        Text(_selUserModel!=null?_selUserModel.name:''),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                )),
          ),
          Visibility(
            visible: _userList.isNotEmpty,
            child: Positioned(
                top: 15,
                right: 15,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.FFE45C26, width: 1)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 9.0),
                  child: GestureDetector(
                    onTap: () {
                      showPickerDateRange(
                          context: context,
                          callBack: (Map param) {
                            setState(() {
                              _startTime = param['startTime'];
                              _endTime = param['endTime'];
                            });
                            _getTrackWithUser(_selUserModel);
                          });
                    },
                    child: Row(
                      children: [
                        Text(
                            _startTime.isEmpty
                                ? '选择时间段'
                                : _startTime + '\n' + _endTime,
                            style: const TextStyle(color: AppColors.FFE45C26)),
                        Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.FFE45C26,
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  ///获取用户列表
  void _getUserList() async {
    try {
      final val = await requestPost(Api.reportUserList);
      LogUtil.d('${Api.reportUserList} value = $val');
      _userList.clear();
      var data = jsonDecode(val.toString());
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        Map re = map as Map;
        EmployeeModel model = EmployeeModel(
            name: re['name'] ?? '', id: re['id'] ?? '', isSelected: false);
        _userList.add(model);
      });
      if (_userList.isNotEmpty) {
        _selUserModel = _userList.first;
        _getTrackWithUser(_selUserModel);
      }
      else AppUtil.showToastCenter('人员列表为空');
      if (mounted) setState(() {});
    } catch (error) {}
  }

  ///从服务器请求用户轨迹
  void _getTrackWithUser(EmployeeModel userModel) async {
    try {
      Map param = {
        'userId': userModel.id,
        'startDate': _startTime + ':00',
        'endDate': _endTime + ':00'
      };
      // print('param = ${jsonEncode(param)}');
      final val =
          await requestPost(Api.trajectoryList, json: jsonEncode(param));
      LogUtil.d('${Api.trajectoryList} value = $val');
      _dataArray.clear();
      var data = jsonDecode(val.toString());
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        Map re = map as Map;
        TrackModel model = TrackModel(
            name: _selUserModel.name,
            positionName: re['customerName'] ?? '',
            time: re['visitTime'] ?? '',
            duration: '',
            latLng: LatLng(double.parse(re['latitude']) ?? 0,
                double.parse(re['longitude']) ?? 0));
        _dataArray.add(model);
      });
      if(_dataArray.isNotEmpty)
        _addLine();
      else
        AppUtil.showToastCenter('没有轨迹');
      if (mounted) setState(() {});
    } catch (error) {}
  }

  ///添加一个marker 点
  void _addMarker(TrackModel model) {
    final Marker marker = Marker(
        position: model.latLng,
        //使用默认hue的方式设置Marker的图标
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindowEnable: false,
        onTap: (String id) {
          _onTap(id, model);
        });
    //调用setState触发AMapWidget的更新，从而完成marker的添加
    _markers[marker.id] = marker;
  }

  ///添加线
  void _addLine() {
    _polyLines = {};
    final Polyline polyline = Polyline(
      color: AppColors.FFE45C26,
      width: 2.5,
      points: _createPoints(),
    );
    _polyLines[polyline.id] = polyline;
  }

  ///创建坐标点为绘制作准备
  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];
    if (_dataArray.isEmpty) return points;
    double latCount = 0;
    double lngCount = 0;
    _dataArray.forEach((model) {
      points.add(model.latLng);
      _addMarker(model);
      latCount += model.latLng.latitude;
      lngCount += model.latLng.longitude;
    });
    _changeCameraPosition(
        LatLng(latCount / _dataArray.length, lngCount / _dataArray.length));
    return points;
  }

  ///跳转中心点到坐标
  void _changeCameraPosition(LatLng latLng) {
    _mapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            //中心点
            target: latLng,
            //缩放级别
            zoom: 13,
            //俯仰角0°~45°（垂直与地图时为0）
            // tilt: 30,
            //偏航角 0~360° (正北方为0)
            bearing: 0),
      ),
      animated: true,
    );
  }

  ///节点被点击
  void _onTap(String id, TrackModel model) async {
    // print('str = $id,model.time = ${model.time}');
    showModalBottomSheet(
        context: context,
        builder: (_) {
          List<Map> values = [
            {'title': '拜访人：', 'value': model.name ?? ''},
            {'title': '拜访时间：', 'value': model.time ?? ''},
            // {'title': '停留时间：', 'value': model.duration ?? ''},
          ];
          return Container(
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColors.FFEFEFF4,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(model.positionName,
                            style: const TextStyle(fontSize: 14.0)),
                      )),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            MapUtil.gotoAMap(model.latLng.longitude, model.latLng.latitude);
                          },
                          child: const Text('导航到这里',
                              style: const TextStyle(
                                  fontSize: 14.0, color: AppColors.FF959EB1))),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: values
                        .map((e) => Text.rich(TextSpan(
                                text: e['title'],
                                style: const TextStyle(
                                    color: AppColors.FF959EB1, fontSize: 14.0),
                                children: [
                                  TextSpan(
                                      text: e['value'],
                                      style: const TextStyle(
                                          color: AppColors.FF2F4058)),
                                  // TextSpan(
                                  //     text: e['title'] == values.last['title']
                                  //         ? '分钟'
                                  //         : ''),
                                ])))
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        },
        backgroundColor: Colors.transparent);
  }

  @override
  void dispose() {
    super.dispose();
    _mapController?.disponse();
  }
}
