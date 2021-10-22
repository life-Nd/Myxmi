import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/home.dart';
import 'package:myxmi/screens/selected_recipe.dart';
import 'package:myxmi/utils/auth.dart';
import 'package:sizer/sizer.dart';
import 'app.dart';
import 'providers/cart.dart';
import 'providers/prefs.dart';
import 'providers/user.dart';

// TODO https://myxmi.app/more/about/privacy
final userProvider =
    ChangeNotifierProvider<UserProvider>((ref) => UserProvider());
final authProvider =
    ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider());
final prefProvider =
    ChangeNotifierProvider<PreferencesProvider>((ref) => PreferencesProvider());
final cartProvider =
    ChangeNotifierProvider<CartProvider>((ref) => CartProvider());

final firebaseAuth = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  !kIsWeb ?? MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  kIsWeb ?? FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    visualDensity: const VisualDensity(vertical: 0.5, horizontal: 0.5),
    primaryColor: Colors.grey.shade100,
    primaryColorBrightness: Brightness.light,
    primaryColorLight: Colors.grey.shade100,
    primaryColorDark: Colors.grey.shade800,
    canvasColor: Colors.grey.shade400,
    fontFamily: 'Georgia',
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(),
    iconTheme: const IconThemeData(color: Colors.black),
    appBarTheme: const AppBarTheme(
      shadowColor: Colors.white,
      color: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      elevation: 1,
      titleTextStyle: TextStyle(color: Colors.black),
    ),
    cardColor: const Color(0xFFF5F5F5),
    dividerColor: const Color(0x1f6D42CE),
    highlightColor: Colors.white,
    focusColor: Colors.grey.shade800,
    cardTheme: const CardTheme(margin: EdgeInsets.all(2)),
    colorScheme: const ColorScheme.light(),
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    visualDensity: const VisualDensity(vertical: 0.5, horizontal: 0.5),
    primaryColor: Colors.black,
    primaryColorBrightness: Brightness.dark,
    primaryColorLight: Colors.grey.shade200,
    primaryColorDark: Colors.grey.shade800,
    canvasColor: Colors.black,
    fontFamily: 'Georgia',
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(),
    iconTheme: const IconThemeData(color: Colors.white),
    appBarTheme: const AppBarTheme(
      shadowColor: Colors.black,
      color: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: TextStyle(color: Colors.white),
      elevation: 1,
    ),
    bottomAppBarColor: const Color(0xff6D42CE),
    cardColor: const Color(0xFF303030),
    dividerColor: const Color(0x1f6D42CE),
    focusColor: Colors.grey.shade800,
    highlightColor: Colors.black,
    cardTheme: const CardTheme(margin: EdgeInsets.all(2)),
    colorScheme: const ColorScheme.dark(),
  );

  runApp(
    Sizer(builder: (context, orientation, deviceType) {
      return EasyLocalization(
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
                    title: 'Myxmi',
                    localizationsDelegates: context.localizationDelegates,
                    supportedLocales: context.supportedLocales,
                    locale: context.locale,
                    theme: lightTheme,
                    darkTheme: darkTheme,
                    themeMode: _storedTheme,
                    debugShowCheckedModeBanner: false,
                    initialRoute: '/',
                    routes: {
                      App.route: (context) => App(),
                      Home.route: (context) => Home(),
                      SelectedRecipe.route: (context) => const SelectedRecipe(),
                    },
                    // home: App(),
                  );
                },
              );
            },
          ),
        ),
      );
    }),
  );
}
