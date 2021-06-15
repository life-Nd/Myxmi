class ReviewsModel {
  static const MESSAGE = 'message';
  static const SENT = 'sent';
  static const UID = 'uid';
  static const MESSAGEID = 'messageId';
  static const AVATAR = 'avatar';
  static const TRIED = 'tried';
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
  fromSnapshot({Map snapshot, String keyIndex}) {
    message = snapshot[MESSAGE];
    messageId = snapshot[MESSAGEID];
    sent = snapshot[SENT];
    uid = snapshot[UID];
    avatar = snapshot[AVATAR];
    tried = snapshot[TRIED];
  }

  Map<dynamic, dynamic> toMap() {
    return <dynamic, dynamic>{
      MESSAGE: message,
      MESSAGEID: messageId,
      SENT: sent,
      UID: uid,
      AVATAR: avatar,
      TRIED: tried,
    };
  }
}
