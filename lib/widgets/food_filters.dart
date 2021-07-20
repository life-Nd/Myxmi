import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'filter.dart';

class FoodsFilter extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'food'.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              Filter(
                'breakfast',
              ),
              Filter(
                'appetizer',
              ),
              Filter(
                'salad',
              ),
              Filter(
                'soup',
              ),
              Filter(
                'dinner',
              ),
              Filter(
                'dessert',
              ),
              Filter(
                'allFoods',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
