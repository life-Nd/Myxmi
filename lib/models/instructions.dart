class InstructionsModel {
  static const INGREDIENTS = 'products';
  static const STEPS = 'steps';

  List steps = [];
  List products = [];

  InstructionsModel({this.products, this.steps});

  void fromSnapshot({Map snapshot}) {
    products = snapshot[INGREDIENTS];
    steps = snapshot[STEPS];
  }

  Map<dynamic, dynamic> toMap() {
    return <dynamic, dynamic>{
      INGREDIENTS: products,
      STEPS: steps,
    };
  }
}
