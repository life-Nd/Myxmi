class ProductsModel {
  static const NAME = 'name';
  static const QUANTITY = 'quantity';
  static const VALUETYPE = 'valueType';
  static const CATEGORY = 'category';

  String name;
  String quantity;
  String valueType;
  String category;

  ProductsModel({this.name, this.quantity, this.valueType, this.category});
  void fromSnapshot({Map snapshot, String keyIndex}) {
    name = snapshot[NAME];
    quantity = snapshot[QUANTITY];
    valueType = snapshot[VALUETYPE];
    category = snapshot[CATEGORY];
  }

  Map<dynamic, dynamic> toMap() {
    return <dynamic, dynamic>{
      NAME: name,
      QUANTITY: quantity,
      VALUETYPE: valueType,
      CATEGORY: category,
    };
  }
}
