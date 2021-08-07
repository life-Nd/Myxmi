import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myxmi/screens/ask_support.dart';
import 'package:myxmi/widgets/search.dart';
import 'support_tickets.dart';

bool viewAll = true;

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('support'.tr()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AskSupport(),
            ),
          );
        },
        child: const Icon(Icons.question_answer),
      ),
      body: Column(
        children: [
          ListTile(
            title: Center(
              child: Text(
                'ticketsVisible'.tr(),
              ),
            ),
            subtitle: StatefulBuilder(
              builder: (context, StateSetter stateSetter) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          stateSetter(() {
                            viewAll = true;
                          });
                        },
                        child: Row(
                          children: [
                            if (viewAll)
                              const Icon(Icons.check_box)
                            else
                              const Icon(Icons.check_box_outline_blank),
                            Text('all'.tr())
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          stateSetter(() {
                            viewAll = false;
                          });
                        },
                        child: Row(
                          children: [
                            if (viewAll)
                              const Icon(Icons.check_box_outline_blank)
                            else
                              const Icon(Icons.check_box),
                            Text('mine'.tr())
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SearchRecipes(),
          Expanded(
            child: SupportTickets(),
          )
        ],
      ),
    );
  }
}
