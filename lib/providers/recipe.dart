import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/models/instructions.dart';
import 'package:myxmi/models/recipes.dart';

class RecipeProvider extends ChangeNotifier {
  RecipeModel recipeModel = RecipeModel();
  List<RecipeModel> recipesList = [];
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
  PageController pageController = PageController();
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController durationCtrl = TextEditingController();
  final TextEditingController portionsCtrl = TextEditingController();

  void changePageController(int index) {
    pageController.jumpToPage(index);
    pageIndex = index;
    notifyListeners();
  }

  Widget imageViewer({@required Widget newImage}) {
    return image = newImage;
  }

  void like({bool value, String uid}) {
    recipeModel.likedBy[uid] = value;
  }

  void changeTitle() {
    recipeModel.title = titleCtrl.text;
    notifyListeners();
  }

  void changeDuration() {
    recipeModel.duration = durationCtrl.text;
  }

  void changePortions() {
    recipeModel.portions = portionsCtrl.text;
  }

  void changeDifficulty(double newDifficultyValue) {
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
    recipeModel.subCategory = null;
    notifyListeners();
  }

  void changeSubCategory({String newSubCategory}) {
    recipeModel.subCategory = newSubCategory;
    notifyListeners();
  }

  void changeDiet({String newDiet}) {
    recipeModel.diet = newDiet;
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

  void removeStep({@required String step}) {
    instructions.steps.remove(step);
    notifyListeners();
  }

  void addProduct({@required Map ingredient}) {
    instructions.ingredients = ingredient;
    notifyListeners();
  }

  void saveRecipeToDb() {
    recipeModel.toMap();
  }

  void changeEstimatedWeight() {
    estimatedWeight = quantity.isNotEmpty
        ? quantity.values.reduce(
            (sum, element) => sum + element,
          )
        : 0.0;
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
    instructions = InstructionsModel(ingredients: {}, steps: []);
    estimatedWeight = 0.0;
    difficultyValue = 0.0;
    actualWeight = '';
    pageIndex = 0;
    titleCtrl.clear();
    durationCtrl.clear();
    portionsCtrl.clear();
    quantity.clear();
    composition.clear();
    hidden.clear();
  }
}

class SelectedRecipeViewNotifier extends ChangeNotifier {
  int pageIndex = 0;
  PageController pageController = PageController();
  void changePageController(int index) {
    pageController.jumpToPage(index);
    pageIndex = index;
    notifyListeners();
  }
}
