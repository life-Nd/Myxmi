
class CartModel {
  static const constName = 'name';
  static const constCategory = 'category';

  String name;
  String category;

  CartModel({this.name, this.category});

  void fromSnapshot({Map<String, String> snapshot}) {
    name = snapshot[constName];
    category = snapshot[constCategory];
  }

  Map<dynamic, dynamic> toMap() {
    return <dynamic, dynamic>{
      constName: name,
      constCategory: category,
    };
  }
}
