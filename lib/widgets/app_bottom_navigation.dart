import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/main.dart';
import 'package:myxmi/screens/favorites.dart';
import 'package:myxmi/screens/home.dart';
// import '../app.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    debugPrint('---------------------');
    return Consumer(builder: (_, watch, __) {
      final _view = watch(viewProvider);
      final _user = watch(userProvider);
      final _favorites = watch(favProvider);
      final int _viewIndex = _view.view;
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
          _view.isSearchingInDb = false;
          _favorites.showFilter(value: false);
          _view.changeViewIndex(index: index, uid: _user?.account?.uid);
        },
      );
    });
  }
}
