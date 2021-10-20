import 'package:flutter/material.dart';
import 'package:myxmi/widgets/diet_options.dart';
import 'package:myxmi/widgets/drink_options.dart';
import 'package:myxmi/widgets/food_options.dart';

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
