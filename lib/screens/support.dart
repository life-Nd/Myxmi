import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'support_chat.dart';

class SupportScreen extends HookWidget {
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
                builder: (_) => SupportChat(),
              ),
            );
          },
          child: const Icon(Icons.question_answer),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 4),
              alignment: Alignment.bottomLeft,
              child: Text(
                'ticketsVisible'.tr(),
                style: const TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [const Icon(Icons.check_box), Text('all'.tr())],
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        const Icon(Icons.check_box_outline_blank),
                        Text('mine'.tr())
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: SupportStream())
          ],
        ));
  }
}
