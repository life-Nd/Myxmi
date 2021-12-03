import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/recipe_entries.dart';
import 'package:myxmi/utils/next_button.dart';
import 'package:myxmi/views/home/home_view.dart';
import '../products/add_product_to_recipe_view.dart';
import 'widgets/category_selector.dart';
import 'widgets/diet_selector.dart';
import 'widgets/difficulty_slider.dart';
import 'widgets/duration_field.dart';
import 'widgets/portions_field.dart';
import 'widgets/subcategory_selector.dart';
import 'widgets/title_field.dart';

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
            expandedHeight: _size.height * 0.6,
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text('category'.tr())),
                    const CategorySelector(),
                  ],
                ),
                Consumer(builder: (_, watch, __) {
                  final _recipe = watch(recipeEntriesProvider);
                  return (_recipe?.category != null &&
                          _recipe?.category != 'other')
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
      bottomNavigationBar: NextButton(
        tapNext: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddProductsToRecipe(),
            ),
          );
        },
      ),
    );
  }
}
