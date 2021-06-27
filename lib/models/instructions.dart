class InstructionsModel {
  static const INGREDIENTS = 'products';
  static const STEPS = 'steps';

  List<String> steps = [];
  Map products = {};

  InstructionsModel({this.products, this.steps});

  void fromSnapshot({Map snapshot}) {
    products = snapshot[INGREDIENTS];
    steps = snapshot[STEPS];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      INGREDIENTS: products,
      STEPS: steps,
    };
  }
}
