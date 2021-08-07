import 'package:flutter/foundation.dart';

import 'package:myxmi/providers/view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/widgets/app_bottom_navigation.dart';
import 'package:myxmi/widgets/search.dart';
import 'package:myxmi/widgets/web_appbar.dart';
import 'package:sizer/sizer.dart';
import '../main.dart';
import 'add_product.dart';
import 'add_recipe_infos.dart';

final viewProvider = ChangeNotifierProvider<ViewProvider>(
  (ref) => ViewProvider(),
);

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    debugPrint('building home');
    final consumer = Consumer(builder: (_, watch, __) {
      final _view = watch(viewProvider);
      final _user = watch(userProvider);
      final int _viewIndex = _view.view;
      final bool _showSearchBarFab = _viewIndex == 0 ||
          _viewIndex == 1 && _user.account?.uid != null ||
          _viewIndex == 2 && _user.account?.uid != null ||
          _viewIndex == 3 && _user.account?.uid != null;
      debugPrint('_viewIndex; $_viewIndex');
      debugPrint(
          'View ${_viewIndex == 0 || _viewIndex == 1 || _viewIndex == 3}');
      final scaffold = Scaffold(
          appBar: PreferredSize(
            preferredSize: kIsWeb ? Size(100.h, 200) : Size(100.h, 100),
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.only(top: 7, left: 4),
                color: Theme.of(context).appBarTheme.color,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (kIsWeb) SizedBox(width: 100.h, child: WebAppBar()),
                    if (_showSearchBarFab)
                      SearchRecipes()
                    else
                      kIsWeb
                          ? Container()
                          : const ListTile(title: Text('Myxmi')),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: _viewIndex == 0 ||
                  _viewIndex == 1 && _user.account?.uid != null ||
                  _viewIndex == 3 && _user.account?.uid != null
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
                        _view.changeViewIndex(
                            index: 4, uid: _user?.account?.uid);
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    )
              : null,
          body: _view.viewBuilder(uid: _user?.account?.uid),
          // ignore: avoid_redundant_argument_values
          bottomNavigationBar: kIsWeb ? null : const AppBottomNavigation());
      return scaffold;
    });
    return consumer;
  }
}
