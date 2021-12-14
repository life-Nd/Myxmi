import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/screens/recipes/add/infos/add_infos_screen.dart';

import 'package:myxmi/streams/products.dart';
import 'package:myxmi/utils/next_button.dart';

class AddRecipeProductsScreen extends StatelessWidget {
  const AddRecipeProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _router = ref.watch(routerProvider);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                _router.pushPage(name: '/add-recipe-infos');
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => AddRecipeInfosScreen(),
                //   ),
                // );
              },
            ),
            title: Consumer(
              builder: (_, watch, child) {
                final _recipe = ref.watch(recipeEntriesProvider);
                return Row(
                  children: [
                    Text('${'productsIn'.tr()}: '),
                    if (_recipe.recipe.title != null)
                      Text(
                        _recipe.recipe.title!,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                  ],
                );
              },
            ),
          ),
          body: Column(
            children: [
              const Expanded(
                child: ProductsStreamBuilder(type: 'AddProcuctsToRecipe'),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 20.0,
                    right: 10,
                    left: 10,
                  ),
                  child: Consumer(
                    builder: (_, ref, child) {
                      final _recipe = ref.watch(recipeEntriesProvider);
                      return Text(
                        '± ${_recipe.estimatedWeight.toStringAsFixed(3)} g',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
              ),
              NextButton(
                tapNext: () =>
                    _router.pushPage(name: '/add-recipe-instructions'),
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => AddRecipeInstructionsScreen(),
                //   ),
                // ),
              ),
            ],
          ),
        );
      },
    );
  }
}
