import 'package:flutter/material.dart';

class MyRouteInformationParser
    extends RouteInformationParser<List<RouteSettings>> {
  @override
  Future<List<RouteSettings>> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = Uri.parse(routeInformation.location!);
    if (uri.pathSegments.isEmpty) {
      return Future.value([const RouteSettings(name: '/')]);
    }
    final routeSettings = uri.pathSegments.map((pathSegment) {
      return RouteSettings(
        name: '/$pathSegment',
        arguments:
            pathSegment == uri.pathSegments.last ? uri.queryParameters : null,
      );
    }).toList();
    return Future.value(routeSettings);
  }

  @override
  RouteInformation restoreRouteInformation(List<RouteSettings> configuration) {
    final location = configuration.last.name;
    final arguments = _restoreArguments(configuration.last);
    return RouteInformation(location: '$location$arguments');
  }

  String _restoreArguments(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return '';
      case '/recipe':
        return '?id=${(routeSettings.arguments! as Map)['id'].toString()}';
      case '/filter':
        return '?type=${(routeSettings.arguments! as Map)['type'].toString()}';
      case '/favorites':
        return '?uid=${(routeSettings.arguments! as Map)['uid'].toString()}';
      case '/products':
        return '?uid=${(routeSettings.arguments! as Map)['uid'].toString()}';
      default:
        return '';
    }
  }
}
