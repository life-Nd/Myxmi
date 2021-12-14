class CommentModel {
  static const _message = 'message';
  static const _name = 'name';
  static const _photoUrl = 'photoUrl';
  static const _stars = 'stars';
  static const _uid = 'uid';
  String? messageId;
  String? message;
  String? name;
  String? photoUrl;
  String? stars;
  String? uid;
  CommentModel({
    this.messageId,
    this.message,
    this.name,
    this.photoUrl,
    this.stars,
    this.uid,
  });
  factory CommentModel.fromSnapshot({
    String? id,
    required Map<String, dynamic> snapshot,
  }) {
    return CommentModel(
      messageId: id,
      message: snapshot[_message] as String?,
      name: snapshot[_name] as String?,
      photoUrl: snapshot[_photoUrl] as String?,
      stars: snapshot[_stars] as String?,
      uid: snapshot[_uid] as String?,
    );
  }

  Map<dynamic, dynamic> toMap() {
    return <dynamic, dynamic>{
      _message: message,
      _name: name,
      _photoUrl: photoUrl,
      _stars: stars,
      _uid: uid,
    };
  }
}
