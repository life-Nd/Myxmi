class InstructionsModel {
  static const constIngredients = 'ingredients';
  static const constSteps = 'steps';
  static const constReviews = 'reviews';
  List steps = [];
  Map ingredients = {};
  List reviews = [];

  InstructionsModel({this.ingredients, this.steps, this.reviews});

  void fromSnapshot({Map<String, dynamic> snapshot}) {
    ingredients = snapshot[constIngredients] as Map;
    steps = snapshot[constSteps] as List;
    reviews = snapshot[constReviews] as List;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      constIngredients: ingredients,
      constSteps: steps,
      constReviews: reviews,
    };
  }
}
