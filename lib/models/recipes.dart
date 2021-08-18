class RecipeModel {
  static const _title = 'title';
  static const _ingredientsCount = 'ingredients_count';
  static const _stepsCount = 'steps_count';
  static const _stars = 'stars';
  static const _usedCount = 'used_count';
  static const _imageUrl = 'image_url';
  static const _uid = 'uid';
  static const _duration = 'duration';
  static const _category = 'category';
  static const _subCategory = 'sub_category';
  static const _access = 'access';
  static const _difficulty = 'difficulty';
  static const _vegan = 'vegan';
  static const _reference = 'reference';
  static const _made = 'made';
  static const _reviewsCount = 'reviews_count';
  static const _portions = 'portions';
  static const _likedBy = 'likedBy';
  static const _username = 'username';
  static const _photoUrl = 'photoUrl';

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
  Map likedBy = {};
  bool liked;
  String username;
  String photoUrl;

  RecipeModel({
    this.recipeId,
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
    this.portions,
    this.likedBy,
    this.liked,
    this.photoUrl,
    this.username,
  });
  factory RecipeModel.fromSnapshot(
      {Map<String, dynamic> snapshot, String keyIndex}) {
    return RecipeModel(
      recipeId: keyIndex,
      title: snapshot[_title] as String,
      ingredientsCount: snapshot[_ingredientsCount] as String,
      stepsCount: snapshot[_stepsCount] as String,
      stars: snapshot[_stars] as String,
      usedCount: snapshot[_usedCount] as String,
      imageUrl: snapshot[_imageUrl] as String,
      uid: snapshot[_uid] as String,
      duration: snapshot[_duration] as String,
      category: snapshot[_category] as String,
      subCategory: snapshot[_subCategory] as String,
      access: snapshot[_access] as String,
      difficulty: snapshot[_difficulty] as String,
      vegan: snapshot[_vegan] as String,
      reference: snapshot[_reference] as String,
      reviewsCount: snapshot[_reviewsCount] as String,
      made: snapshot[_made] as String,
      portions: snapshot[_portions] as String,
      likedBy: snapshot[_likedBy] as Map,
      username: snapshot[_username] as String,
      photoUrl: snapshot[_photoUrl] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      _title: title.trim().toLowerCase(),
      _ingredientsCount: ingredientsCount,
      _stepsCount: stepsCount,
      _stars: stars,
      _usedCount: usedCount,
      _imageUrl: imageUrl,
      _uid: uid,
      _duration: duration,
      _category: category.toLowerCase(),
      _subCategory: subCategory.toLowerCase(),
      _access: access.toLowerCase(),
      _difficulty: difficulty,
      _vegan: vegan,
      _reference: reference,
      _made: made,
      _reviewsCount: reviewsCount,
      _portions: portions,
      _username: username,
      _photoUrl: photoUrl
    };
  }
}
