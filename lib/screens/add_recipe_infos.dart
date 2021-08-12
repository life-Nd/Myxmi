import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/widgets/category_selector.dart';
import 'package:myxmi/widgets/difficulty_slider.dart';
import 'package:myxmi/widgets/duration_field.dart';
import 'package:myxmi/widgets/next_button.dart';
import 'package:myxmi/widgets/portions_field.dart';
import 'package:myxmi/widgets/subcategory_selector.dart';
import 'package:myxmi/widgets/title_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import '../providers/recipe.dart';
import 'add_recipe_products.dart';

// <a href="https://storyset.com/work">Work illustrations by Storyset</a>

final recipeProvider =
    ChangeNotifierProvider<RecipeProvider>((ref) => RecipeProvider());
List steps = [];

class AddRecipeInfos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Consumer(builder: (context, watch, child) {
              final _recipe = watch(recipeProvider);
              return IconButton(
                alignment: Alignment.topLeft,
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  _recipe.reset();
                  Navigator.of(context).pop();
                },
              );
            }),
            title: Text('addRecipe'.tr()),
            flexibleSpace: Stack(
              children: [
                SizedBox(
                  width: 100.w,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Image.asset('assets/add_recipe.png',
                        alignment: Alignment.topCenter),
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
            expandedHeight: 55.h,
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
                Center(child: Text('category'.tr())),
                const Center(child: CategorySelector()),
                Consumer(builder: (_, watch, __) {
                  final _recipe = watch(recipeProvider);
                  return _recipe.recipeModel.category != null
                      ? const Center(
                          child: SubCategorySelector(),
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
            builder: (_) => AddRecipeProducts(),
          ),
        );
      }),
    );
  }
}
