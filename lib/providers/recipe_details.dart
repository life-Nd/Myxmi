import 'package:flutter/material.dart';
import 'package:myxmi/models/recipe.dart';

class RecipeDetailsProvider extends ChangeNotifier {
  RecipeModel details = RecipeModel();

  List<RecipeModel?> suggestedRecipes = [];
  Widget? image;

  Widget imageViewer({required Widget newImage}) {
    return image = newImage;
  }
}
