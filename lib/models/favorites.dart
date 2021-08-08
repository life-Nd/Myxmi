// class FavoritesModel {
//   static const constTitle = 'title';
//   static const constImageUrl = 'image_url';
//   static const constTried = 'tried';
//   static const constAdded = 'added';
//   static const constStepsCount = 'steps_count';
//   static const constIngredientsCount = 'ingredients_count';

//   String title;
//   String imageUrl;
//   String tried;
//   String added;
//   String stepsCount;
//   String ingredientsCount;
//   FavoritesModel(
//       {this.title,
//       this.imageUrl,
//       this.tried,
//       this.added,
//       this.stepsCount,
//       this.ingredientsCount});

//   void fromSnapshot({Map<String, String> snapshot}) {
//     title = snapshot[constTitle];
//     imageUrl = snapshot[constImageUrl];
//     tried = snapshot[constTried];
//     added = snapshot[constAdded];
//     stepsCount = snapshot[constStepsCount];
//     ingredientsCount = snapshot[constIngredientsCount];
//   }

//   Map<dynamic, dynamic> toMap() {
//     return <dynamic, dynamic>{
//       constTitle: title,
//       constImageUrl: imageUrl,
//       constTried: tried,
//       constAdded: added,
//       constStepsCount: stepsCount,
//       constIngredientsCount: ingredientsCount,
//     };
//   }
//   // 'title': recipe.title,
//   //               'image_url': recipe.imageUrl,
//   //               'tried': 'false',
//   //               'added': '${DateTime.now().millisecondsSinceEpoch}',
//   //               'steps_count': recipe.stepsCount,
//   //               'ingredients_count': recipe.ingredientsCount
// }
