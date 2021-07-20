import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'filter.dart';

class VapesFilter extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${'vape'.tr()}s',
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
                'nicotine',
              ),
              Filter(
                'thc',
              ),
              Filter(
                'cbd',
              ),
              Filter(
                'allVapes',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
