import 'package:flutter/material.dart';
import 'package:myxmi/models/instructions.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:easy_localization/easy_localization.dart';

class RecipeProvider extends ChangeNotifier {
  RecipesModel details = RecipesModel();
  InstructionsModel instructions = InstructionsModel(products: {}, steps: []);
  Map<String, double> quantity = {};
  Map composition = {};
  double estimatedWeight = 0.0;
  String actualWeight = '';
  List hidden = [];
  double difficultyValue = 0.0;
  int pageIndex = 0;

  changeView(int index) {
    pageIndex = index;
    notifyListeners();
  }

  changeTitle({@required String newName}) {
    details.title = newName;
    notifyListeners();
  }

  changeDuration({@required String newDuration}) {
    details.duration = newDuration;
    notifyListeners();
  }

  changeDifficulty({double newDifficultyValue}) {
    difficultyValue = newDifficultyValue;
    notifyListeners();
  }

  String getDifficulty() {
    details.difficulty = difficultyValue == 0.0
        ? 'easy'.tr()
        : difficultyValue == 0.5
            ? 'medium'.tr()
            : difficultyValue == 1.0
                ? 'hard'.tr()
                : '-';
    return details.difficulty;
  }

  changeCategory({String newCategory}) {
    details.category = newCategory;
    notifyListeners();
  }

  changeSubCategory({String newSubCategory}) {
    details.subCategory = newSubCategory;
    notifyListeners();
  }

  changeComposition(
      {@required String key, @required String type, @required String value}) {
    composition[key] = '$value $type';
    details.productsCount = '${composition.keys.toList().length}';
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

  void addProduct({@required Map product}) {
    instructions.products = product;
    notifyListeners();
  }

  saveToDb() {
    details.toMap();
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
    details = RecipesModel();
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
