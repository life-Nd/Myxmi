import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myxmi/providers/favorites.dart';
import 'package:myxmi/providers/user.dart';
import 'package:myxmi/providers/view.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    Key key,
    @required UserProvider user,
    @required int viewIndex,
    @required ViewProvider view,
    @required FavoritesProvider favorites,
  })  : _user = user,
        _viewIndex = viewIndex,
        _view = view,
        _favorites = favorites,
        super(key: key);

  final UserProvider _user;
  final int _viewIndex;
  final ViewProvider _view;
  final FavoritesProvider _favorites;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      selectedItemColor: Theme.of(context).appBarTheme.titleTextStyle.color,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
          label: 'home'.tr(),
          icon: const Icon(Icons.home_outlined),
        ),
        BottomNavigationBarItem(
          label: 'recipes'.tr(),
          icon: const Icon(Icons.menu_book_outlined),
        ),
        BottomNavigationBarItem(
          label: 'favorites'.tr(),
          icon: const Icon(Icons.favorite_border),
        ),
        BottomNavigationBarItem(
            label: 'products'.tr(),
            icon: const Icon(
              Icons.fastfood_outlined,
            )),
        if (_user.account?.uid != null)
          BottomNavigationBarItem(
            label: 'settings'.tr(),
            icon: const Icon(Icons.settings),
          )
        else
          BottomNavigationBarItem(
            label: 'signIn'.tr(),
            icon: const Icon(Icons.person_outlined),
          ),
      ],
      currentIndex: _viewIndex,
      onTap: (index) {
        _view.changeViewIndex(index: index);
        _view.doSearch(value: false);
        _favorites.showFilter(value: false);
      },
    );
  }
}
