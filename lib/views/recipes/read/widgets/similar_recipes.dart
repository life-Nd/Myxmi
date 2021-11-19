import 'package:flutter/material.dart';
import 'package:myxmi/models/recipes.dart';

import 'recipe_tile.dart';

class SimilarRecipes extends StatelessWidget {
  final List<RecipeModel> suggestedRecipes;
  const SimilarRecipes({@required this.suggestedRecipes});
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final double _width = _size.width;
    final double _height = _size.height;
    return Container(
      height: 400,
      width: _width * 0.25,
      margin: const EdgeInsets.only(left: 20),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.only(left: 10),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: suggestedRecipes.length,
        itemBuilder: (_, int index) {
          return SizedBox(
            width: _width * 0.25,
            height: _height * 0.56,
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
