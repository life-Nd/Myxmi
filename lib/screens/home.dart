import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/main.dart';
import 'package:myxmi/providers/home_view.dart';
import 'package:myxmi/utils/app_sources.dart';
import 'package:myxmi/widgets/app_bottom_navigation.dart';
import 'package:myxmi/widgets/web_appbar.dart';
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
// ALL DIETS https://unsplash.com/photos/NPBnWE1o07I
// DRINKS https://unsplash.com/photos/LbUzPqxPUAs?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// ELIQUID
// FOODS ---
// FRUIT
// KETO https://unsplash.com/photos/auIbTAcSH6E?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// MEAT
// SALAD https://unsplash.com/photos/AiHJiRCwB3w?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// SAUCES&SPICES <a href='https://www.freepik.com/photos/background'>Background photo created by KamranAydinov - www.freepik.com</a>
// SEAFOOD
// SHAKE https://unsplash.com/photos/4FujjkcI40g?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// SHAKE2 https://unsplash.com/photos/KlVIYmGVRQ8?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// SMOOTHIE https://unsplash.com/photos/5HNB4MqxkIM?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// SOUP https://unsplash.com/photos/8mVLMZ0WW98?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// VEGAN https://unsplash.com/photos/zOlQ7lF-3vs?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// VEGAN2 https://unsplash.com/photos/-ftWfohtjNw?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// VEGETERIAN https://unsplash.com/photos/IGfIGP5ONV0?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// VEGETARIAN2 https://unsplash.com/photos/nou2DipA4uM?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink

final homeViewProvider = ChangeNotifierProvider<HomeViewProvider>(
  (ref) => HomeViewProvider(),
);

class Home extends StatefulWidget {
  final String uid;
  const Home({Key key, @required this.uid}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _webView = false;
  final AppSources _appSources = AppSources();

  @override
  void initState() {
    if (kIsWeb) {
      final _user = context.read(userProvider);
      try {
        if (Device.get().isPhone || Device.get().isTablet) {
          Future.delayed(Duration.zero, () {
            _user.onMobileApp = true;
            _appSources.downloadAppDialog(context);
          });
          _webView = false;
        }
      } catch (error) {
        _user.onMobileApp = false;
        debugPrint('Web && !phone');
        _webView = true;
      }

      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, watch, __) {
        final _view = watch(homeViewProvider);
        final int _viewIndex = _view.view;
        return Scaffold(
          resizeToAvoidBottomInset: true,
          // ignore: avoid_redundant_argument_values
          appBar: _webView
              ? AppBar(
                  automaticallyImplyLeading: false,
                  title: WebAppBar(uid: widget.uid),
                )
              : null,
          floatingActionButton: _viewIndex == 0 ||
                  _viewIndex == 1 && widget.uid != null ||
                  _viewIndex == 3 && widget.uid != null
              ? widget.uid != null
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
                        _view.changeViewIndex(index: 4, uid: widget.uid);
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    )
              : null,
          body: SafeArea(child: _view.viewBuilder(uid: widget.uid)),
          extendBody: true,
          // ignore: avoid_redundant_argument_values
          bottomNavigationBar: _webView ? null : AppBottomNavigation(),
        );
      },
    );
  }
}
