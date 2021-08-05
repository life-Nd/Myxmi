import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myxmi/screens/favorites.dart';
import 'package:myxmi/screens/menu.dart';
import 'package:myxmi/screens/more.dart';
import 'package:myxmi/screens/products.dart';
import 'package:myxmi/screens/recipes.dart';
import 'package:myxmi/screens/sign_in.dart';
import 'package:flutter/material.dart';

import 'favorites.dart';

class ViewProvider extends ChangeNotifier {
  int view = 0;
  bool isSignedIn = false;
  TextEditingController searchCtrl = TextEditingController();
  String key = 'uid';
  String value;
  Stream<QuerySnapshot> stream;
  bool searching = false;
  bool loading = false;
  String uid;

  void loadingEntry({@required bool isLoading}) {
    loading = isLoading;
    notifyListeners();
  }

  void changeViewIndex({int index}) {
    view = index;
    searchCtrl.clear();
    if (index == 1) {
      stream = FirebaseFirestore.instance
          .collection('Recipes')
          .where(key, isEqualTo: uid)
          .snapshots();
    }
    notifyListeners();
  }

  void getRecipesByUid() {
    stream = FirebaseFirestore.instance
        .collection('Recipes')
        .where(key, isEqualTo: uid)
        .snapshots();
  }

  void getRecipesBySearch() {
    stream = FirebaseFirestore.instance
        .collection('Recipes')
        .where('title',
            isEqualTo: searchCtrl.text.toString().trim().toLowerCase())
        .snapshots();
  }

  void getRecipesByCategory() {
    stream = FirebaseFirestore.instance
        .collection('Recipes')
        .where('category', isEqualTo: value)
        .snapshots();
  }

  void getStream() {
    searching
        ? getRecipesBySearch()
        : key == 'uid'
            ? getRecipesByUid()
            : getRecipesByCategory();
    notifyListeners();
  }

  void search({@required FavoritesProvider fav}) {
    debugPrint('searchCtrl.text: ${searchCtrl.text}');
    if (searchCtrl.text.isNotEmpty) {
      searching = true;
      view == 2
          ? fav.filter(text: searchCtrl.text.toLowerCase())
          : getRecipesBySearch();
    }
    notifyListeners();
  }

  void doSearch({bool value}) {
    searching = value;
    notifyListeners();
  }

  Widget viewBuilder() {
    switch (view) {
      case 0:
        return searching ? Recipes() : Menu();
      case 1:
        return isSignedIn ? Recipes() : SignIn();
      case 2:
        return isSignedIn ? Favorites() : SignIn();
      case 3:
        return isSignedIn ? Products() : SignIn();
      case 4:
        return isSignedIn ? More() : SignIn();
      default:
        return Menu();
    }
  }
}
