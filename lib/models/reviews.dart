class CommentsModel {
  static const _message = 'message';
  static const _sent = 'sent';
  static const _uid = 'uid';
  static const _messageId = 'messageId';
  static const _avatar = 'avatar';
  static const _tried = 'tried';
  String message;
  String messageId;
  String sent;
  String uid;
  String avatar;
  String tried;
  CommentsModel(
      {this.message,
      this.messageId,
      this.sent,
      this.uid,
      this.avatar,
      this.tried});
  CommentsModel.fromSnapshot({
    Map<String, String> snapshot,
  }) {
    message = snapshot[_message];
    messageId = snapshot[_messageId];
    sent = snapshot[_sent];
    uid = snapshot[_uid];
    avatar = snapshot[_avatar];
    tried = snapshot[_tried];
  }

  Map<dynamic, dynamic> toMap() {
    return <dynamic, dynamic>{
      _message: message,
      _messageId: messageId,
      _sent: sent,
      _uid: uid,
      _avatar: avatar,
      _tried: tried,
    };
  }
}
