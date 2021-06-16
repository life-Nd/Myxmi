
class CartModel {
  static const NAME = 'name';
  static const CATEGORY = 'category';

  String name;
  String category;

  CartModel({this.name, this.category});

  void fromSnapshot({Map snapshot, String keyIndex}) {
    name = snapshot[NAME];
    category = snapshot[CATEGORY];
  }

  Map<dynamic, dynamic> toMap() {
    return <dynamic, dynamic>{
      NAME: name,
      CATEGORY: category,
    };
  }
}
