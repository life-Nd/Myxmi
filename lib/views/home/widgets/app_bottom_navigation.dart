import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/main.dart';
import 'package:myxmi/views/home/home_view.dart';

class AppBottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, __) {
      final _view = watch(homeViewProvider);
      final _user = watch(userProvider);
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
            label: 'myRecipes'.tr(),
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
          // BottomNavigationBarItem(
          //     label: 'cart'.tr(),
          //     icon: const Icon(
          //       Icons.fastfood_outlined,
          //     )),
          if (_user.account?.uid != null)
            BottomNavigationBarItem(
              label: 'more'.tr(),
              icon: const Icon(Icons.dehaze),
            )
          else
            BottomNavigationBarItem(
              label: 'signIn'.tr(),
              icon: const Icon(Icons.person_outlined),
            ),
        ],
        currentIndex: _viewIndex,
        onTap: (index) {
          _view.searchRecipesInDb = false;
          _view.changeViewIndex(index: index, uid: _user?.account?.uid);
        },
      );
    });
  }
}