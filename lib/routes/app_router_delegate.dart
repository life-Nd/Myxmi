// import 'package:flutter/material.dart';
// import 'package:myxmi/streams/recipe_shared.dart';

// import '../app.dart';
// import 'route_paths.dart';

// class AppRouterDelegate extends RouterDelegate<RoutePath>
//     with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
//   @override
//   final GlobalKey<NavigatorState> navigatorKey;

//   String _sharedRecipeId = 'b7iNsjJXhbtibeQVXMpY';

//   AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

//   @override
//   RoutePath get currentConfiguration => _sharedRecipeId == null
//       ? RoutePath.home()
//       : RoutePath.recipe(_sharedRecipeId);

//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       key: navigatorKey,
//       pages: [
//         const MaterialPage(
//           key: ValueKey('app'),
//           child: App(),
//         ),
//         // MaterialPage(
//         //   key: const ValueKey('RecipesListPage'),
//         //   child: RecipesListScreen(
//         //     recipes: recipes,
//         //     onTapped: _handleRecipeTapped,
//         //   ),
//         // ),
//         if (_sharedRecipeId != null)
//           RecipeSharedStreamBuilder(recipeId: _sharedRecipeId)
//       ],
//       onPopPage: (route, result) {
//         if (!route.didPop(result)) {
//           return false;
//         }
//         // Update the list of pages by setting _selectedRecipe to null
//         _sharedRecipeId = null;
//         notifyListeners();
//         return true;
//       },
//     );
//   }

//   @override
//   Future<void> setNewRoutePath(RoutePath configuration) async {
//     if (configuration.isRecipePage) {
//       _sharedRecipeId = configuration.recipeId;
//     }
//   }

//   void _handleRecipeTapped(String recipeId) {
//     _sharedRecipeId = recipeId;
//     notifyListeners();
//   }
// }
