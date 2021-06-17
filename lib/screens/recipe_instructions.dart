import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RecipeInstructions extends HookWidget {
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('instructions'.tr()),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (_, int index) {
              int _index = index + 1;
              return Card(
                child: ListTile(
                  title: Text('${'step'.tr()} $_index'),
                  subtitle: Text('$index'),
                ),
              );
            },
          ),
        ),
        Text('2/3'),
      ],
    );
  }
}
