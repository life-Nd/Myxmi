class RecipesModel {
  static const RECIPEID = 'recipe_id';
  static const TITLE = 'title';
  static const INGREDIENTSCOUNT = 'ingredients_count';
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
  static const MADE = 'made';
  static const COMMENTSCOUNT = 'comments_count';
  static const PORTIONS = 'portions';

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
  String commentsCount;
  String portions;

  RecipesModel(
      {this.ingredientsCount,
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
      this.commentsCount,
      this.portions});
  void fromSnapshot({Map snapshot, String keyIndex}) {
    recipeId = '$keyIndex';
    title = snapshot[TITLE];
    ingredientsCount = snapshot[INGREDIENTSCOUNT];
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
    commentsCount = snapshot[COMMENTSCOUNT];
    made = snapshot[MADE];
    portions = snapshot[PORTIONS];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      TITLE: title.toLowerCase(),
      INGREDIENTSCOUNT: ingredientsCount,
      STEPSCOUNT: stepsCount,
      STARS: stars,
      USEDCOUNT: usedCount,
      IMAGEURL: imageUrl,
      UID: uid,
      DURATION: duration,
      CATEGORY: category.toLowerCase(),
      SUBCATEGORY: subCategory.toLowerCase(),
      ACCESS: access.toLowerCase(),
      DIFFICULTY: difficulty,
      VEGAN: vegan,
      REFERENCE: reference,
      MADE: made,
      COMMENTSCOUNT: commentsCount,
      PORTIONS: portions
    };
  }
}
