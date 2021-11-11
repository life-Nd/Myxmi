import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/home.dart';
import 'package:myxmi/screens/menu.dart';
import 'package:myxmi/screens/more.dart';
import 'package:myxmi/screens/products.dart';
import 'package:myxmi/screens/recipes.dart';
import 'package:myxmi/screens/sign_in.dart';
import '../main.dart';
import 'search.dart';

class Body extends StatelessWidget {
  Widget _build(int _view, String _uid) {
    final bool isSignedIn = _uid != null;
    Widget child;

    switch (_view) {
      // Show the menu or the recipes found in search
      case 0:
        return child = Column(
          children: [
            SearchRecipesInDb(),
            const Expanded(child: _HomePageBody()),
          ],
        );

      case 1:
        // Show stream of recipes filtered with the user id
        return child = isSignedIn ? const _MyRecipes() : SignIn();
      case 2:
        // Show stream of recipes liked by the user id
        return child = isSignedIn ? const _Favorites() : SignIn();
      case 3:
        // Show stream of products under the user id
        return child =
            isSignedIn ? const Products(type: 'EditProducts') : SignIn();
      case 4:
        // Show profile, settings, about,and sign out
        return child = isSignedIn ? More() : SignIn();
      default:
        return child = const Menu();

        return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Consumer(builder: (_, watch, child) {
        final _view = watch(homeViewProvider);
        final _user = watch(userProvider);
        return _build(_view.view, _user?.account?.uid);
      }),
    ));
  }
}

class _HomePageBody extends HookWidget {
  const _HomePageBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _ctrl = useMemoized(() => ScrollController());
    final _view = useProvider(homeViewProvider);
    if (_view.searchCtrl.text.isNotEmpty) {
      return Recipes(
        showAutoCompleteField: false,
        path: _view.searchWithCtrl(searchKey: 'title'),
        searchFieldLabel: 'title== ${_view.searchCtrl.text}',
      );
    } else {
      return SingleChildScrollView(
        controller: _ctrl,
        child: const Menu(),
      );
    }
  }
}

class _MyRecipes extends HookWidget {
  const _MyRecipes({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = useProvider(userProvider);
    final String _uid = _user?.account?.uid;
    return Recipes(
      showAutoCompleteField: true,
      searchFieldLabel: 'uid == $_uid',
      // recipesPath: RECIPESBY.creatorUid,
      path: FirebaseFirestore.instance
          .collection('Recipes')
          .where('uid', isEqualTo: _uid)
          .snapshots(),
    );
  }
}

class _Favorites extends HookWidget {
  const _Favorites({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = useProvider(userProvider);
    final String _uid = _user?.account?.uid;
    return Recipes(
      searchFieldLabel: 'likes/uid == $_uid',
        showAutoCompleteField: true,
        path: FirebaseFirestore.instance
            .collection('Recipes')
            .where('likes.$_uid', isEqualTo: true)
            .snapshots());
  }
}
