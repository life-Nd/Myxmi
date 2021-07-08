import 'package:flutter/material.dart';
import 'package:myxmi/models/instructions.dart';
import 'package:myxmi/models/recipe.dart';
import 'package:easy_localization/easy_localization.dart';

class RecipeProvider extends ChangeNotifier {
  RecipeModel recipeModel = RecipeModel();
  InstructionsModel instructions =
      InstructionsModel(ingredients: {}, steps: []);
  Map<String, double> quantity = {};
  Map composition = {};
  double estimatedWeight = 0.0;
  String actualWeight = '';
  List hidden = [];
  double difficultyValue = 0.0;
  int pageIndex = 0;
  Widget image;

  Widget imageViewer({@required Widget newImage}) {
    return image = newImage;
  }

  void changeView(int index) {
    pageIndex = index;
    notifyListeners();
  }

  void changeTitle({@required String newName}) {
    recipeModel.title = newName;
    notifyListeners();
  }

  void changeDuration({@required String newDuration}) {
    recipeModel.duration = newDuration;
    notifyListeners();
  }

  void changePortions({@required String newPortions}) {
    recipeModel.portions = newPortions;
    notifyListeners();
  }

  void changeDifficulty({double newDifficultyValue}) {
    difficultyValue = newDifficultyValue;
    notifyListeners();
  }

  String getDifficulty() {
    return recipeModel.difficulty = difficultyValue == 0.0
        ? 'easy'.tr()
        : difficultyValue == 0.5
            ? 'medium'.tr()
            : difficultyValue == 1.0
                ? 'hard'.tr()
                : '-';
  }

  void changeCategory({String newCategory}) {
    recipeModel.category = newCategory;
    notifyListeners();
  }

  void changeSubCategory({String newSubCategory}) {
    recipeModel.subCategory = newSubCategory;
    notifyListeners();
  }

  void changeComposition(
      {@required String key, @required String type, @required String value}) {
    composition[key] = '$value $type';
    recipeModel.ingredientsCount = '${composition.keys.toList().length}';
  }

  void changeQuantity(
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
    if (type == 'Teaspoons') {
      quantity[key] =
          value != null && value.isNotEmpty ? double.parse(value) * 5 : 0.0;
    }
    if (type == 'Tablespoons') {
      quantity[key] =
          value != null && value.isNotEmpty ? double.parse(value) * 14.20 : 0.0;
    }
    if (type == 'Cups') {
      quantity[key] =
          value != null && value.isNotEmpty ? double.parse(value) * 340 : 0.0;
    }
  }

  void addStep({@required String step}) {
    instructions.steps.add(step);
    notifyListeners();
  }

  void addProduct({@required Map ingredient}) {
    instructions.ingredients = ingredient;
    notifyListeners();
  }

  void saveToDb() {
    recipeModel.toMap();
  }

  void changeEstimatedWeight() {
    estimatedWeight = quantity.values.reduce(
      (sum, element) => sum + element,
    );
    notifyListeners();
  }

 void hide({String component}) {
    hidden.add(component);
  }

void unhide() {
    hidden.clear();
    notifyListeners();
  }

 void reset() {
    recipeModel = RecipeModel();
    instructions = InstructionsModel();
    quantity.clear();
    composition.clear();
    estimatedWeight = 0.0;
    actualWeight = '';
    difficultyValue = 0.0;
    pageIndex = 0;
    hidden.clear();
  }
}
