import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

final recipeEntriesProvider = ChangeNotifierProvider<RecipeEntriesProvider>(
  (ref) => RecipeEntriesProvider(),
);

class RecipeEntriesProvider extends ChangeNotifier {
  RecipeModel recipe = RecipeModel();
  Map ingredients = {};
  List instructions = [];
  Map steps = {};
  Map<String?, double> quantity = {};
  double estimatedWeight = 0.0;
  String actualWeight = '';
  double difficultyValue = 0.0;
  String? category = '';
  String? subCategory = '';
  String? diet = '';
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController durationCtrl = TextEditingController();
  final TextEditingController portionsCtrl = TextEditingController();

  void setTitle() {
    recipe.title = titleCtrl.text;
    notifyListeners();
  }

  void setDuration() {
    recipe.duration = durationCtrl.text;
  }

  void setPortions() {
    recipe.portions = portionsCtrl.text;
  }

  void setDifficulty(double newDifficultyValue) {
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

  void setCategory({String? newCategory}) {
    category = newCategory;
    subCategory = '';
    notifyListeners();
  }

  void setSubCategory({String? newSubCategory}) {
    subCategory = newSubCategory;
    notifyListeners();
  }

  void setDiet({String? newDiet}) {
    diet = newDiet;
    notifyListeners();
  }

  void addIngredient({
    required String? key,
    required String? name,
    required String? type,
    required String? value,
  }) {
    ingredients[key] = {
      'name': name,
      'type': type,
      'value': value,
    };

    recipe.ingredientsCount = '${ingredients.keys.toList().length}';
    debugPrint('recipe.ingredientsCount: ${recipe.ingredientsCount}');
    debugPrint('composition: $ingredients');
    debugPrint('quantity: $quantity');
  }

  void setQuantity({
    required String? key,
    required String? type,
    required String value,
  }) {
    if (type == 'g') {
      quantity[key] = value.isNotEmpty ? double.parse(value) : 0.0;
    }
    if (type == 'drops') {
      quantity[key] = value.isNotEmpty ? double.parse(value) / 21.09 : 0.0;
    }
    if (type == 'ml') {
      quantity[key] = value.isNotEmpty ? double.parse(value) / 1.05 : 0.0;
    }
    if (type == 'teaspoons') {
      quantity[key] = value.isNotEmpty ? double.parse(value) * 5 : 0.0;
    }
    if (type == 'tablespoons') {
      quantity[key] = value.isNotEmpty ? double.parse(value) * 14.20 : 0.0;
    }
    if (type == 'cups') {
      quantity[key] = value.isNotEmpty ? double.parse(value) * 340 : 0.0;
    }
    debugPrint('quantity: $quantity');
    debugPrint('recipe.ingredientsCount: ${recipe.ingredientsCount}');
    debugPrint('ingredients: $ingredients');
  }

  void setEstimatedWeight() {
    estimatedWeight = quantity.isNotEmpty
        ? quantity.values.reduce(
            (sum, element) => sum + element,
          )
        : 0.0;
    notifyListeners();
  }

  void addInstruction({required String instruction}) {
    instructions.add(instruction);
    notifyListeners();
  }

  void removeInstruction({required String instruction}) {
    instructions.remove(instruction);
    notifyListeners();
  }

  Future saveRecipeToDb() async {
    final rng = Random();
    final _random = rng.nextInt(9000) + 1000;
    recipe.reference = '$_random';
    recipe.access = 'Public';
    recipe.usedCount = '1';
    recipe.instructionsCount = '${instructions.length}';
    recipe.made = '${DateTime.now().millisecondsSinceEpoch}';
    recipe.tags = {
      category: true,
      subCategory: true,
      diet: true,
    };
    final DocumentReference _db = await FirebaseFirestore.instance
        .collection('Recipes')
        .add(recipe.toMap());
    recipe.recipeId = _db.id;
    return;
  }

  Future updateProductsStock() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final String _now = '${DateTime.now().millisecondsSinceEpoch}';
    final List _keys = ingredients.keys.toList();
    for (int i = 0; i < ingredients.keys.length; i++) {
      debugPrint('ingredient: $i');
      debugPrint('_keys[i]: ${_keys[i]}');
      final String _key = _keys[i] as String;
      final Map _ingredient = ingredients[_keys[i]] as Map;
      final String _ingredientValue = _ingredient['value'] as String;
      final double _quantityUsed = double.parse(_ingredientValue);
      final List? _storedIngredient = _prefs.getStringList(_key);
      debugPrint('_storedIngredient: $_storedIngredient');
      final String _initialStock =
          _storedIngredient != null ? '${_storedIngredient[0]}' : '0';
      final String _finalStock = _initialStock != '0'
          ? '${int.parse(_initialStock) - _quantityUsed.toInt()}'
          : '0';

      final String _expiryDate =
          _storedIngredient?[1] != null ? '${_storedIngredient![1]}' : _now;
      debugPrint('_initialStock: $_initialStock');
      debugPrint('_quantityUsed: $_quantityUsed');
      _prefs.setStringList(
        _key,
        [
          _finalStock,
          _expiryDate,
          _now,
        ],
      );
    }
  }

  Future saveDetailsToDb() async {
    debugPrint('ingredients:--${ingredients.runtimeType}-- $ingredients');
    await updateProductsStock();
    final Map<String, dynamic> _ingredientsMapped =
        ingredients.map((key, value) {
      final Map _value = value as Map;
      return MapEntry<String, String>(
        '${_value['name']}',
        '${_value['value']} ${_value['type']}',
      );
    });

    if (recipe.recipeId != null) {
      return FirebaseFirestore.instance
          .collection('Ingredients')
          .doc(recipe.recipeId)
          .set({'list': _ingredientsMapped});
    }
    return;
  }

  Future savePrivateInstructionsToDb() async {
    if (recipe.recipeId != null) {
      await FirebaseFirestore.instance
          .collection('Instructions')
          .doc(recipe.recipeId)
          .set({'list': '${instructions.asMap()}'});
    }
    debugPrint('instructions:--${instructions.runtimeType}-- $instructions');
    return;
  }

  void reset() {
    recipe = RecipeModel();
    ingredients = {};
    instructions = [];
    estimatedWeight = 0.0;
    difficultyValue = 0.0;
    actualWeight = '';
    titleCtrl.clear();
    durationCtrl.clear();
    portionsCtrl.clear();
    quantity.clear();
    ingredients.clear();
  }
}
