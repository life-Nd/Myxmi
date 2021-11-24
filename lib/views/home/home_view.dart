import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/main.dart';
import 'package:myxmi/providers/home_view.dart';
import 'package:myxmi/views/addRecipe/infos/add_infos_view.dart';
import 'package:myxmi/views/home/widgets/app_bottom_navigation.dart';
import 'package:myxmi/views/home/widgets/body.dart';
import 'package:myxmi/views/home/widgets/web_appbar.dart';
import '../products/add/add_new_product_view.dart';


// ADDRECIPE <a href="https://storyset.com/work">Work illustrations by Storyset</a>
// APPETIZERS https://unsplash.com/photos/n9xsu46NGaE?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// BASE
// BREAKFAST https://unsplash.com/photos/SQ20tWzxXO0?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// COCKTAIL https://unsplash.com/photos/1hKZ0A182Bk?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
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
// VEGAN https://unsplash.com/photos/HCZUMu843MQ?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// VEGETERIAN https://unsplash.com/photos/IGfIGP5ONV0?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// VEGETARIAN2 https://unsplash.com/photos/nou2DipA4uM?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// VEGETARIAN3 https://unsplash.com/photos/12eHC6FxPyg?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink


final homeViewProvider = ChangeNotifierProvider<HomeViewProvider>(
  (ref) => HomeViewProvider(),
);

class HomeView extends StatefulWidget {
  static const String route = '/home';

  @override
  State<HomeView> createState() => _HomeState();
}

class _HomeState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Consumer(
      builder: (_, watch, __) {
        final _view = watch(homeViewProvider);
        final _user = watch(userProvider);
        final int _viewIndex = _view.view;
        return Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: true,
          appBar: _size.width >= 700
              ? AppBar(
                  automaticallyImplyLeading: false,
                  flexibleSpace: WebAppBar(uid: _user?.account?.uid),
                )
              : null,
          floatingActionButton: _viewIndex == 0 ||
                  _viewIndex == 1 && _user?.account?.uid != null ||
                  _viewIndex == 3 && _user?.account?.uid != null
              ? _user?.account?.uid != null
                  ? FloatingActionButton(
                      backgroundColor: Colors.green.shade400,
                      onPressed: () {
                        _viewIndex != 3
                            ? Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => AddInfosToRecipe(),
                                ),
                              )
                            : Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => AddNewProduct(),
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
          body: Body(),
          // ignore: avoid_redundant_argument_values
          bottomNavigationBar:
              _size.width <= 700 ? AppBottomNavigation() : null,
        );
      },
    );
  }
}
