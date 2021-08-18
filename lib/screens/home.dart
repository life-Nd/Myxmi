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

// ADDRECIPE <a href="https://storyset.com/work">Work illustrations by Storyset</a>
// APPETIZERS https://unsplash.com/photos/n9xsu46NGaE?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// BASE
// BREAKFAST https://unsplash.com/photos/SQ20tWzxXO0?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// COCKTAIL https://unsplash.com/photos/J5wrhsSPN9o?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// DAIRY
// DATA_NOT_FOUND // <a href="https://storyset.com/work">Work illustrations by Storyset</a>
// DESSERT https://unsplash.com/photos/6iqpLKqeaE0?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// DINNER https://unsplash.com/photos/zzxqoEa64_0?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// DRINKS https://unsplash.com/photos/LbUzPqxPUAs?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// ELIQUID
// FOODS ---
// FRUIT
// KETO https://unsplash.com/photos/auIbTAcSH6E?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// MEAT
// SALAD https://unsplash.com/photos/AiHJiRCwB3w?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// SEAFOOD
// SHAKE https://unsplash.com/photos/4FujjkcI40g?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// SMOOTHIE https://unsplash.com/photos/5HNB4MqxkIM?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// SOUP https://unsplash.com/photos/8mVLMZ0WW98?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// VEGAN https://unsplash.com/photos/zOlQ7lF-3vs?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// VEGETERIAN https://unsplash.com/photos/IGfIGP5ONV0?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink

final homeViewProvider = ChangeNotifierProvider<HomeViewProvider>(
  (ref) => HomeViewProvider(),
);

class Home extends StatelessWidget {
  final String uid;
  const Home({Key key, @required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Consumer(builder: (_, watch, __) {
      final _view = watch(homeViewProvider);
      final int _viewIndex = _view.view;
      
      return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: kIsWeb && _size.width > 500
                ? _view.view == 0
                    ? Size(100.w, 10.h)
                    : Size(100.w, 6.h)
                : Size(100.w, 10.h),
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.only(top: 7, left: 4),
                color: Theme.of(context).appBarTheme.color,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (kIsWeb && _size.width > 500)
                      Expanded(child: WebAppBar()),
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
          body: _view.viewBuilder(uid: uid),
          extendBody: true,
          // ignore: avoid_redundant_argument_values
          bottomNavigationBar:
              kIsWeb && _size.width > 500 ? null : AppBottomNavigation());
    });
  }
}
