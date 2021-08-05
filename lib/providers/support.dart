import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/models/support_chats.dart';
import 'package:myxmi/models/support_tickets.dart';

class SupportProvider extends ChangeNotifier {
  SupportChatsModel chats = SupportChatsModel();
  List<SupportTicketsModel> tickets = [];
  void getTickets({QuerySnapshot querySnapshot}) {
    tickets = querySnapshot.docs.map((QueryDocumentSnapshot data) {
      return SupportTicketsModel.fromSnapshot(
        snapshot: data.data() as Map<String, dynamic>,
        keyIndex: data.id,
      );
    }).toList();
  }
}
