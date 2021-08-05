import 'package:flutter/material.dart';
import 'package:myxmi/models/support_chats.dart';
import 'package:myxmi/models/support_tickets.dart';

class SupportProvider extends ChangeNotifier {
  SupportTicketsModel tickets = SupportTicketsModel();
  SupportChatsModel chats = SupportChatsModel();
}
