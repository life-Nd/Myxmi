import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/configure_nonweb.dart'
    if (dart.library.html) 'package:myxmi/configure_nonweb.dart';
import 'package:myxmi/navigator/information_parser.dart';
import 'package:myxmi/providers/prefs.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/utils/dark_theme.dart';
import 'package:myxmi/utils/light_theme.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uni_links/uni_links.dart';

Future<void> main() async {
  configureApp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  // !kIsWeb ?? MobileAds.instance.initialize();

  if (kIsWeb) {
    FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }

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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _pref = ref.watch(prefProvider);
        return FutureBuilder<List?>(
          future: _pref.readPrefs(),
          builder: (context, AsyncSnapshot<List?> snapshot) {
            // Get the preferences of the user stored locally
            ThemeMode? _storedTheme;

            final List _data = snapshot.data ?? [];
            if (snapshot.hasData && _data[0] != null) {
              _storedTheme = _data[0] == null || _data[0] == 'Light'
                  ? ThemeMode.light
                  : ThemeMode.dark;
            }
            return MyApp(storedTheme: _storedTheme);
          },
        );
      },
    );
  }
}

class MyApp extends ConsumerStatefulWidget {
  final ThemeMode? storedTheme;
  const MyApp({Key? key, required this.storedTheme}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  StreamSubscription? _linkSubscription;
  @override
  void initState() {
    final _router = ref.read(routerProvider);
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
    final _router = ref.read(routerProvider);
    try {
      // Get the link that launched the app
      final initialUri = await getInitialUri();
      if (initialUri != null) _router.parseRoute(initialUri);
    } on FormatException catch (error) {
      debugPrint('error.printError(): ${error.message}');
    }
    // Attach a listener to the uri_links stream
    _linkSubscription = uriLinkStream.listen(
      (uri) {
        if (!mounted) return;
        _router.parseRoute(uri!);
      },
      onError: (error) => debugPrint(error.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _router = ref.watch(routerProvider);
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Myxmi',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: widget.storedTheme,
          builder: (context, widget) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, widget!),
            defaultScale: true,
            breakpoints: const [
              ResponsiveBreakpoint.resize(450, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.autoScale(1000, name: TABLET),
              ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              ResponsiveBreakpoint.autoScale(2460, name: "4K"),
            ],
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          routeInformationParser: MyRouteInformationParser(),
          routerDelegate: _router,
        );
      },
    );
  }
}
