class InstructionsModel {
  static const _ingredients = 'ingredients';
  static const _steps = 'steps';
  static const _comments = 'comments';
  static const _uid = 'uid';
  List steps = [];
  Map ingredients = {};
  Map comments = {};
  String uid = '';
  InstructionsModel({this.ingredients, this.steps, this.comments, this.uid});

  factory InstructionsModel.fromSnapshot({Map<String, dynamic> snapshot}) {
    return InstructionsModel(
      ingredients: snapshot[_ingredients] as Map,
      steps: snapshot[_steps] as List,
      comments: snapshot[_comments] as Map,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      _ingredients: ingredients,
      _steps: steps,
      _comments: comments,
      _uid: uid,
    };
  }
}
