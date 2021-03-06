import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/models/recipe.dart';
import 'package:myxmi/utils/recipe_tile.dart';

class RecipesGrid extends StatefulWidget {
  final List<RecipeModel?> recipes;
  const RecipesGrid({Key? key, required this.recipes}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecipesGridState();
}

class _RecipesGridState extends State<RecipesGrid> {
  final ScrollController _ctrl = ScrollController();
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final Orientation _orientation = MediaQuery.of(context).orientation;
    return widget.recipes.isNotEmpty
        ? GridView.builder(
            controller: _ctrl,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.6,
              crossAxisCount: kIsWeb && _size.width > 500 ||
                      _orientation == Orientation.landscape
                  ? 4
                  : 2,
            ),
            padding: const EdgeInsets.all(1),
            itemCount: widget.recipes.length,
            itemBuilder: (_, int index) {
              return RecipeTile(
                index: index,
                recipes: widget.recipes,
              );
            },
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: Image.asset('assets/data_not_found.png')),
              Expanded(
                child: Text(
                  'noRecipes'.tr(),
                ),
              ),
            ],
          );
  }
}
