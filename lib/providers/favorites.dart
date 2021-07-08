import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  Map allRecipes = {};
  Map filtered = {};
  bool showFiltered = false;

  void addFavorites({Map<String, dynamic> newFavorite}) {
    allRecipes.addAll(newFavorite);
  }

  void addFavorite({Map<String, dynamic> newFavorite}) {
    // allRecipes.addEntries(newFavorite);
  }

  void removeFavorite({String newFavorite}) {
    allRecipes.remove(newFavorite);
    notifyListeners();
  }

  bool showFilter({bool value}) {
    return showFiltered = value;
  }

  Future filter({@required String filter, @required String text}) async {
    final Iterable _filter = allRecipes.entries.where((entry) {
      debugPrint('ENTRY: $entry');
      return Map.from(entry.value as Map).containsValue(text);
    });
    debugPrint('FILTERING: $_filter');
    filtered = Map?.fromEntries(_filter as Iterable<MapEntry>);
    debugPrint('FILTERED: $filtered');
  }
}
