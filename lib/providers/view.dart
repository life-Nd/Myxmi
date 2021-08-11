import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myxmi/screens/menu.dart';
import 'package:myxmi/screens/more.dart';
import 'package:myxmi/screens/my_recipes.dart';
import 'package:myxmi/screens/products.dart';
import 'package:myxmi/screens/recipes.dart';
import 'package:myxmi/screens/sign_in.dart';
import 'package:flutter/material.dart';

class ViewProvider extends ChangeNotifier {
  int view = 0;
  TextEditingController searchCtrl = TextEditingController();
  bool searchRecipesInDb = false;
  bool loading = false;

  void loadingEntry({@required bool isLoading}) {
    loading = isLoading;
    notifyListeners();
  }

  void changeViewIndex({@required int index, @required String uid}) {
    view = index;
    searchCtrl.clear();
    searchRecipesInDb = false;
    switch (view) {
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

  Stream<QuerySnapshot> streamProductsWith(
      {@required String key, @required String value}) {
    final _stream = FirebaseFirestore.instance
        .collection('Products')
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

  Stream<QuerySnapshot> searchProductssWith({@required String searchKey}) {
    return streamProductsWith(key: searchKey, value: searchText());
  }

  void search() {
    debugPrint('searchCtrl.text: ${searchText()}');
    if (searchCtrl.text.isNotEmpty) {
      switch (view) {
        case 0:
          searchRecipesInDb = true;
          break;
        case 1:
          searchRecipesWith(searchKey: 'title');
          break;
        case 2:
          break;
        case 3:
          searchRecipesInDb = true;
      }
      notifyListeners();
    }
  }

  void doSearch({bool value}) {
    searchRecipesInDb = value;
    notifyListeners();
  }

  Widget viewBuilder({@required String uid}) {
    final bool isSignedIn = uid != null;
    switch (view) {
      case 0:
        return searchRecipesInDb
            ? RecipesStream(
                path: searchRecipesWith(searchKey: 'title'),
              )
            : Menu();
      case 1:
        return isSignedIn
            ? MyRecipes(
                path: streamRecipesWith(key: 'uid', value: uid),
              )
            : SignIn();
      case 2:
        return isSignedIn
            ? MyRecipes(
                path: FirebaseFirestore.instance
                    .collection('Recipes')
                    .where('likedBy.$uid', isEqualTo: true)
                    .snapshots(),
              )
            : SignIn();
      case 3:
        return isSignedIn ? Products() : SignIn();
      case 4:
        return isSignedIn ? More() : SignIn();
      default:
        return Menu();
    }
  }
}

class SearchInRecipes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'searchInRecipes'.tr(),
          ),
        ),
        Expanded(
          child: RecipesStream(
            path: FirebaseFirestore.instance
                .collection('Products')
                .where('title', isEqualTo: 'ctrl')
                .snapshots(),
          ),
        ),
      ],
    );
  }
}
