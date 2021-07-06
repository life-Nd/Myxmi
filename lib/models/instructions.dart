class InstructionsModel {
  static const INGREDIENTS = 'ingredients';
  static const STEPS = 'steps';
static const REVIEWS = 'reviews';
  List<dynamic> steps = [];
  Map ingredients = {};
  List<dynamic> reviews = [];

  InstructionsModel({this.ingredients, this.steps, this.reviews});

  void fromSnapshot({Map snapshot}) {
    ingredients = snapshot[INGREDIENTS];
    steps = snapshot[STEPS];
    reviews = snapshot[REVIEWS];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      INGREDIENTS: ingredients,
      STEPS: steps,
      REVIEWS: reviews,
    };
  }
}
