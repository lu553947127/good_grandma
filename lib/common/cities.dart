class ProvinceModel {
  List<CityModel> cities;
  String provinceName;
  String id;

  ProvinceModel({this.provinceName = '',this.id = ''}){
    cities = [];
  }

  ProvinceModel.fromJson(Map<String, dynamic> json) {
    cities = [];
    if (json['children'] != null) {
      json['children'].forEach((v) {
        cities.add(new CityModel.fromJson(v));
      });
    }
    provinceName = json['provinceName'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cities != null) {
      data['cities'] = this.cities.map((v) => v.toJson()).toList();
    }
    data['provinceName'] = this.provinceName;
    data['id'] = this.id;
    return data;
  }
}

class CityModel {
  String citiesName;
  String id;

  CityModel({this.citiesName = '',this.id = ''});

  CityModel.fromJson(Map<String, dynamic> json) {
    citiesName = json['cityName'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cityName'] = this.citiesName;
    data['id'] = this.id;
    return data;
  }
}