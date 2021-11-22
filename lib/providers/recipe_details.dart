import 'package:flutter/material.dart';
import 'package:myxmi/models/recipes.dart';

class RecipeDetailsProvider extends ChangeNotifier {
  final List checkedIngredients = [];
  final List checkedSteps = [];
  RecipeModel recipe = RecipeModel();
  List<RecipeModel> suggestedRecipes = [];
  Widget image;

  void like({bool value, String uid}) {
    recipe.likes[uid] = value;
  }

  void toggleIngredient(dynamic key) {
    final bool _checked = checkedIngredients.contains(key);
    _checked ? checkedIngredients.remove(key) : checkedIngredients.add(key);
  }

  void toggleStep(dynamic key) {
    final bool _checked = checkedSteps.contains(key);
    _checked ? checkedSteps.remove(key) : checkedSteps.add(key);
  }

  Widget imageViewer({@required Widget newImage}) {
    return image = newImage;
  }
}
