import 'package:flutter/foundation.dart';
import 'package:myxmi/providers/home_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/widgets/app_bottom_navigation.dart';
import 'package:myxmi/widgets/search.dart';
import 'package:myxmi/widgets/web_appbar.dart';
import 'package:sizer/sizer.dart';
import 'add_product.dart';
import 'add_recipe_infos.dart';

final homeViewProvider = ChangeNotifierProvider<HomeViewProvider>(
  (ref) => HomeViewProvider(),
);

class Home extends StatelessWidget {
  final String uid;
  const Home({Key key, @required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('building home');
    final Size _size = MediaQuery.of(context).size;
    return Consumer(builder: (_, watch, __) {
      final _view = watch(homeViewProvider);
      final int _viewIndex = _view.view;
      return Scaffold(
          appBar: PreferredSize(
            preferredSize: kIsWeb && _size.width > 500
                ? Size(100.h, 200)
                : Size(100.h, 100),
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.only(top: 7, left: 4),
                color: Theme.of(context).appBarTheme.color,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (kIsWeb && _size.width > 500)
                      SizedBox(width: 100.h, child: WebAppBar()),
                    if (_view.view == 0) const SearchRecipes(),
                    if (_view.view == 4)
                      kIsWeb
                          ? Container()
                          : const ListTile(title: Text('Myxmi')),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: _viewIndex == 0 ||
                  _viewIndex == 1 && uid != null ||
                  _viewIndex == 3 && uid != null
              ? uid != null
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
                        _view.changeViewIndex(index: 4, uid: uid);
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    )
              : null,
          body: SafeArea(
            child: _view.viewBuilder(uid: uid),
          ),
          extendBody: true,
          // ignore: avoid_redundant_argument_values
          bottomNavigationBar:
              kIsWeb && _size.width > 500 ? null : AppBottomNavigation());
    });
  }
}
