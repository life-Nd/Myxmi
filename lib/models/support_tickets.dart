// class SupportTicketsModel {
//   static const String _ticketId = 'ticket_id';
//   static const String _title = 'title';
//   static const String _message = 'message';
//   static const String _email = 'email';
//   static const String _answered = 'answered';
//   static const String _avatar = 'avatar';
//   static const String _by = 'by';
//   static const String _name = 'name';
//   static const String _messagesCount = 'messagesCount';
//   static const String _language = 'language';
//   static const String _time = 'time';
//   String ticketId;
//   String title;
//   String message;
//   String email;
//   String answered;
//   String avatar;
//   String by;
//   String name;
//   String messagesCount;
//   String language;
//   String time;
//   SupportTicketsModel({
//     this.ticketId,
//     this.title,
//     this.message,
//     this.email,
//     this.answered,
//     this.avatar,
//     this.by,
//     this.name,
//     this.messagesCount,
//     this.language,
//     this.time,
//   });
//   factory SupportTicketsModel.fromSnapshot(
//       {Map<String, dynamic> snapshot, String keyIndex}) {
//     return SupportTicketsModel(
//       ticketId: keyIndex,
//       title: snapshot[_title] as String,
//       message: snapshot[_message] as String,
//       email: snapshot[_email] as String,
//       answered: snapshot[_answered] as String,
//       avatar: snapshot[_avatar] as String,
//       by: snapshot[_by] as String,
//       name: snapshot[_name] as String,
//       messagesCount: snapshot[_messagesCount] as String,
//       language: snapshot[_language] as String,
//       time: snapshot[_time] as String,
//     );
//   }
//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//      _ticketId: ticketId,
//       _title: title,
//       _message: message,
//       _email: email,
//       _answered: answered,
//       _avatar: avatar,
//       _by: by,
//       _name: name,
//       _messagesCount: messagesCount,
//       _language: language,
//       _time: time
//     };
//   }
// }
