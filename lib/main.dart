import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/utils/auth.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uni_links/uni_links.dart';

import 'navigator/information_parser.dart';
import 'navigator/router.dart';
import 'providers/app_network.dart';
import 'providers/cart.dart';
import 'providers/prefs.dart';
import 'providers/user.dart';
import 'utils/dark_theme.dart';
import 'utils/light_theme.dart';

final userProvider =
    ChangeNotifierProvider<UserProvider>((ref) => UserProvider());
final routerProvider = Provider<RouterProvider>((ref) => RouterProvider());

final authProvider =
    ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider());
final prefProvider =
    ChangeNotifierProvider<PreferencesProvider>((ref) => PreferencesProvider());
final cartProvider =
    ChangeNotifierProvider<CartProvider>((ref) => CartProvider());
final firebaseAuth = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final appNetworkProvider =
    Provider<AppNetworkProvider>((ref) => AppNetworkProvider());

Future<void> main() async {
  // debugPrint('RUNNIG MAIN');
  WidgetsFlutterBinding.ensureInitialized();
  // debugPrint('RUNNIG WidgetsFlutterBinding.ensureInitialized()');
  await Firebase.initializeApp();
  // debugPrint('RUNNIG Firebase.initializeApp()');
  await EasyLocalization.ensureInitialized();
  // debugPrint('RUNNIG WidgetsFlutterBinding.ensureInitialized()');
  // !kIsWeb ?? MobileAds.instance.initialize();
  // setPathUrlStrategy();

  kIsWeb ?? FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

  runApp(
    EasyLocalization(
      path: 'translations',
      supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
      child: const ProviderScope(
        child: Root(),
      ),
    ),
  );
}

class Root extends StatelessWidget {
  const Root({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final _pref = watch(prefProvider);
        return FutureBuilder(
          future: _pref.readPrefs(),
          builder: (context, snapshot) {
            // Get the preferences of the user stored locally
            ThemeMode _storedTheme;
            if (snapshot.hasData && snapshot.data[0] != null) {
              _storedTheme =
                  snapshot.data[0] == null || snapshot.data[0] == 'Light'
                      ? ThemeMode.light
                      : ThemeMode.dark;
            }
            return MyApp(storedTheme: _storedTheme);
            /*
            return MaterialApp(
              builder: (context, widget) => ResponsiveWrapper.builder(
                BouncingScrollWrapper.builder(context, widget),
                minWidth: 450,
                defaultScale: true,
                breakpoints: const [
                  ResponsiveBreakpoint.resize(450, name: MOBILE),
                  ResponsiveBreakpoint.autoScale(800, name: TABLET),
                  ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                  ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                  ResponsiveBreakpoint.autoScale(2460, name: "4K"),
                ],
              ),
              title: 'Myxmi',
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              // locale: context.locale,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: _storedTheme,
              debugShowCheckedModeBanner: false,
              home: const App(),
            );
            */
          },
        );
      },
    );
  }
}

class MyApp extends StatefulWidget {
  final ThemeMode storedTheme;
  const MyApp({Key key, @required this.storedTheme}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final routerDelegate = Get.put(MyRouterDelegate());

  StreamSubscription _linkSubscription;

  @override
  void initState() {
    final _router = context.read(routerProvider);
    super.initState();
    _router.pushPage(name: '/');

    if (!kIsWeb) initialize();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initialize() async {
    final _router = context.read(routerProvider);
    try {
      // Get the link that launched the app
      final initialUri = await getInitialUri();

      if (initialUri != null) _router.parseRoute(initialUri);
    } on FormatException catch (error) {
      debugPrint('error.printError(): ${error.message}');
    }

    // Attach a listener to the uri_links stream
    _linkSubscription = uriLinkStream.listen((uri) {
      if (!mounted) return;

      _router.parseRoute(uri);
    }, onError: (error) => error.printError());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, child) {
      final _router = watch(routerProvider);
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Myxmi',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: lightTheme,
        darkTheme: darkTheme,
        builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget),
          minWidth: 450,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
        ),
        themeMode: widget.storedTheme,
        routeInformationParser: MyRouteInformationParser(),
        routerDelegate: _router,
      );
    });
  }
}
