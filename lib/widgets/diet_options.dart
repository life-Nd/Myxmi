import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'menu_item.dart';

class DietOptions extends HookWidget {
  final ScrollController _ctrl = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'diets'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        SingleChildScrollView(
          controller: _ctrl,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              MenuItem(
                filter: 'diet',
                legend: 'vegan',
                url:
                    'https://unsplash.com/photos/zOlQ7lF-3vs?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink',
              ),
              MenuItem(
                  filter: 'diet',
                  legend: 'vegetarian',
                  url:
                      'https://unsplash.com/photos/IGfIGP5ONV0?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink'),
              MenuItem(
                  filter: 'diet',
                  legend: 'keto',
                  url:
                      'https://unsplash.com/photos/auIbTAcSH6E?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink'),
              MenuItem(
                filter: 'diet',
                legend: 'diet',
                url: 'https://unsplash.com/photos/NPBnWE1o07I',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
