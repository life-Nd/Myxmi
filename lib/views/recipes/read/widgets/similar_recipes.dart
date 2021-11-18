import 'package:flutter/material.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:sizer/sizer.dart';
import 'recipe_tile.dart';

class SimilarRecipes extends StatelessWidget {
  final List<RecipeModel> suggestedRecipes;
  const SimilarRecipes({@required this.suggestedRecipes});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 60.w,
      margin: const EdgeInsets.only(left: 20),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.only(left: 10),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: suggestedRecipes.length,
        itemBuilder: (_, int index) {
          return SizedBox(
            width: 44.w,
            height: 44.h,
            child: RecipeTile(
              recipes: suggestedRecipes,
              index: index,
            ),
          );
        },
      ),
    );
  }
}
