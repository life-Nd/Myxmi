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
  TextEditingController searchCtrl = TextEditingController();
  String value;
  bool isSearchingInDb = false;
  bool loading = false;

  void loadingEntry({@required bool isLoading}) {
    loading = isLoading;
    notifyListeners();
  }

  void changeViewIndex({@required int index, @required String uid}) {
    view = index;
    searchCtrl.clear();
    switch (index) {
      case 1:
        streamRecipesWith(key: 'uid', value: uid);
    }

    notifyListeners();
  }

  Stream<QuerySnapshot> streamRecipesWith(
      {@required String key, @required String value}) {
    final _stream = FirebaseFirestore.instance
        .collection('Recipes')
        .where(key, isEqualTo: value)
        .snapshots();
    return _stream;
  }

  String searchText() {
    final String _text = searchCtrl.text.toString().trim().toLowerCase();
    return _text;
  }

  Stream<QuerySnapshot> searchRecipesWith({@required String searchKey}) {
    return streamRecipesWith(key: searchKey, value: searchText());
  }

  void search({@required FavoritesProvider fav}) {
    debugPrint('searchCtrl.text: ${searchText()}');
    if (searchCtrl.text.isNotEmpty) {
      isSearchingInDb = true;
      switch (view) {
        case 1:
          searchRecipesWith(searchKey: 'title');
          break;
        case 2:
          fav.filterRecipes(text: searchText());
          break;
        case 3:
      }
      view == 2
          ? fav.filterRecipes(text: searchText())
          : searchRecipesWith(searchKey: 'title');
    }
    notifyListeners();
  }

  void doSearch({bool value}) {
    isSearchingInDb = value;
    notifyListeners();
  }

  Widget viewBuilder({@required String uid}) {
    final bool isSignedIn = uid != null;
    switch (view) {
      case 0:
        return isSearchingInDb
            ? RecipesStream(
                path: searchRecipesWith(searchKey: 'title'),
              )
            : Menu();
      case 1:
        return isSignedIn
            ? RecipesStream(
                path: streamRecipesWith(key: 'uid', value: uid),
              )
            : SignIn();
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
