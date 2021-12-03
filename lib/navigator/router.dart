import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/app.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/utils/loading_column.dart';
import 'package:myxmi/views/home/home_view.dart';
import 'package:myxmi/views/recipes/filtered_view.dart';
import 'package:myxmi/views/recipes/widgets/recipe_image.dart';
import 'package:myxmi/views/selectedRecipe/selected_recipe_view.dart';
import 'package:myxmi/views/selectedRecipe/widgets/recipe_details.dart';
import 'transition_delegate.dart';

class RouterProvider extends RouterDelegate<List<RouteSettings>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<RouteSettings>> {
  final _pages = <Page>[];

  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  List<Page> get currentConfiguration => List.of(_pages);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: List.of(_pages),
      onPopPage: _onPopPage,
      transitionDelegate: const MyTransitionDelegate(),
    );
  }

  @override
  Future<bool> popRoute() {
    if (_pages.length > 1) {
      _pages.removeLast();
      notifyListeners();
      return Future.value(true);
    }

    return _confirmAppExit();
  }

  @override
  Future<void> setNewRoutePath(List<RouteSettings> configuration) {
    _setPath(configuration
        .map((routeSettings) => _createPage(routeSettings))
        .toList());
    return Future.value(null);
  }

  void parseRoute(Uri uri) {
    if (uri.pathSegments.isEmpty) {
      setNewRoutePath([const RouteSettings(name: '/')]);
    } else {
      setNewRoutePath(uri.pathSegments
          .map((pathSegment) => RouteSettings(
                name: '/$pathSegment',
                arguments: pathSegment == uri.pathSegments.last
                    ? uri.queryParameters
                    : null,
              ))
          .toList());
    }
  }

  bool _onPopPage(Route route, dynamic result) {
    if (!route.didPop(result)) return false;

    popRoute();
    return true;
  }

  void _setPath(List<Page> pages) {
    debugPrint('RUNNING _setPath');
    _pages.clear();
    _pages.addAll(pages);

    if (_pages.first.name != '/') {
      _pages.insert(0, _createPage(const RouteSettings(name: '/')));
    }
    notifyListeners();
  }

  void pushPage({@required String name, dynamic arguments}) {
    debugPrint('RUNNING pushPage');
    debugPrint('name: $name');
    debugPrint('arguments: $arguments');

    _pages.add(_createPage(RouteSettings(name: name, arguments: arguments)));
    debugPrint("_pages: $_pages");
    notifyListeners();
  }

  MaterialPage _createPage(RouteSettings routeSettings) {
    debugPrint('RUNNING _createPage');
    Widget child;
    switch (routeSettings.name) {
      case '/':
        child = const App();
        break;
      case '/recipe':
        debugPrint('routeSettings.arguments: ${routeSettings.arguments}');
        final String _argumentId =
            (routeSettings?.arguments as Map)['id'] as String;
        child = routeSettings.arguments != null
            ? Consumer(
                builder: (_, watch, child) {
                  final _recipeDetails = watch(recipeDetailsProvider)?.details;
                  if (_recipeDetails?.recipeId != null &&
                      _recipeDetails?.recipeId == _argumentId) {
                    return const SelectedRecipe();
                  } else {
                    debugPrint(
                        "routeSettings?.arguments as Map): ${routeSettings?.arguments}");
                    return StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Recipes')
                            .doc(_argumentId)
                            .snapshots(),
                        builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot?.data != null &&
                              snapshot?.data?.data() != null) {
                            final _recipe = watch(recipeDetailsProvider);
                            _recipe.details = RecipeModel.fromSnapshot(
                              snapshot: snapshot?.data?.data()
                                  as Map<String, dynamic>,
                              keyIndex: snapshot?.data?.id,
                            );
                            _recipe.image = RecipeImage(
                              recipe: _recipe?.details,
                              fitWidth: true,
                            );
                            return const SelectedRecipe();
                          } else {
                            return const Scaffold(
                              body: LoadingColumn(),
                            );
                          }
                        });
                  }
                },
              )
            : HomeView();
        break;
      case '/filter':
        debugPrint('ROUTER:${routeSettings?.arguments}');
        child = Filtered(
          type: (routeSettings?.arguments as Map)['type'].toString(),
        );
        break;
      default:
        child = Scaffold(
          appBar: AppBar(title: const Text('404')),
          body: const Center(child: Text('Page not found')),
        );
    }

    return MaterialPage(
      child: child,
      name: routeSettings.name,
      arguments: routeSettings.arguments,
    );
  }

  Future<bool> _confirmAppExit() async {
    final result = await showDialog<bool>(
        context: navigatorKey.currentContext,
        builder: (context) {
          return AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context, true),
              ),
              TextButton(
                child: const Text('Confirm'),
                onPressed: () => Navigator.pop(context, false),
              ),
            ],
          );
        });

    return result ?? true;
  }
}
