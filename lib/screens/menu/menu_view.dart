import 'package:flutter/material.dart';
import 'package:myxmi/screens/menu/widgets/diet_options.dart';
import 'package:myxmi/screens/menu/widgets/drink_options.dart';
import 'package:myxmi/screens/menu/widgets/food_options.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);
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
