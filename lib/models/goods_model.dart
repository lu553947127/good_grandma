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

  ///单价元
  double price;

  ///重量(g)
  double weight;
  bool isSelected;

  ///总价
  double get countPrice => count * price;

  ///总重量
  double get countWeight => count * weight;

  GoodsModel({
    this.name = '',
    this.id = '',
    this.image = '',
    this.count = 1,
    this.price = 0,
    this.weight = 0,
    this.isSelected = false,
  }){
    specs = [];
  }
  GoodsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    image = json['path'] ?? '';
    specs = [];
    List<dynamic> _specs = json['specList'];
    _specs.forEach((specMap) {
      Map map = specMap as Map;
      String spec = map['spec'];
      if(spec != null && spec.isNotEmpty) {
        SpecModel specModel = SpecModel(spec: spec);
        specs.add(specModel);
      }
    });
    id = '';
    count = 1;
    price = 0;
    weight = 0;
    isSelected = false;
  }
}
///规格模型
class SpecModel{
  ///规格
  String spec;
  ///数量
  String number;
  SpecModel({
    this.spec = '',
    this.number = '',
});
}
