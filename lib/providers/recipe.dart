import 'package:flutter/material.dart';
import 'package:myxmi/models/recipes.dart';

class RecipeProvider extends ChangeNotifier {
  RecipesModel recipe = RecipesModel();
  Map<String, double> quantity = {};
  Map composition = {};
  double estimatedWeight = 0.0;
  String actualWeight = '';
  List hidden = [];
  double difficultyValue = 0.0;
  changeTitle({@required String newName}) {
    recipe.title = newName;
  }

  changeDifficulty({double newDifficultyValue}) {
    difficultyValue = newDifficultyValue;
    notifyListeners();
  }

  String getDifficulty() {
    recipe.difficulty = difficultyValue == 0.0
        ? 'Easy'
        : difficultyValue == 0.5
            ? 'Medium'
            : difficultyValue == 1.0
                ? 'Hard'
                : '-';
    return recipe.difficulty;
  }

  changeCategory({String newCategory}) {
    recipe.category = newCategory;
    notifyListeners();
  }

  changeSubCategory({String newSubCategory}) {
    recipe.subCategory = newSubCategory;
    notifyListeners();
  }

  changeComposition(
      {@required String key, @required String type, @required String value}) {
    composition[key] = '$value $type';
  }

  changeQuantity(
      {@required String key, @required String type, @required String value}) {
    if (type == 'g') {
      quantity[key] =
          value != null && value.isNotEmpty ? double.parse(value) : 0.0;
    }
    if (type == 'Drops') {
      quantity[key] =
          value != null && value.isNotEmpty ? double.parse(value) / 21.09 : 0.0;
    }
    if (type == 'ml') {
      quantity[key] =
          value != null && value.isNotEmpty ? double.parse(value) / 1.05 : 0.0;
    }
  }

  changeEstimatedWeight() {
    estimatedWeight = quantity.values.reduce(
      (sum, element) => sum + element,
    );
    notifyListeners();
  }

  hide({String component}) {
    hidden.add(component);
  }

  unhide() {
    hidden.clear();
    notifyListeners();
  }

  reset() {
    recipe.title = '';
    actualWeight = '';
    estimatedWeight = 0.0;
    quantity.clear();
    composition.clear();
    notifyListeners();
  }
}
