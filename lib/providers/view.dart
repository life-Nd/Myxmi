import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myxmi/screens/favorites.dart';
import 'package:myxmi/screens/menu.dart';
import 'package:myxmi/screens/more.dart';
import 'package:myxmi/screens/products.dart';
import 'package:myxmi/screens/recipes_screen.dart';
import 'package:myxmi/screens/sign_in.dart';
import 'package:flutter/material.dart';

class ViewProvider extends ChangeNotifier {
  int view = 0;
  bool searching = false;
  String searchText = '';
  bool authenticating = false;
  Stream<QuerySnapshot> search;

  void loadingAuth({bool loading}) {
    authenticating = loading;
    notifyListeners();
  }

  void changeViewIndex({int index}) {
    view = index;
    notifyListeners();
  }

  Widget viewBuilder({@required int index, String uid}) {
    view = index;
    switch (view) {
      case 0:
        return !searching
            ? MenuScreen()
            : RecipesScreen(
                legend: 'Searching',
                uid: uid,
                searchText: searchText,
              );
      case 1:
        return uid != null
            ? !searching
                ? RecipesScreen(
                    legend: 'MyRecipes',
                    uid: uid,
                  )
                : RecipesScreen(
                    legend: 'Searching',
                    uid: '',
                    searchText: searchText,
                  )
            : SignIn();
      case 2:
        return uid != null ? Favorites() : SignIn();
      case 3:
        return uid != null ? Products() : SignIn();
      case 4:
        return uid != null ? More() : SignIn();
      case 5:
        return uid != null ? More() : SignIn();
      default:
        return MenuScreen();
    }
  }

  void doSearch({bool value}) {
    searching = value;
    notifyListeners();
  }

  void changeSearch({@required Stream<QuerySnapshot> newSearch}) {
    search = newSearch;
    notifyListeners();
  }
}
