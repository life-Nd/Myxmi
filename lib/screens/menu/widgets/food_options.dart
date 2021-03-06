import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:myxmi/screens/menu/widgets/menu_item.dart';

class FoodOptions extends HookWidget {
  final ScrollController _ctrl = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'foods'.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        SingleChildScrollView(
          controller: _ctrl,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              MenuItem(
                filter: 'sub_category',
                legend: 'breakfast',
                url:
                    'https://unsplash.com/photos/SQ20tWzxXO0?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink',
              ),
              MenuItem(
                filter: 'sub_category',
                legend: 'appetizer',
                url:
                    'https://unsplash.com/photos/n9xsu46NGaE?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink',
              ),
              MenuItem(
                filter: 'sub_category',
                legend: 'salad',
                url:
                    'https://unsplash.com/photos/AiHJiRCwB3w?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink',
              ),
              MenuItem(
                filter: 'sub_category',
                legend: 'soup',
                url:
                    'https://unsplash.com/photos/8mVLMZ0WW98?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink',
              ),
              MenuItem(
                filter: 'sub_category',
                legend: 'dinner',
                url:
                    'https://unsplash.com/photos/zzxqoEa64_0?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink',
              ),
              MenuItem(
                filter: 'sub_category',
                legend: 'dessert',
                url:
                    'https://unsplash.com/photos/6iqpLKqeaE0?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink',
              ),
              MenuItem(
                filter: 'category',
                legend: 'anyFood',
                url: '',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
