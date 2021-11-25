// import 'package:flutter/material.dart';

// import 'route_paths.dart';

// class RoutePathInformationParser extends RouteInformationParser<RoutePath> {
//   @override
//   Future<RoutePath> parseRouteInformation(
//       RouteInformation routeInformation) async {
//     final uri = Uri.parse(routeInformation.location);

//     if (uri.pathSegments.length >= 2) {
//       final _recipeId = uri.pathSegments[1];
//       return RoutePath.recipe(_recipeId);
//     } else {
//       return RoutePath.home();
//     }
//   }

//   @override
//   RouteInformation restoreRouteInformation(RoutePath configuration) {
//     if (configuration.isHomePage) {
//       return const RouteInformation(location: '/menu');
//     }
//     if (configuration.isRecipePage) {
//       return RouteInformation(location: '/recipe/${configuration.recipeId}');
//     }
//     return null;
//   }
// }
