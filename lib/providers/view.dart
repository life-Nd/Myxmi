import 'package:myxmi/screens/favorites.dart';
import 'package:myxmi/screens/filtering.dart';
import 'package:myxmi/screens/more.dart';
import 'package:myxmi/screens/products.dart';
import 'package:myxmi/screens/recipes_screen.dart';
import 'package:myxmi/widgets/sign_in.dart';
import 'package:flutter/material.dart';

class ViewProvider extends ChangeNotifier {
  int view = 0;
  bool searching = false;
  String searchText = '';
  Future future;
  Future search;

  Widget changeView({@required int newView, String uid}) {
    view = newView;
    switch (view) {
      case 0:
        return FilteringScreen();
      case 1:
        return uid != null
            ? !searching
                ? RecipesScreen(
                    legend: 'MyRecipes',
                    uid: uid,
                  )
                : RecipesScreen(
                    legend: 'Searching',
                    uid: uid,
                    searchText: searchText,
                  )
            : SignIn();
      case 2:
        return uid != null ? Favorites() : SignIn();
      case 3:
        return uid != null ? Products() : SignIn();
      case 4:
        return uid != null ? MoreView() : SignIn();
      default:
        return FilteringScreen();
    }
  }

// TODO fix this search
  // searchRecipe(
  //     {@required String filter,
  //     @required String text,
  //     @required String uid,
  //     FavoritesProvider fav}) {
  //   switch (view) {
  //     case 0:
  //       return;
  //     case 1:
  //       return;
  //     case 2:
  //       fav.filter(filter: filter, text: text);
  //       return;
  //     default:
  //       changeSearch(
  //           newSearch: FirebaseFirestore.instance
  //               .collection('Recipes')
  //               .where('$filter', isEqualTo: '${text.trim()}')
  //               .get());
  //       return;
  //   }
  // }

  void doSearch({bool value}) {
    searching = value;
    notifyListeners();
  }

//  void changeFuture({@required Future newFuture}) {
//     future = newFuture;

//   }

  void changeSearch({@required Future newSearch}) {
    search = newSearch;
    notifyListeners();
  }
}
