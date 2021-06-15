import 'package:myxmi/app.dart';
import 'package:myxmi/provider/view.dart';
import 'package:myxmi/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../main.dart';
import 'add.dart';
import 'package:easy_localization/easy_localization.dart';

final viewProvider = ChangeNotifierProvider<ViewProvider>(
  (ref) => ViewProvider(),
);
int viewIndex = 0;

class Home extends HookWidget {
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final _view = useProvider(viewProvider);
    final _favorites = useProvider(favProvider);
    final _user = useProvider(userProvider);
    return Scaffold(
      appBar: viewIndex == 0 ||
              viewIndex == 1 && _user.account?.uid != null ||
              viewIndex == 2 && _user.account?.uid != null
          ? PreferredSize(
              preferredSize: viewIndex == 0 && _view.searching ||
                      viewIndex == 1 &&
                          _user.account?.uid != null &&
                          _view.searching
                  ? Size(100,_size.width)
                  : Size(55,_size.width),
              child: SafeArea(
                child: SearchRecipes(
                  showFilter:
                      viewIndex == 2 && _user.account?.uid != null ? false : true,
                ),
              ),
            )
          : AppBar(
              automaticallyImplyLeading: false,
              title: Text('Myxmi'),
            ),
      floatingActionButton:
          viewIndex == 0 || viewIndex == 1 && _user.account?.uid != null
              ? FloatingActionButton(
                  backgroundColor: Colors.grey,
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
              : null,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).cardColor,
        selectedItemColor: Colors.green.shade700,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            label: '${'public'.tr()}',
            icon: Icon(Icons.public),
          ),
          BottomNavigationBarItem(
            label: 'myLibrary'.tr(),
            icon: Icon(Icons.my_library_books_outlined),
          ),
          BottomNavigationBarItem(
            label: 'favorites'.tr(),
            icon: Icon(Icons.star),
          ),
          _user.account?.uid != null
              ? BottomNavigationBarItem(
                  label: 'settings'.tr(),
                  icon: Icon(Icons.settings),
                )
              : BottomNavigationBarItem(
                  label: 'signIn'.tr(),
                  icon: Icon(Icons.person),
                ),
        ],
        currentIndex: viewIndex,
        onTap: (index) {
          viewIndex = index;
          _view.doSearch(false);
          _favorites.showFilter(false);
        },
      ),
      body: Container(
        height: _size.height,
        width: _size.width,
        padding: EdgeInsets.all(4),
        child: _view.changeView(
          uid: _user.account?.uid,
          newView: viewIndex,
        ),
      ),
    );
  }
}
