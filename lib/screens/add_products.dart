import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:myxmi/widgets/next_button.dart';
import 'package:myxmi/widgets/products_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myxmi/widgets/recipe_instructions.dart';

class AddRecipeProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('AddProductScreen building');
    return Scaffold(
      appBar: AppBar(
        title: Consumer(builder: (_, watch, child) {
          final _recipe = watch(recipeProvider);
          return Text('${'productsIn'.tr()}: ${_recipe?.recipeModel?.title}');
        }),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    alignment: Alignment.topRight,
                    child: Card(
                      color: Colors.grey.shade700,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, right: 10, left: 10),
                        child: Consumer(builder: (_, watch, child) {
                          final _recipe = watch(recipeProvider);
                          return Text(
                            '± ${_recipe.estimatedWeight.toStringAsFixed(3)} g',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: ProductsList(
                    type: 'AddRecipe',
                  ),
                ),
              ],
            ),
          ),
          NextButton(
            tapNext: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => RecipeInstructions()),
            ),
          ),
        ],
      ),
    );
  }
}
