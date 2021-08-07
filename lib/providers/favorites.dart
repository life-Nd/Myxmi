import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  Map allRecipes = {};
  Map filtered = {};
  bool showFiltered = false;
  String searchFilter = 'title';

  void loadFavorites({@required String uid}) {
    final _db =
        FirebaseFirestore.instance.collection('Favorites').doc(uid).snapshots();
    _db.listen((DocumentSnapshot event) async {
      debugPrint('EVENT: ${event.data()}');
      if (event.exists) {
        allRecipes = event.data() as Map<String, dynamic>;
      }
    });
  }

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

  void filterRecipes({@required String text}) {
    showFiltered = true;
    final Iterable _filter = allRecipes.entries.where((entry) {
      return Map.from(entry.value as Map).containsValue(text);
    });
    filtered = Map?.fromEntries(_filter as Iterable<MapEntry>);
    notifyListeners();
  }
}
