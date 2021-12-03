class RecipeModel {
  static const _title = 'title';
  static const _ingredientsCount = 'ingredients_count';
  static const _stepsCount = 'steps_count';
  static const _stars = 'stars';
  static const _usedCount = 'used_count';
  static const _imageUrl = 'image_url';
  static const _uid = 'uid';
  static const _duration = 'duration';
  static const _access = 'access';
  static const _difficulty = 'difficulty';
  static const _reference = 'reference';
  static const _made = 'made';
  static const _commentsCount = 'comments_count';
  static const _portions = 'portions';
  static const _likes = 'likes';
  static const _username = 'username';
  static const _userphoto = 'userphoto';
  static const _tags = 'tags';
  static const _lang = 'lang';
  static const _area = 'area';
  static const _youtube = 'youtube';
  String recipeId;
  String title = '';
  String ingredientsCount;
  String stepsCount;
  String stars;
  String usedCount;
  String imageUrl;
  String uid;
  String duration;

  String access;
  String difficulty;
  String reference;
  String made;
  String commentsCount;
  String portions;
  Map likes = {};
  bool isLiked;
  String username;
  String userphoto;

  Map tags = {};
  String lang;
  String area;
  String youtube;

  RecipeModel(
      {this.recipeId,
      this.title,
      this.ingredientsCount,
      this.stepsCount,
      this.stars,
      this.usedCount,
      this.imageUrl,
      this.uid,
      this.duration,
      this.access,
      this.difficulty,
      this.reference,
      this.made,
      this.commentsCount,
      this.portions,
      this.likes,
      this.isLiked,
      this.userphoto,
      this.username,
      this.tags,
      this.lang,
      this.area,
      this.youtube});
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
      access: snapshot[_access] as String,
      difficulty: snapshot[_difficulty] as String,
      reference: snapshot[_reference] as String,
      commentsCount: snapshot[_commentsCount] as String,
      made: snapshot[_made] as String,
      portions: snapshot[_portions] as String,
      likes: snapshot[_likes] as Map,
      username: snapshot[_username] as String,
      userphoto: snapshot[_userphoto] as String,
      tags: snapshot[_tags] as Map,
      lang: snapshot[_lang] as String,
      area: snapshot[_area] as String,
      youtube: snapshot[_youtube] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      _title: title?.trim()?.toLowerCase(),
      _ingredientsCount: ingredientsCount,
      _stepsCount: stepsCount,
      _stars: stars,
      _usedCount: usedCount,
      _imageUrl: imageUrl,
      _uid: uid,
      _duration: duration,
      _access: access?.toLowerCase(),
      _difficulty: difficulty,
      _reference: reference,
      _made: made,
      _likes: likes,
      _commentsCount: commentsCount,
      _portions: portions,
      _username: username,
      _userphoto: userphoto,
      _tags: tags,
      _lang: lang,
      _area: area,
      _youtube: youtube,
    };
  }
}
