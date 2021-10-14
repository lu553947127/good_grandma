///商品模型
class GoodsModel {
  ///名称
  String name;

  ///id
  String id;

  ///图片
  String image;

  ///数量
  int count;

  ///规格
  List<SpecModel> specs;

  ///单价元 开票价
  double invoice;

  ///二批价
  double middleman;

  ///重量(g)
  double weight;
  bool isSelected;

  ///总价
  double get countPrice => count * invoice;

  ///二批价总价
  double get countMiddlemanPrice => count * middleman;

  ///总重量
  double get countWeight => count * weight;

  GoodsModel({
    this.name = '',
    this.id = '',
    this.image = '',
    this.count = 1,
    this.invoice = 0,
    this.middleman = 0,
    this.weight = 0,
    this.isSelected = false,
  }) {
    specs = [];
  }
  ///列表用
  GoodsModel.fromJsonForList(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    middleman = double.parse(json['middleman'].toString()) ?? 0;
    count = json['count'] ?? 0;
    weight = double.parse(json['weight']) ?? 0;
    invoice = double.parse(json['invoice']) ?? 0;
    id = json['id'] ?? '';
    image = json['pic'] ?? '';
    String spec = json['spec'];
    specs = [SpecModel(spec: spec)];
    isSelected = false;
  }

  GoodsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    middleman = json['middleman'] ?? 0.0;
    count = json['count'] ?? 0;
    weight = json['weight'] ?? 0.0;
    invoice = json['invoice'] ?? 0.0;
    id = json['id'] ?? '';
    // print('json = $json');

    image = json['path'] ?? '';
    specs = [];
    List<dynamic> _specs = json['specList'];
    _specs.forEach((specMap) {
      Map map = specMap as Map;
      String spec = map['spec'];
      if (spec != null && spec.isNotEmpty) {
        SpecModel specModel = SpecModel(spec: spec);
        specs.add(specModel);
      }
    });
    middleman = 0;
    isSelected = false;
  }

  Map toMap() {
    return {
      // 'name':name,
      // 'spec':specs.isNotEmpty?specs.first.spec:'',
      // 'invoice':invoice,
      // 'middleman':middleman,
      // 'weight':weight,
      'count': count,
      'id': id
    };
  }
}

///规格模型
class SpecModel {
  ///规格
  String spec;

  ///数量
  String number;
  SpecModel({
    this.spec = '',
    this.number = '',
  });
}
