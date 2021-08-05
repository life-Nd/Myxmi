import 'package:flutter/foundation.dart';
import 'package:myxmi/app.dart';
import 'package:myxmi/providers/view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myxmi/widgets/search.dart';
import 'package:myxmi/widgets/web_appbar.dart';
import 'package:sizer/sizer.dart';
import '../main.dart';
import 'add_product.dart';
import 'add_recipe_infos.dart';

final viewProvider = ChangeNotifierProvider<ViewProvider>(
  (ref) => ViewProvider(),
);

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, __) {
      final _view = watch(viewProvider);
      final _user = watch(userProvider);
      final _favorites = watch(favProvider);
      final int _viewIndex = _view.view;
      final bool _searchable = _viewIndex == 0 ||
          _viewIndex == 1 && _user.account?.uid != null ||
          _viewIndex == 2 && _user.account?.uid != null ||
          _viewIndex == 3 && _user.account?.uid != null;
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: kIsWeb ? Size(100.h, 200) : Size(100.h, 100),
          child: SafeArea(
            child: Container(
              color: Theme.of(context).appBarTheme.color,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (kIsWeb) SizedBox(width: 100.h, child: WebAppBar()),
                  if (_searchable)
                    SearchRecipes()
                  else
                    kIsWeb ? Container() : const ListTile(title: Text('Myxmi')),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton:
            _viewIndex == 0 || _viewIndex == 1 || _viewIndex == 3
                ? _user.account?.uid != null
                    ? FloatingActionButton(
                        backgroundColor: Colors.green.shade400,
                        onPressed: () {
                          _viewIndex != 3
                              ? Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AddRecipeInfos(),
                                  ),
                                )
                              : Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AddProduct(),
                                  ),
                                );
                        },
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      )
                    : FloatingActionButton(
                        backgroundColor: Colors.red,
                        onPressed: () {
                          _view.changeViewIndex(index: 4);
                        },
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      )
                : null,
        body: _view.viewBuilder(),
        // ignore: avoid_redundant_argument_values
        bottomNavigationBar: kIsWeb
            ? null
            : BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                selectedItemColor:
                    Theme.of(context).appBarTheme.titleTextStyle.color,
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
              ),
      );
    });
  }
}
