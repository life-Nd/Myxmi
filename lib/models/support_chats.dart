import 'package:flutter/material.dart';

class SupportChatsModel extends ChangeNotifier {
  static const constMessage = 'message';
  static const constEmail = 'email';
  static const constName = 'name';
  static const constUid = 'uid';
  static const constTicketId = 'ticketId';
  static const constTime = 'time';
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
      message: snapshot[constMessage] as String,
      email: snapshot[constEmail] as String,
      name: snapshot[constName] as String,
      uid: snapshot[constUid] as String,
      ticketId: snapshot[constTicketId] as String,
      time: snapshot[constTime] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      constMessage: message,
      constEmail: email,
      constName: name,
      constUid: uid,
      constTicketId: ticketId,
      constTime: time
    };
  }
}
