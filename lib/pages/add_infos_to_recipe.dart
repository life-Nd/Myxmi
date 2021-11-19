import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/recipe_entries.dart';
import 'package:myxmi/views/recipes/add/infos/categories/category_selector.dart';
import 'package:myxmi/views/recipes/add/infos/diet_selector.dart';
import 'package:myxmi/views/recipes/add/infos/difficulty_slider.dart';
import 'package:myxmi/views/recipes/add/infos/duration_field.dart';
import 'package:myxmi/views/recipes/add/infos/portions_field.dart';
import 'package:myxmi/views/recipes/add/infos/sub_categories/subcategory_selector.dart';
import 'package:myxmi/views/recipes/add/infos/title_field.dart';
import 'package:myxmi/views/recipes/add/next_button.dart';

import '../views/home/home_view.dart';
import 'add_products_to_recipes.dart';

final recipeEntriesProvider = ChangeNotifierProvider<RecipeEntriesProvider>(
    (ref) => RecipeEntriesProvider());

List steps = [];

class AddInfosToRecipe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Consumer(builder: (context, watch, child) {
              final _recipe = watch(recipeEntriesProvider);
              return IconButton(
                alignment: Alignment.topLeft,
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  _recipe.reset();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => HomeView(),
                    ),
                  );
                },
              );
            }),
            title: Text('addRecipe'.tr()),
            flexibleSpace: Stack(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Image.asset('assets/add_recipe.png',
                        alignment: Alignment.topCenter),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '<a href="https://storyset.com/work">Work illustrations by Storyset</a>',
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'recipeDetails?'.tr(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            expandedHeight: _size.height * 0.5,
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                const TitleField(),
                const DifficultySlider(),
                Center(child: Text('duration'.tr())),
                const DurationField(),
                Center(child: Text('portions'.tr())),
                const PortionsField(),
                const SizedBox(height: 4),
                SizedBox(
                  height: _size.height / 10,
                  width: _size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Text('category'.tr())),
                      const Expanded(child: CategorySelector()),
                    ],
                  ),
                ),
                Consumer(builder: (_, watch, __) {
                  final _recipe = watch(recipeEntriesProvider);
                  return (_recipe.recipe.category != null &&
                          _recipe.recipe.category != 'other')
                      ? Center(
                          child: Column(
                            children: [
                              const SubCategorySelector(),
                              Center(child: Text('diet'.tr())),
                              const Center(child: DietSelector()),
                            ],
                          ),
                        )
                      : Container();
                }),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NextButton(tapNext: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddProductsToRecipe(),
          ),
        );
      }),
    );
  }
}
