import 'package:flutter/material.dart';

class SupportChatsModel extends ChangeNotifier {
  static const _message = 'message';
  static const _email = 'email';
  static const _name = 'name';
  static const _uid = 'uid';
  static const _ticketId = 'ticketId';
  static const _time = 'time';
  String message;
  String email;
  String name;
  String uid;
  String ticketId;
  String time;
  SupportChatsModel({
    this.message,
    this.email,
    this.name,
    this.uid,
    this.ticketId,
    this.time,
  });
  factory SupportChatsModel.fromSnapshot({Map snapshot}) {
    return SupportChatsModel(
      message: snapshot[_message] as String,
      email: snapshot[_email] as String,
      name: snapshot[_name] as String,
      uid: snapshot[_uid] as String,
      ticketId: snapshot[_ticketId] as String,
      time: snapshot[_time] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      _message: message,
      _email: email,
      _name: name,
      _uid: uid,
      _ticketId: ticketId,
      _time: time
    };
  }
}
