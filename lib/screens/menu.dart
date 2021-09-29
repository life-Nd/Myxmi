import 'package:flutter/material.dart';
import 'package:myxmi/widgets/diet_options.dart';
import 'package:myxmi/widgets/drink_options.dart';
import 'package:myxmi/widgets/food_options.dart';
// import 'package:myxmi/widgets/vapes_options.dart';

class Menu extends StatelessWidget {
  final ScrollController _ctrl = ScrollController();
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return SizedBox(
      height: _size.height / 1.05,
      width: _size.width / 1,
      child: ListView(
        controller: _ctrl,
        children: [
          DrinkItems(),
          FoodOptions(),
          DietOptions(),
          // VapeOptions(),
        ],
      ),
    );
  }
}
