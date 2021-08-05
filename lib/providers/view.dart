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
        .where('title', isEqualTo: searchCtrl.text)
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
    if (searchCtrl.text.isNotEmpty) {
      searching = true;
      view == 2 ? fav.filter(text: searchCtrl.text) : getRecipesBySearch();
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
        getRecipesBySearch();
        return searching ? Recipes() : Menu();
      case 1:
        getRecipesByUid();
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

  // Stream<QuerySnapshot> getDefaultStream(
  //     {@required String legend, @required String uid}) {
  //   switch (view) {
  //     case 1:
  //       _stream = FirebaseFirestore.instance
  //           .collection('Recipes')
  //           .where('uid', isEqualTo: uid)
  //           .snapshots();
  //       return _stream;

  //     default:
  //       _stream = FirebaseFirestore.instance
  //           .collection('Recipes')
  //           .where('category', isEqualTo: legend)
  //           .snapshots();
  //       return _stream;
  //   }
  // }

  // Stream<QuerySnapshot> getSearchStream() {
  //   switch (view) {
  //     case 1:
  //       _stream = FirebaseFirestore.instance
  //           .collection('Recipes')
  //           .where('title', isEqualTo: searchCtrl.text)
  //           .snapshots();
  //       return _stream;

  //     default:
  //       _stream = FirebaseFirestore.instance
  //           .collection('Recipes')
  //           .where('category', isEqualTo: searchCtrl.text)
  //           .snapshots();
  //       return _stream;
  //   }
  // }

  // Stream<QuerySnapshot> getStream(
  //     {@required String legend, @required String uid}) {
  //   switch (legend) {
  //     case 'Category':
  //       _stream = FirebaseFirestore.instance
  //           .collection('Recipes')
  //           .where('category', isEqualTo: legend)
  //           .snapshots();
  //       return _stream;
  //     case 'MyRecipes':
  //       _stream = FirebaseFirestore.instance
  //           .collection('Recipes')
  //           .where('uid', isEqualTo: uid)
  //           .snapshots();
  //       return _stream;
  //     case 'Searching':
  //       _stream = FirebaseFirestore.instance
  //           .collection('Recipes')
  //           .where('title', isEqualTo: searchCtrl.text)
  //           .snapshots();
  //       return _stream;
  //     default:
  //       _stream = FirebaseFirestore.instance
  //           .collection('Recipes')
  //           .where('sub_category', isEqualTo: legend)
  //           .snapshots();
  //       return _stream;
  //   }
  // }

}
