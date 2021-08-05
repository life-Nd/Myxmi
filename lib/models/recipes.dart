class RecipesModel {
  static const constRecipeId = 'recipe_id';
  static const constTitle = 'title';
  static const constIngredientsCount = 'ingredients_count';
  static const constStepsCount = 'steps_count';
  static const constStars = 'stars';
  static const constUsedCount = 'used_count';
  static const constImageUrl = 'image_url';
  static const constUid = 'uid';
  static const constDuration = 'duration';
  static const constCategory = 'category';
  static const constSubCategory = 'sub_category';
  static const constAccess = 'access';
  static const constDifficulty = 'difficulty';
  static const constVegan = 'vegan';
  static const constReference = 'reference';
  static const constMade = 'made';
  static const constReviewsCount = 'reviews_count';
  static const constPortions = 'portions';

  String recipeId;
  String title = '';
  String ingredientsCount;
  String stepsCount;
  String stars;
  String usedCount;
  String imageUrl;
  String uid;
  String duration;
  String category;
  String subCategory;
  String access;
  String difficulty;
  String vegan;
  String reference;
  String made;
  String reviewsCount;
  String portions;

  RecipesModel(
      {this.recipeId,
      this.title,
      this.ingredientsCount,
      this.stepsCount,
      this.stars,
      this.usedCount,
      this.imageUrl,
      this.uid,
      this.duration,
      this.category,
      this.subCategory,
      this.access,
      this.difficulty,
      this.vegan,
      this.reference,
      this.made,
      this.reviewsCount,
      this.portions});
  factory RecipesModel.fromSnapshot(
      {Map<String, dynamic> snapshot, String keyIndex}) {
    return RecipesModel(
      recipeId: keyIndex,
      title: snapshot[constTitle] as String,
      ingredientsCount: snapshot[constIngredientsCount] as String,
      stepsCount: snapshot[constStepsCount] as String,
      stars: snapshot[constStars] as String,
      usedCount: snapshot[constUsedCount] as String,
      imageUrl: snapshot[constImageUrl] as String,
      uid: snapshot[constUid] as String,
      duration: snapshot[constDuration] as String,
      category: snapshot[constCategory] as String,
      subCategory: snapshot[constSubCategory] as String,
      access: snapshot[constAccess] as String,
      difficulty: snapshot[constDifficulty] as String,
      vegan: snapshot[constVegan] as String,
      reference: snapshot[constReference] as String,
      reviewsCount: snapshot[constReviewsCount] as String,
      made: snapshot[constMade] as String,
      portions: snapshot[constPortions] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      constTitle: title.toLowerCase(),
      constIngredientsCount: ingredientsCount,
      constStepsCount: stepsCount,
      constStars: stars,
      constUsedCount: usedCount,
      constImageUrl: imageUrl,
      constUid: uid,
      constDuration: duration,
      constCategory: category.toLowerCase(),
      constSubCategory: subCategory.toLowerCase(),
      constAccess: access.toLowerCase(),
      constDifficulty: difficulty,
      constVegan: vegan,
      constReference: reference,
      constMade: made,
      constReviewsCount: reviewsCount,
      constPortions: portions
    };
  }
}
