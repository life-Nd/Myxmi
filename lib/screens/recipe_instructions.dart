import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RecipeInstructions extends HookWidget {
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.radio_button_unchecked_rounded,
              size: 15,
            ),
            Icon(Icons.radio_button_checked_rounded, size: 13),
            Icon(Icons.radio_button_unchecked_rounded, size: 13),
          ],
        ),
        Text('instructions'.tr()),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (_, int index) {
              int _index = index + 1;
              return Card(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: ListTile(
                  title: Text('${'step'.tr()} $_index'),
                  subtitle: Text('$index'),
                ),
              );
            },
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 30, bottom: 20),
                child: TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.grey,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Step',
                    labelText: '',
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: Colors.green),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
