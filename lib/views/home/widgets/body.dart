import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/streams/products.dart';
import 'package:myxmi/streams/recipes.dart';
import 'package:myxmi/views/auth/auth_view.dart';
import 'package:myxmi/views/home/home_view.dart';
import '../../../main.dart';
import '../../menu/menu_view.dart';
import '../../more/more_view.dart';
import 'search_recipes_in_db.dart';

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
        return child = isSignedIn ? RecipesUidStream(uid: _uid) : SignIn();
      case 2:
        // Show stream of recipes liked by the user id
        return child = isSignedIn ? RecipesLikesStream(uid: _uid) : SignIn();
      case 3:
        // Show stream of products under the user id
        return child =
            isSignedIn
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

class _HomePageBody extends HookWidget {
  const _HomePageBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _ctrl = useMemoized(() => ScrollController());
    final _view = useProvider(homeViewProvider);
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
  }
}
