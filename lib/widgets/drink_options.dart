import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'menu_item.dart';

class DrinkItems extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'drinks'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              MenuItem(
                legend: 'cocktail',
                url:
                    'https://unsplash.com/photos/J5wrhsSPN9o?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink',
              ),
              MenuItem(
                legend: 'smoothie',
                url:
                    'https://unsplash.com/photos/5HNB4MqxkIM?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink',
              ),
              MenuItem(
                legend: 'shake',
                url:
                    'https://unsplash.com/photos/4FujjkcI40g?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink',
              ),
              MenuItem(
                legend: 'drinks',
                url:
                    'https://unsplash.com/photos/4FujjkcI40g?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
