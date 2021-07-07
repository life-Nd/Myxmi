import 'package:flutter/material.dart';

class FavoritesProvider {
  Map allRecipes = {};
  Map filtered = {};
  bool showFiltered = false;

  addFavorites({Map<String, dynamic> newFavorite}) {
    allRecipes.addAll(newFavorite);
  }

  removeFavorite({String newFavorite}) {
    allRecipes.remove(newFavorite);
    
  }

  showFilter(show) {
    showFiltered = show;
    
  }

  filter({@required String filter, @required String text}) async {
    Iterable _filter = allRecipes.entries.where((entry) {
      print('ENTRY: $entry');
      return Map<String, dynamic>.from(entry.value).containsValue('$text');
    });
    print('FILTERING: $_filter');
    filtered = Map?.fromEntries(_filter);
    print('FILTERED: $filtered');
  }
}
