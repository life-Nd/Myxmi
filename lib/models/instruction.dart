// class InstructionModel {
//   static const _ingredients = 'ingredients';
//   static const _steps = 'steps';
//   static const _comments = 'comments';
//   static const _uid = 'uid';
//   List? steps = [];
//   Map? ingredients = {};
//   Map? comments = {};
//   String? uid = '';
//   InstructionModel({this.ingredients, this.steps, this.comments, this.uid});

//   factory InstructionModel.fromSnapshot({required Map<String, dynamic> snapshot}) {
//     return InstructionModel(
//       ingredients: snapshot[_ingredients] as Map?,
//       steps: snapshot[_steps] as List?,
//       comments: snapshot[_comments] as Map?,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       _ingredients: ingredients,
//       _steps: steps,
//       _comments: comments,
//       _uid: uid,
//     };
//   }
// }
