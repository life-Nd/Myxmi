import 'package:myxmi/screens/favorites.dart';
import 'package:myxmi/screens/filtering.dart';
import 'package:myxmi/screens/more.dart';
import 'package:myxmi/screens/products.dart';
import 'package:myxmi/screens/recipes.dart';
import 'package:myxmi/widgets/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'favorites.dart';

class ViewProvider extends ChangeNotifier {
  int view = 0;
  bool searching = false;
  Future future;
  Future search;

  changeView({@required int newView, String uid}) {
    view = newView;
    switch (view) {
      case 0:
        // changeFuture(
        //     newFuture: FirebaseFirestore.instance
        //         .collection('Recipes')
        //         .orderBy('Made', descending: true)
        //         .limit(20)
        //         .get());

        return FilteringScreen();
      case 1:
        // changeFuture(
        //     newFuture: FirebaseFirestore.instance
        //         .collection('Recipes')
        //         .where(
        //           'Uid',
        //           isEqualTo: '$uid',
        //         )
        //         .orderBy('Made', descending: true)
        //         .limit(20)
        //         .get());
        return uid != null ? RecipesScreen('Breakfast') : SignIn();
      case 2:
        return uid != null ? Favorites() : SignIn();
      case 3:
        return uid != null ? Products() : SignIn();
      case 4:
        return uid != null ? MoreView() : SignIn();
      default:
        // changeFuture(
        //     newFuture: FirebaseFirestore.instance
        //         .collection('Recipes')
        //         .orderBy('Made', descending: true)
        //         .limit(20)
        //         .get());
        return FilteringScreen();
    }
  }

// TODO fix this search
  searchRecipe(
      {@required String filter,
      @required String text,
      @required String uid,
      FavoritesProvider fav}) {
    doSearch(true);
    switch (view) {
      case 0:
        fav.showFilter(true);
        print('FILTER: $filter ${text.trim()}');
        changeSearch(
            newSearch: FirebaseFirestore.instance
                .collection('Recipes')
                .where('$filter', isEqualTo: '${text.trim()}')
                .get());
        return;
      case 1:
        fav.showFilter(true);
        changeSearch(
            newSearch: FirebaseFirestore.instance
                .collection('Recipes')
                .where('Uid', isEqualTo: '$uid')
                .where('$filter', isEqualTo: '$text')
                .get());
        return;
      case 2:
        fav.showFilter(true);
        fav.filter(filter: filter, text: text);

        return;
      default:
        changeSearch(
            newSearch: FirebaseFirestore.instance
                .collection('Recipes')
                .where('$filter', isEqualTo: '${text.trim()}')
                .get());
        return;
    }
  }

  doSearch(bool value) {
    searching = value;
    notifyListeners();
  }

  changeFuture({@required Future newFuture}) {
    future = newFuture;
  }

  changeSearch({@required Future newSearch}) {
    search = newSearch;
  }
}
