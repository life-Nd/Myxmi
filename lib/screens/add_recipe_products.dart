import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:myxmi/widgets/next_button.dart';
import 'package:myxmi/widgets/products.dart';
import 'add_product.dart';
import 'add_recipe_instructions.dart';

class AddRecipeProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Consumer(
          builder: (_, watch, child) {
            final _recipe = watch(recipeProvider);
            debugPrint(
                '_recipe?.recipeModel.subCategory:${_recipe?.recipeModel?.subCategory}');
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
          },
        ),
        actions: [
          RawMaterialButton(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fillColor: Colors.green.shade400,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Text('addProduct'.tr()),
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
        //  const Expanded(child: ProductsList(type: 'EditProducts')),
        // alignment: Alignment.bottomRight,
        children: [
          const Expanded(
            child: Products(type: 'AddRecipe'),
          ),
          NextButton(
            tapNext: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AddRecipeInstructions(),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 20.0, right: 10, left: 10),
              child: Consumer(builder: (_, watch, child) {
                final _recipe = watch(recipeProvider);
                return Text(
                  '± ${_recipe.estimatedWeight.toStringAsFixed(3)} g',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
