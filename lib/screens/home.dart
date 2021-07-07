import 'package:myxmi/app.dart';
import 'package:myxmi/providers/view.dart';
import 'package:myxmi/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../main.dart';
import 'add_recipe.dart';
import 'package:easy_localization/easy_localization.dart';

final viewProvider = ChangeNotifierProvider<ViewProvider>(
  (ref) => ViewProvider(),
);
// int viewIndex = 0;

class Home extends HookWidget {
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final _view = useProvider(viewProvider);
    final _favorites = useProvider(favProvider);
    final _user = useProvider(userProvider);
    final _change = useState<bool>(false);
    int viewIndex = _view.view;
    return Scaffold(
      appBar: viewIndex == 0 ||
              viewIndex == 1 && _user.account?.uid != null ||
              viewIndex == 2 && _user.account?.uid != null ||
              viewIndex == 3 && _user.account?.uid != null
          ? PreferredSize(
              preferredSize: viewIndex == 0 && _view.searching ||
                      viewIndex == 1 &&
                          _user.account?.uid != null &&
                          _view.searching
                  ? Size(_size.width, 100)
                  : Size(_size.width, 55),
              child: SafeArea(
                top: true,
                child: SearchRecipes(
                  showFilter: viewIndex == 2 && _user.account?.uid != null
                      ? false
                      : true,
                ),
              ),
            )
          : AppBar(
              automaticallyImplyLeading: false,
              title: Text('Myxmi'),
            ),
      floatingActionButton:
          viewIndex == 0 || viewIndex == 1 && _user.account?.uid != null
              ? _user.account?.uid != null
                  ? FloatingActionButton(
                      backgroundColor: Colors.green.shade400,
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AddRecipe(),
                          ),
                        );
                      },
                    )
                  : FloatingActionButton(
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        viewIndex = 3;
                        _change.value = !_change.value;
                      },
                    )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: Theme.of(context).appBarTheme.titleTextStyle.color,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            label: '${'home'.tr()}',
            icon: Icon(Icons.home_outlined),
          ),
          BottomNavigationBarItem(
            label: 'recipes'.tr(),
            icon: Icon(Icons.menu_book_outlined),
          ),
          BottomNavigationBarItem(
            label: 'favorites'.tr(),
            icon: Icon(Icons.favorite_border),
          ),
          BottomNavigationBarItem(
              label: 'products'.tr(),
              icon: Icon(
                Icons.fastfood_outlined,
              )),
          _user.account?.uid != null
              ? BottomNavigationBarItem(
                  label: 'settings'.tr(),
                  icon: Icon(Icons.settings),
                )
              : BottomNavigationBarItem(
                  label: 'signIn'.tr(),
                  icon: Icon(Icons.person_outlined),
                ),
        ],
        currentIndex: viewIndex,
        onTap: (index) {
          _view.changeView(newView: index, uid: _user?.account?.uid);
          _view.doSearch(false);
          _favorites.showFilter(false);
        },
      ),
      body: _view.changeView(
        uid: _user.account?.uid,
        newView: viewIndex,
      ),
    );
  }
}
