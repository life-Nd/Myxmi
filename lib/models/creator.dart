class CreatorModel {
  static const _name = 'name';
  static const _avatar = 'avatar';
  static const _recipesPosted = 'recipes_posted';

  String name;
  String avatar;
  int recipesPosted;

  CreatorModel({this.name, this.avatar, this.recipesPosted});

  factory CreatorModel.fromSnapshot({Map<String, dynamic> snapshot}) {
    return CreatorModel(
      name: snapshot[_name] as String,
      avatar: snapshot[_avatar] as String,
      recipesPosted: snapshot[_recipesPosted] as int,
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      _name: name,
      _avatar: avatar,
      _recipesPosted: recipesPosted
    };
  }
}