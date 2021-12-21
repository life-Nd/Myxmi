import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/home_screen.dart';
import 'package:myxmi/providers/user.dart';
import 'package:myxmi/screens/auth/auth_screen.dart';
import 'package:myxmi/screens/calendar/calendar_screen.dart';
import 'package:myxmi/screens/home/widgets/search_recipes_in_db.dart';
import 'package:myxmi/screens/landing/landing_screen.dart';
import 'package:myxmi/screens/menu/menu_view.dart';
import 'package:myxmi/screens/menu/widgets/menu_item.dart';
import 'package:myxmi/screens/more/more_screen.dart';
import 'package:myxmi/streams/products.dart';
import 'package:myxmi/streams/recipes.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Widget _build(int? _view, String? _uid) {
    final bool isSignedIn = _uid != null;

    switch (_view) {
      // Show the menu or the recipes found in search
      case 0:
        return Column(
          children: [
            SearchRecipesInDb(),
            const Expanded(child: _HomePageBody()),
          ],
        );

      case 1:
        // Show stream of recipes filtered with the user id
        // return isSignedIn ? const _RecipesByUid() : const SignInScreen();
        return isSignedIn ? const _RecipesTypesView() : const SignInScreen();
      case 2:
        // Show stream of recipes liked by the user id
        return isSignedIn
            ? const CalendarScreen(isEditing: false)
            : const SignInScreen();
      case 3:
        // Show stream of products under the user id
        return isSignedIn
            ? const ProductsStreamBuilder(type: 'EditProducts')
            : const SignInScreen();
      case 4:
        // Show profile, settings, about,and sign out
        return isSignedIn ? const MoreScreen() : const SignInScreen();
      case 5:
        return isSignedIn
            ? const CalendarScreen(
                isEditing: true,
              )
            : const SignInScreen();
      default:
        return const LandingScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Consumer(
          builder: (_, ref, child) {
            final _view = ref.watch(homeScreenProvider);
            final _user = ref.watch(userProvider);
            return _build(_view.view, _user.account?.uid);
          },
        ),
      ),
    );
  }
}

class _RecipesTypesView extends StatefulWidget {
  const _RecipesTypesView({Key? key}) : super(key: key);
  @override
  State<_RecipesTypesView> createState() => _RecipesTypesViewState();
}

class _RecipesTypesViewState extends State<_RecipesTypesView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'What type of recipes do you want to see?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          MenuItem(
            fullWidth: true,
            filter: 'sub_category',
            legend: 'myRecipes',
            url:
                'Photo by <a href="https://unsplash.com/@andyc?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Andy Chilton</a> on <a href="https://unsplash.com/s/photos/cooking?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>',
          ),
          MenuItem(
            fullWidth: true,
            filter: 'sub_category',
            legend: 'favoritesRecipes',
            url:
                'Photo by <a href="https://unsplash.com/@therachelstory?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Rachel Park</a> on <a href="https://unsplash.com/s/photos/food?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>',
          ),
        ],
      ),
    );
  }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _ctrl = ScrollController();

    return Consumer(
      builder: (_, ref, child) {
        final _view = ref.watch(homeScreenProvider);
        if (_view.searchCtrl.text.isNotEmpty) {
          return RecipesStreamBuilder(
            showAutoCompleteField: false,
            snapshots: _view.searchWithCtrl(searchKey: 'title').snapshots(),
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

class RecipesByUid extends StatelessWidget {
  const RecipesByUid({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _user = ref.watch(userProvider);
        return RecipesUidStream(uid: _user.account!.uid);
      },
    );
  }
}

class RecipesUidLiked extends StatelessWidget {
  const RecipesUidLiked({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _user = ref.watch(userProvider);
        return RecipesLikesStream(uid: _user.account!.uid);
      },
    );
  }
}
