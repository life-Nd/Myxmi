class ProductsModel {
  static const constName = 'name';
  static const constQuantity = 'quantity';
  static const constValueType = 'valueType';
  static const constCategory = 'category';

  String name;
  String quantity;
  String valueType;
  String category;

  ProductsModel({this.name, this.quantity, this.valueType, this.category});
  void fromSnapshot({Map<String, String> snapshot, String keyIndex}) {
    name = snapshot[constName];
    quantity = snapshot[constQuantity];
    valueType = snapshot[constValueType];
    category = snapshot[constCategory];
  }

  Map<dynamic, dynamic> toMap() {
    return <dynamic, dynamic>{
      constName: name,
      constQuantity: quantity,
      constValueType: valueType,
      constCategory: category,
    };
  }
}
