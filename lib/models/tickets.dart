class SupportTicketsModel {
  static const _message = 'message';
  static const _sender = 'sender';
  static const _name = 'name';
  static const _receiver = 'receiver';
  static const _email = 'email';
  static const _experience = 'experience';
  static const _messageId = 'messageId';

  final String message;
  final String name;
  final String experience;
  final String sender;
  final String receiver;
  final String email;
  final String messageId;
  const SupportTicketsModel(
      {this.message,
      this.name,
      this.experience,
      this.sender,
      this.receiver,
      this.email,
      this.messageId});
  factory SupportTicketsModel.fromSnapshot(
      {Map<String, dynamic> snapshot, String keyIndex}) {
    return SupportTicketsModel(
      messageId: keyIndex,
      message: snapshot[_message] as String,
      name: snapshot[_name] as String,
      experience: snapshot[_experience] as String,
      sender: snapshot[_sender] as String,
      receiver: snapshot[_receiver] as String,
      email: snapshot[_email] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      _messageId: messageId,
      _message: message,
      _name: name,
      _experience: experience,
      _sender: sender,
      _receiver: receiver,
      _email: email
    };
  }
}
