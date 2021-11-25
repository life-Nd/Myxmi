import 'package:flutter/material.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/utils/recipe_tile.dart';

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
      margin: EdgeInsets.only(left: _width / 5),
      alignment: Alignment.bottomLeft,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: suggestedRecipes.length,
        itemBuilder: (_, int index) {
          return SizedBox(
            width: 300,
            height: _height * 0.7,
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
