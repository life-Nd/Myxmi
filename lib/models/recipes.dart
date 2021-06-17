class RecipesModel {
  static const RECIPEID = 'recipe_id';
  static const TITLE = 'title';
  static const INGREDIENTSCOUNT = 'ingredient_count';
  static const STEPSCOUNT = 'steps_count';
  static const STARS = 'stars';
  static const USEDCOUNT = 'used_count';
  static const IMAGEURL = 'image_url';
  static const UID = 'uid';
  static const DURATION = 'duration';
  static const CATEGORY = 'category';
  static const SUBCATEGORY = 'sub_category';
  static const ACCESS = 'access';
  static const DIFFICULTY = 'difficulty';
  static const VEGAN = 'vegan';
  static const REFERENCE = 'reference';
  String recipeId;
  String title = '';
  String productsCount;
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
  RecipesModel(
      {this.productsCount,
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
      this.reference});
  void fromSnapshot({Map snapshot, String keyIndex}) {
    recipeId = '$keyIndex';
    title = snapshot[TITLE];
    productsCount = snapshot[INGREDIENTSCOUNT];
    stepsCount = snapshot[STEPSCOUNT];
    stars = snapshot[STARS];
    usedCount = snapshot[USEDCOUNT];
    imageUrl = snapshot[IMAGEURL];
    uid = snapshot[UID];
    duration = snapshot[DURATION];
    category = snapshot[CATEGORY];
    subCategory = snapshot[SUBCATEGORY];
    access = snapshot[ACCESS];
    difficulty = snapshot[DIFFICULTY];
    vegan = snapshot[VEGAN];
    reference = snapshot[REFERENCE];
  }

  Map<dynamic, dynamic> toMap() {
    return <dynamic, dynamic>{
      TITLE: title,
      INGREDIENTSCOUNT: productsCount,
      STEPSCOUNT: stepsCount,
      STARS: stars,
      USEDCOUNT: usedCount,
      IMAGEURL: imageUrl,
      UID: uid,
      DURATION: duration,
      CATEGORY: category,
      SUBCATEGORY: subCategory,
      ACCESS: access,
      DIFFICULTY: difficulty,
      VEGAN: vegan,
      REFERENCE: reference
    };
  }
}
