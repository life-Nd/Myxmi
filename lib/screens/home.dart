import 'package:flutter/foundation.dart';
import 'package:myxmi/app.dart';
import 'package:myxmi/providers/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myxmi/widgets/search.dart';
import 'package:myxmi/widgets/web_appbar.dart';
import '../main.dart';
import 'add_recipe.dart';

final viewProvider = ChangeNotifierProvider<ViewProvider>(
  (ref) => ViewProvider(),
);

class Home extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final _view = useProvider(viewProvider);
    final _favorites = useProvider(favProvider);
    final _user = useProvider(userProvider);
    final _change = useState<bool>(false);
    int _viewIndex = _view.view;
    final bool _searchable = _viewIndex == 0 ||
        _viewIndex == 1 && _user.account?.uid != null ||
        _viewIndex == 2 && _user.account?.uid != null ||
        _viewIndex == 3 && _user.account?.uid != null;
    debugPrint(
        'Searchable:$_searchable kIsWeb: $kIsWeb ${_searchable || kIsWeb}');
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: kIsWeb ? Size(_size.width, 200) : Size(_size.width, 100),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (kIsWeb) WebAppBar(),
              if (_searchable)
                SearchRecipes(
                    showFilter: _viewIndex == 2 && _user.account?.uid != null)
              else
                kIsWeb ? Container() : const ListTile(title: Text('Myxmi')),
            ],
          ),
        ),
      ),
      floatingActionButton:
          _viewIndex == 0 || _viewIndex == 1 && _user.account?.uid != null
              ? _user.account?.uid != null
                  ? FloatingActionButton(
                      backgroundColor: Colors.green.shade400,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AddRecipe(),
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
                        _viewIndex = 3;
                        _change.value = !_change.value;
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    )
              : null,
      body: _view.viewBuilder(
        uid: _user.account?.uid,
        index: _viewIndex,
      ),
      bottomNavigationBar: !kIsWeb
          ? BottomNavigationBar(
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
            )
          : null,
    );
  }
}
