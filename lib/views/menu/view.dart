import 'package:flutter/material.dart';
import 'widgets/diet_options.dart';
import 'widgets/drink_options.dart';
import 'widgets/food_options.dart';

class Menu extends StatelessWidget {
  final ScrollController controller;

  const Menu({Key key, this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DrinkItems(),
        FoodOptions(),
        DietOptions(),
        // VapeOptions(),
      ],
    );
  }
}
