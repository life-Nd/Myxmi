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
import '../providers/recipe.dart';
import 'add_products.dart';

final recipeProvider =
    ChangeNotifierProvider<RecipeProvider>((ref) => RecipeProvider());
List steps = [];

class AddRecipe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(_size.width, 200),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                  child: Image.asset('assets/chef.png',
                      alignment: Alignment.topCenter)),
              Consumer(builder: (context, watch, child) {
                final _recipe = watch(recipeProvider);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      alignment: Alignment.topLeft,
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        _recipe.reset();
                        Navigator.of(context).pop();
                      },
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'recipeDetails?'.tr(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TitleField(),
            const DifficultySlider(),
            Text('duration'.tr()),
            const DurationField(),
            Text('portions'.tr()),
            const PortionsField(),
            Text('category'.tr()),
            const CategorySelector(),
            const SubCategorySelector(),
            NextButton(
              route: MaterialPageRoute(builder: (_) => AddRecipeProducts()),
            ),
          ],
        ),
      ),
    );
  }
}
