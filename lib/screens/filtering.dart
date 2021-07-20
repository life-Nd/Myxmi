import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:myxmi/widgets/diets_filter.dart';
import 'package:myxmi/widgets/drinks_filter.dart';
import 'package:myxmi/widgets/food_filters.dart';
import 'package:myxmi/widgets/vapes_filter.dart';

class FilteringScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return SizedBox(
      height: _size.height / 1.05,
      width: _size.width / 1,
      child: ListView(
        children: [
          DrinksFilter(),
          FoodsFilter(),
          DietsFilter(),
          VapesFilter(),
        ],
      ),
    );
  }
}
