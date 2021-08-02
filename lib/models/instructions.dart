class InstructionsModel {
  static const constIngredients = 'ingredients';
  static const constSteps = 'steps';
  static const constReviews = 'reviews';
  static const constUid = 'uid';
  List steps = [];
  Map ingredients = {};
  List reviews = [];
  String uid = '';
  InstructionsModel({this.ingredients, this.steps, this.reviews, this.uid});

  void fromSnapshot({Map<String, dynamic> snapshot}) {
    ingredients = snapshot[constIngredients] as Map;
    steps = snapshot[constSteps] as List;
    reviews = snapshot[constReviews] as List;
    uid = snapshot[constUid] as String;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      constIngredients: ingredients,
      constSteps: steps,
      constReviews: reviews,
      constUid: uid,
    };
  }
}
