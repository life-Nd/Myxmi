import 'package:flutter/material.dart';

class RecipeProvider extends ChangeNotifier {
  String name = '';
  Map<String, double> quantity = {};
  Map composition = {};
  double estimatedWeight = 0.0;
  String actualWeight = '';
  String duration;
  String category;
  String subCategory;
  String difficulty;
  List hidden = [];

  changeName({@required String newName}) {
    name = newName;
    notifyListeners();
  }

  changeDifficulty({String newDifficulty}) {
    difficulty = newDifficulty;
    notifyListeners();
  }

  changeCategory({String newCategory}) {
    category = newCategory;
    notifyListeners();
  }

  changeSubCategory({String newSubCategory}) {
    subCategory = newSubCategory;
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
    name = '';
    actualWeight = '';
    estimatedWeight = 0.0;
    quantity.clear();
    composition.clear();
    notifyListeners();
  }
}
