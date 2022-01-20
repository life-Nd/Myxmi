import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/app.dart';
import 'package:myxmi/models/recipe.dart';
import 'package:myxmi/navigator/transition_delegate.dart';
import 'package:myxmi/screens/calendar/calendar_screen.dart';
import 'package:myxmi/screens/cart/cart_view.dart';
import 'package:myxmi/screens/home/home_screen.dart';
import 'package:myxmi/screens/instructions/instructions_screen.dart';
import 'package:myxmi/screens/more/about/view.dart';
import 'package:myxmi/screens/more/settings/view.dart';
import 'package:myxmi/screens/products/add/add_product_manually.dart';
import 'package:myxmi/screens/products/add/scan_product.dart';
import 'package:myxmi/screens/profile/profile_screen.dart';
import 'package:myxmi/screens/recipes/add/infos/add_infos_screen.dart';
import 'package:myxmi/screens/recipes/add/instructions/add_instructions_screen.dart';
import 'package:myxmi/screens/recipes/add/products/add_recipe_products_screen.dart';
import 'package:myxmi/screens/recipes/list/filtered_screen.dart';
import 'package:myxmi/screens/recipes/list/widgets/recipe_image.dart';
import 'package:myxmi/screens/recipes/selected/selected_recipe_view.dart';
import 'package:myxmi/screens/recipes/selected/widgets/recipe_details.dart';
import 'package:myxmi/screens/support/support_screen.dart';
import 'package:myxmi/utils/loading_column.dart';

final routerProvider = Provider<RouterProvider>((ref) => RouterProvider());

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
    _setPath(
      configuration.map((routeSettings) => _createPage(routeSettings)).toList(),
    );
    return Future.value(null);
  }

  void parseRoute(Uri uri) {
    if (uri.pathSegments.isEmpty) {
      setNewRoutePath([const RouteSettings(name: '/')]);
    } else {
      setNewRoutePath(
        uri.pathSegments
            .map(
              (pathSegment) => RouteSettings(
                name: '/$pathSegment',
                arguments: pathSegment == uri.pathSegments.last
                    ? uri.queryParameters
                    : null,
              ),
            )
            .toList(),
      );
    }
  }

  bool _onPopPage(Route route, dynamic result) {
    if (!route.didPop(result)) return false;

    popRoute();
    return true;
  }

  void _setPath(List<Page> pages) {
    _pages.clear();
    _pages.addAll(pages);

    if (_pages.first.name != '/') {
      _pages.insert(0, _createPage(const RouteSettings(name: '/')));
    }
    notifyListeners();
  }

  void pushPage({required String name, dynamic arguments}) {
    _pages.add(_createPage(RouteSettings(name: name, arguments: arguments)));
    notifyListeners();
  }

  MaterialPage _createPage(RouteSettings routeSettings) {
    Widget child;
    switch (routeSettings.name) {
      case '/':
        child = const App();
        break;
      case '/home':
        child = HomeScreen();
        break;
      case '/recipe':
        final String? _argumentId =
            (routeSettings.arguments! as Map)['id'] as String?;
        child = routeSettings.arguments != null
            ? Consumer(
                builder: (_, ref, child) {
                  final _recipeDetails =
                      ref.watch(recipeDetailsProvider).details;
                  if (_recipeDetails.recipeId != null &&
                      _recipeDetails.recipeId == _argumentId) {
                    return const SelectedRecipe();
                  } else {
                    return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Recipes')
                          .doc(_argumentId)
                          .snapshots(),
                      builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.data != null &&
                            snapshot.data!.data() != null) {
                          final _recipe = ref.watch(recipeDetailsProvider);
                          _recipe.details = RecipeModel.fromSnapshot(
                            snapshot:
                                snapshot.data!.data()! as Map<String, dynamic>,
                            keyIndex: snapshot.data?.id,
                          );
                          _recipe.image = RecipeImage(
                            recipe: _recipe.details,
                            fitWidth: true,
                          );
                          return const SelectedRecipe();
                        } else {
                          return const Scaffold(
                            body: LoadingColumn(),
                          );
                        }
                      },
                    );
                  }
                },
              )
            : HomeScreen();
        break;

      case '/filter':
        child = FilteredScreen(
          type: (routeSettings.arguments! as Map)['type'].toString(),
        );
        break;

      case '/calendar':
        child = const CalendarScreen(
          showAppBar: true,
        );
        break;

      case '/add-recipe-infos':
        child = const AddRecipeInfosScreen();
        break;

      case '/add-recipe-products':
        child = const AddRecipeProductsScreen();
        break;

      case '/add-recipe-instructions':
        child = AddRecipeInstructionsScreen();
        break;

      case '/scan-product':
        child = const ScanProductScreen();
        break;

      case '/add-product-manually':
        child = const AddProductManuallyScreen();
        break;

      case '/account':
        child = const ProfileScreen();
        break;

      case '/settings':
        child = const SettingsScreen();
        break;

      case '/instructions':
        child = const InstructionsScreen();
        break;

      case '/cart':
        child = const CartView();
        break;

      case '/support':
        child = const SupportTicketsScreen();
        break;

      case '/about':
        child = const AboutScreen();
        break;

      default:
        child = Scaffold(
          appBar: AppBar(title: const Text('404')),
          body: Column(
            children: [
              Image.asset('assets/data_not_found.png'),
              const Center(child: Text('404')),
            ],
          ),
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
      context: navigatorKey!.currentContext!,
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
      },
    );

    return result ?? true;
  }
}
