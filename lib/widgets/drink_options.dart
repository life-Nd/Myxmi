import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'menu_item.dart';

class DrinkItems extends HookWidget {
  final ScrollController _ctrl = ScrollController();
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
          controller: _ctrl,
          child: Row(
            children: const [
              MenuItem(
                category: 'drinks',
                legend: 'cocktail',
                url:
                    'https://unsplash.com/photos/J5wrhsSPN9o?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink',
              ),
              MenuItem(
                category: 'drinks',
                legend: 'smoothie',
                url:
                    'https://unsplash.com/photos/5HNB4MqxkIM?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink',
              ),
              MenuItem(
                category: 'drinks',
                legend: 'shake',
                url:
                    'https://unsplash.com/photos/4FujjkcI40g?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink',
              ),
              MenuItem(
                category: 'drinks',
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
