class InstructionsModel {
  static const INGREDIENTS = 'ingredients';
  static const STEPS = 'steps';

  List<dynamic> steps = [];
  Map ingredients = {};

  InstructionsModel({this.ingredients, this.steps});

  void fromSnapshot({Map snapshot}) {
    ingredients = snapshot[INGREDIENTS];
    steps = snapshot[STEPS];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      INGREDIENTS: ingredients,
      STEPS: steps,
    };
  }
}
