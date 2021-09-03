import 'package:amap_flutter_base/amap_flutter_base.dart';
///轨迹节点model
class TrackModel {
  String name;
  String positionName;
  String time;
  String duration;
  LatLng latLng;
  TrackModel({
    this.name = '',
    this.positionName = '',
    this.time = '',
    this.duration = '',
    this.latLng,
  });
}