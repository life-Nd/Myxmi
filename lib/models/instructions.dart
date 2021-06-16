class InstructionsModel {
  static const INGREDIENTS = 'ingredients';
  static const STEPS = 'steps';

  List steps = [];
  List ingredients = [];

  InstructionsModel({this.ingredients, this.steps});

  void fromSnapshot({Map snapshot}) {
    ingredients = snapshot[INGREDIENTS];
    steps = snapshot[STEPS];
  }

  Map<dynamic, dynamic> toMap() {
    return <dynamic, dynamic>{
      INGREDIENTS: ingredients,
      STEPS: steps,
    };
  }
}
