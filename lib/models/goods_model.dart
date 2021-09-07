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
  String spec;

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
    this.spec = '',
    this.isSelected = false,
  });
}
