import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/streams/products.dart';
import 'package:myxmi/streams/recipes.dart';
import 'package:myxmi/views/auth/auth_view.dart';
import 'package:myxmi/views/home/home_view.dart';
import '../../../main.dart';
import '../../menu/menu_view.dart';
import '../../more/more_view.dart';
import 'search_recipes_in_db.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
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
        return child = isSignedIn ? const _RecipesByUid() : SignIn();
      case 2:
        // Show stream of recipes liked by the user id
        return child = isSignedIn ? const _RecipesUidLiked() : SignIn();
      case 3:
        // Show stream of products under the user id
        return child = isSignedIn
            ? const ProductsStreamBuilder(type: 'EditProducts')
            : SignIn();
      case 4:
        // Show profile, settings, about,and sign out
        return child = isSignedIn ? More() : SignIn();
      case 5:
        // Show profile, settings, about,and sign out
        return child = isSignedIn ? More() : SignIn();
      default:
        return child = SignIn();

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

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _ctrl = ScrollController();

    return Consumer(
      builder: (_, watch, child) {
        final _view = watch(homeViewProvider);
        if (_view.searchCtrl.text.isNotEmpty) {
          return RecipesStreamBuilder(
            showAutoCompleteField: false,
            snapshots: _view.searchWithCtrl(searchKey: 'title').snapshots(),
            searchFieldLabel: 'title== ${_view.searchCtrl.text}',
          );
        } else {
          return SingleChildScrollView(
            controller: _ctrl,
            child: const Menu(),
          );
        }
      },
    );
  }
}

class _RecipesByUid extends StatelessWidget {
  const _RecipesByUid({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, child) {
      final _user = watch(userProvider);
      return RecipesUidStream(uid: _user.account.uid);
    });
  }
}

class _RecipesUidLiked extends StatelessWidget {
  const _RecipesUidLiked({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, child) {
      final _user = watch(userProvider);
      return RecipesLikesStream(uid: _user.account.uid);
    });
  }
}
