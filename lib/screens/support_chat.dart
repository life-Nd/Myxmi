import 'package:flutter/material.dart';
import 'package:myxmi/models/support_tickets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class SupportChat extends StatelessWidget {
  final SupportTicketsModel ticket;
  const SupportChat({@required this.ticket});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(10.h, 100.w),
        child: SafeArea(
          child: Card(
            elevation: 20,
            child: ListTile(
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(ticket.title),
              subtitle: Text(ticket.message),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(child: Column()),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'typeMessage'.tr(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.green),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
