import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/models/instructions.dart';
import 'package:myxmi/models/recipes.dart';

class RecipeEntriesProvider extends ChangeNotifier {
  RecipeModel recipe = RecipeModel();
  InstructionsModel instructions =
      InstructionsModel(ingredients: {}, steps: []);
  Map<String, double> quantity = {};
  Map composition = {};
  double estimatedWeight = 0.0;
  String actualWeight = '';
  double difficultyValue = 0.0;
  String category = '';
  String subCategory = '';
  String diet = '';
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController durationCtrl = TextEditingController();
  final TextEditingController portionsCtrl = TextEditingController();

  void changeTitle() {
    recipe.title = titleCtrl.text;
    notifyListeners();
  }

  void changeDuration() {
    recipe.duration = durationCtrl.text;
  }

  void changePortions() {
    recipe.portions = portionsCtrl.text;
  }

  void changeDifficulty(double newDifficultyValue) {
    difficultyValue = newDifficultyValue;
    notifyListeners();
  }

  String getDifficulty() {
    return recipe.difficulty = difficultyValue == 0.0
        ? 'easy'.tr()
        : difficultyValue == 0.5
            ? 'medium'.tr()
            : difficultyValue == 1.0
                ? 'hard'.tr()
                : '-';
  }

  void changeCategory({String newCategory}) {
    category = newCategory;
    subCategory = null;
    notifyListeners();
  }

  void changeSubCategory({String newSubCategory}) {
    subCategory = newSubCategory;
    notifyListeners();
  }

  void changeDiet({String newDiet}) {
    diet = newDiet;
    notifyListeners();
  }

  void changeComposition(
      {@required String key,
      @required String name,
      @required String type,
      @required String value}) {
    composition[key] = {
      'name': name,
      'type': type,
      'value': value,
    };

    recipe.ingredientsCount = '${composition.keys.toList().length}';
  }

  void changeQuantity(
      {@required String key, @required String type, @required String value}) {
    if (type == 'g') {
      quantity[key] =
          value != null && value.isNotEmpty ? double.parse(value) : 0.0;
    }
    if (type == 'drops') {
      quantity[key] =
          value != null && value.isNotEmpty ? double.parse(value) / 21.09 : 0.0;
    }
    if (type == 'ml') {
      quantity[key] =
          value != null && value.isNotEmpty ? double.parse(value) / 1.05 : 0.0;
    }
    if (type == 'teaspoons') {
      quantity[key] =
          value != null && value.isNotEmpty ? double.parse(value) * 5 : 0.0;
    }
    if (type == 'tablespoons') {
      quantity[key] =
          value != null && value.isNotEmpty ? double.parse(value) * 14.20 : 0.0;
    }
    if (type == 'cups') {
      quantity[key] =
          value != null && value.isNotEmpty ? double.parse(value) * 340 : 0.0;
    }
  }

  void addStep({@required String step}) {
    instructions.steps.add(step);
    notifyListeners();
  }

  void removeStep({@required String step}) {
    instructions.steps.remove(step);
    notifyListeners();
  }

  // void addProduct({@required Map ingredient}) {
  //   instructions.ingredients = ingredient;
  //   notifyListeners();
  // }

  void saveRecipeToDb() {
    recipe.toMap();
  }

  void changeEstimatedWeight() {
    estimatedWeight = quantity.isNotEmpty
        ? quantity.values.reduce(
            (sum, element) => sum + element,
          )
        : 0.0;
    notifyListeners();
  }

  void reset() {
    recipe = RecipeModel();
    instructions = InstructionsModel(ingredients: {}, steps: []);
    estimatedWeight = 0.0;
    difficultyValue = 0.0;
    actualWeight = '';
    titleCtrl.clear();
    durationCtrl.clear();
    portionsCtrl.clear();
    quantity.clear();
    composition.clear();
  }
}
