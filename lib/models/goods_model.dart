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
  bool isSelected;

  GoodsModel({
    this.name = '',
    this.id = '',
    this.image = '',
    this.count = 0,
    this.spec = '',
    this.isSelected = false,
  });
}