class SupportTicketsModel {
  static const String constTicketId = 'ticket_id';
  static const String constTitle = 'title';
  static const String constMessage = 'message';
  static const String constEmail = 'email';
  static const String constAnswered = 'answered';
  static const String constAvatar = 'avatar';
  static const String constBy = 'by';
  static const String constName = 'name';
  static const String constMessagesCount = 'messagesCount';
  static const String constLanguage = 'language';
  static const String constTime = 'time';
  String ticketId;
  String title;
  String message;
  String email;
  String answered;
  String avatar;
  String by;
  String name;
  String messagesCount;
  String language;
  String time;
  SupportTicketsModel({
    this.ticketId,
    this.title,
    this.message,
    this.email,
    this.answered,
    this.avatar,
    this.by,
    this.name,
    this.messagesCount,
    this.language,
    this.time,
  });
  factory SupportTicketsModel.fromSnapshot(
      {Map<String, dynamic> snapshot, String keyIndex}) {
    return SupportTicketsModel(
      ticketId: keyIndex,
      title: snapshot[constTitle] as String,
      message: snapshot[constMessage] as String,
      email: snapshot[constEmail] as String,
      answered: snapshot[constAnswered] as String,
      avatar: snapshot[constAvatar] as String,
      by: snapshot[constBy] as String,
      name: snapshot[constName] as String,
      messagesCount: snapshot[constMessagesCount] as String,
      language: snapshot[constLanguage] as String,
      time: snapshot[constTime] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      constTicketId: ticketId,
      constTitle: title,
      constMessage: message,
      constEmail: email,
      constAnswered: answered,
      constAvatar: avatar,
      constBy: by,
      constName: name,
      constMessagesCount: messagesCount,
      constLanguage: language,
      constTime: time
    };
  }
}
