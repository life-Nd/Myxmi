import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/screens/menu.dart';
import 'package:myxmi/screens/more.dart';
import 'package:myxmi/screens/products.dart';
import 'package:myxmi/screens/recipes_stream.dart';
import 'package:myxmi/screens/sign_in.dart';
import 'package:myxmi/widgets/search.dart';

class HomeViewProvider extends ChangeNotifier {
  bool showDownloadDialog = true;
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

  String textToSearchWith() {
    final String _text = searchCtrl.text.toString().trim().toLowerCase();
    return _text;
  }

  Stream<QuerySnapshot> streamRecipesWith(
      {@required String key, @required String value}) {
    final _stream = FirebaseFirestore.instance
        .collection('Recipes')
        .where(key, isEqualTo: value)
        .snapshots();
    return _stream;
  }

  Stream<QuerySnapshot> searchWithCtrl({@required String searchKey}) {
    return streamRecipesWith(key: searchKey, value: textToSearchWith());
  }

  void search() {
    if (searchCtrl.text.isNotEmpty) {
      if (view == 0) {
        searchRecipesInDb = true;
      } else {
        searchWithCtrl(searchKey: 'title');
      }
      notifyListeners();
    }
  }

  void doSearch({bool value}) {
    searchRecipesInDb = value;
    notifyListeners();
  }

  Widget viewBuilder({@required String uid}) {
    final ScrollController _ctrl = ScrollController();
    final bool isSignedIn = uid != null;
    switch (view) {
      case 0:
        return _homePage(_ctrl);

      case 1:
        // Show stream of recipes filtered with the user id
        // RecipesByUid(path: 'all', uid: uid)
        return isSignedIn
            ? RecipesStream(
                showAutoCompleteField: true,
                path: FirebaseFirestore.instance
                    .collection('Recipes')
                    .where('uid', isEqualTo: uid)
                    .snapshots(),
              )
            : SignIn();
      case 2:
        // Show stream of recipes liked by the user id
        //RecipesByUid(path: 'liked', uid: uid)

        return isSignedIn
            ? RecipesStream(
                showAutoCompleteField: true,
                path: FirebaseFirestore.instance
                    .collection('Recipes')
                    .where('likedBy.$uid', isEqualTo: true)
                    .snapshots())
            : SignIn();
      case 3:
        // Show stream of products under the user id
        return isSignedIn ? Products() : SignIn();
      case 4:
        return isSignedIn ? More() : SignIn();
      case 5:
        return isSignedIn ? More() : SignIn();
      default:
        return _homePage(_ctrl);
    }
  }

  CustomScrollView _homePage(ScrollController ctrl) {
    return CustomScrollView(
      controller: ctrl,
      slivers: [
        SliverAppBar(
          floating: true,
          pinned: true,
          expandedHeight: 5,
          title: SearchRecipes(),
        ),
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            [
              if (searchRecipesInDb && searchCtrl.text.isNotEmpty)
                RecipesStream(
                  showAutoCompleteField: false,
                  path: searchWithCtrl(searchKey: 'title'),
                )
              else
                const Menu()
            ],
          ),
        ),
      ],
    );
  }
}
