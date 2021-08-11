
class CartModel {
  static const _name = 'name';
  static const _category = 'category';

  String name;
  String category;

  CartModel({this.name, this.category});

  void fromSnapshot({Map<String, String> snapshot}) {
    name = snapshot[_name];
    category = snapshot[_category];
  }

  Map<dynamic, dynamic> toMap() {
    return <dynamic, dynamic>{
      _name: name,
      _category: category,
    };
  }
}
