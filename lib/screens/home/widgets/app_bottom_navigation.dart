import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/home_screen.dart';
import 'package:myxmi/providers/user.dart';

class AppBottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        final _view = ref.watch(homeScreenProvider);
        final _user = ref.watch(userProvider);
        final int _viewIndex = _view.view!;
        return BottomNavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor:
              Theme.of(context).appBarTheme.titleTextStyle!.color,
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
              label: 'planner'.tr(),
              icon: const Icon(Icons.calendar_today_rounded),
            ),
            BottomNavigationBarItem(
              label: 'products'.tr(),
              icon: const Icon(
                Icons.fastfood_outlined,
              ),
            ),
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
            _view.changeViewIndex(index: index, uid: _user.account?.uid);
          },
        );
      },
    );
  }
}
