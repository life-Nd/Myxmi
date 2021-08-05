import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  Map allRecipes = {};
  Map filtered = {};
  bool showFiltered = false;
  String searchFilter = 'title';

  void addFavorite({Map<String, dynamic> newFavorite}) {
    allRecipes.addAll(newFavorite);
    notifyListeners();
  }

  void removeFavorite({String newFavorite}) {
    allRecipes.remove(newFavorite);
    notifyListeners();
  }

  bool showFilter({bool value}) {
    return showFiltered = value;
  }

  void filter({@required String text}) {
    showFiltered = true;
    final Iterable _filter = allRecipes.entries.where((entry) {
      return Map.from(entry.value as Map).containsValue(text);
    });
    debugPrint('FILTERING: $_filter');
    filtered = Map?.fromEntries(_filter as Iterable<MapEntry>);
    debugPrint('FILTERED: $filtered');
    notifyListeners();
  }
}
