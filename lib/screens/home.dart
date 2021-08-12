import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:myxmi/providers/view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/widgets/app_bottom_navigation.dart';
import 'package:myxmi/widgets/search.dart';
import 'package:myxmi/widgets/web_appbar.dart';
import 'package:sizer/sizer.dart';
import 'add_product.dart';
import 'add_recipe_infos.dart';

final viewProvider = ChangeNotifierProvider<ViewProvider>(
  (ref) => ViewProvider(),
);

class Home extends HookWidget {
  final String uid;
  const Home({Key key, @required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    

    debugPrint('building home');
    final _view = useProvider(viewProvider);

    final int _viewIndex = _view.view;
    return Scaffold(
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
                  if (_view.view == 0) const SearchRecipes(),
                  if (_view.view == 4)
                    kIsWeb ? Container() : const ListTile(title: Text('Myxmi')),
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
        bottomNavigationBar: kIsWeb ? null : AppBottomNavigation());
  }
}
