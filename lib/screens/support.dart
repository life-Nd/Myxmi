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
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (_, int index) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SupportChat(),
                    ),
                  );
                },
                title: Text('idex: $index'),
                subtitle: const Text('index sdaodko'),
              ),
            ),
          );
        },
      ),
    );
  }
}
