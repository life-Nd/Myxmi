import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/utils/auth.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_strategy/url_strategy.dart';
import 'app.dart';
import 'providers/app_network.dart';
import 'providers/cart.dart';
import 'providers/prefs.dart';
import 'providers/user.dart';
import 'utils/dark_theme.dart';
import 'utils/light_theme.dart';

final userProvider =
    ChangeNotifierProvider<UserProvider>((ref) => UserProvider());

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
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  // !kIsWeb ?? MobileAds.instance.initialize();
  setPathUrlStrategy();

  kIsWeb ?? FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

  runApp(
    EasyLocalization(
      path: 'translations',
      supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
      child: ProviderScope(
        child: Consumer(
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
              },
            );
          },
        ),
      ),
    ),
  );
}
