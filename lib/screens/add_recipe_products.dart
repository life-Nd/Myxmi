import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:myxmi/widgets/next_button.dart';
import 'package:myxmi/widgets/products_list.dart';
import 'package:sizer/sizer.dart';

import 'add_product.dart';
import 'add_recipe_instructions.dart';

class AddRecipeProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AddRecipeInfos(),
              ),
            );
          },
        ),
        title: Consumer(builder: (_, watch, child) {
          final _recipe = watch(recipeProvider);
          return Row(
            children: [
              Text('${'productsIn'.tr()}: '),
              if (_recipe?.recipeModel?.title != null)
                Text(
                  _recipe?.recipeModel?.title,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700),
                )
            ],
          );
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddProduct(),
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ProductsList(
              type: 'AddRecipe',
              height: kIsWeb ? 50.h : 90.h,
              padding: kIsWeb
                  ? EdgeInsets.only(bottom: 8.0, right: 50.w, left: 50.w)
                  : const EdgeInsets.all(1),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 8.0, right: 10, left: 10),
              child: Consumer(builder: (_, watch, child) {
                final _recipe = watch(recipeProvider);
                return Text(
                  '± ${_recipe.estimatedWeight.toStringAsFixed(3)} g',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              }),
            ),
          ),
          NextButton(
            tapNext: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AddRecipeInstructions(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
