import 'package:flutter/material.dart';

class FavoritesProvider {
  Map favorites = {};
  Map filtered = {};
  bool showFiltered = false;

  addFavorites({Map<String, dynamic> newFavorite}) {
    favorites.addAll(newFavorite);
  }

  removeFavorites({String newFavorite}) {
    favorites.remove(newFavorite);
    
  }

  showFilter(show) {
    showFiltered = show;
    
  }

  filter({@required String filter, @required String text}) async {
    Iterable _filter = favorites.values.where((entry) {
      return entry?.containsValue('$text');
    });
    filtered = Map?.fromIterable(_filter);
  }

  clearFiltered() {
  }

}
