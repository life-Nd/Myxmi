class ReviewsModel {
  static const constMessage = 'message';
  static const constSent = 'sent';
  static const constUid = 'uid';
  static const constMessageId = 'messageId';
  static const constAvatar = 'avatar';
  static const constTried = 'tried';
  String message;
  String messageId;
  String sent;
  String uid;
  String avatar;
  String tried;
  ReviewsModel(
      {this.message,
      this.messageId,
      this.sent,
      this.uid,
      this.avatar,
      this.tried});
  ReviewsModel.fromSnapshot({
    Map<String, String> snapshot,
  }) {
    message = snapshot[constMessage];
    messageId = snapshot[constMessageId];
    sent = snapshot[constSent];
    uid = snapshot[constUid];
    avatar = snapshot[constAvatar];
    tried = snapshot[constTried];
  }

  Map<dynamic, dynamic> toMap() {
    return <dynamic, dynamic>{
      constMessage: message,
      constMessageId: messageId,
      constSent: sent,
      constUid: uid,
      constAvatar: avatar,
      constTried: tried,
    };
  }
}
