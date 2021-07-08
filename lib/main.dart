import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_machine/time_machine.dart';
import 'app.dart';

import 'providers/user.dart';

final userProvider =
    ChangeNotifierProvider<UserProvider>((ref) => UserProvider());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TimeMachine.initialize({'rootBundle': rootBundle});
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    EasyLocalization(
      path: 'translations',
      supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
      child: ProviderScope(
        child: Consumer(
          builder: (context, watch, child) {
            final _userProvider = watch(userProvider);
            return StreamBuilder<User>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, AsyncSnapshot<User> snapUser) {
                _userProvider.changeUser(newUser: snapUser.data);
                return MaterialAppWidget();
              },
            );
          },
        ),
      ),
    ),
  );
}

class MaterialAppWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MaterialAppWidgetState();
}

class MaterialAppWidgetState extends State<MaterialAppWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final _pref = watch(prefProvider);
      return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: _pref.theme == null || _pref.theme == 'Light'
            ? lightTheme
            : darkTheme,
        debugShowCheckedModeBanner: false,
        home: App(),
      );
    });
  }
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  visualDensity: const VisualDensity(vertical: 0.5, horizontal: 0.5),
  primarySwatch: const MaterialColor(
    0xFFF5E0C3,
    <int, Color>{
      50: Color(0x1aF5E0C3),
      100: Color(0xa1F5E0C3),
      200: Color(0xaaF5E0C3),
      300: Color(0xafF5E0C3),
      400: Color(0xffF5E0C3),
      500: Color(0xffEDD5B3),
      600: Color(0xffDEC29B),
      700: Color(0xffC9A87C),
      800: Color(0xffB28E5E),
      900: Color(0xff936F3E)
    },
  ),
  primaryColor: Colors.white,
  primaryColorBrightness: Brightness.light,
  primaryColorLight: Colors.grey.shade100,
  primaryColorDark: Colors.grey.shade800,
  canvasColor: Colors.transparent,
  accentColor: const Color(0xff457BE0),
  accentColorBrightness: Brightness.light,
  fontFamily: 'Georgia',
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(),
  appBarTheme: const AppBarTheme(
    shadowColor: Colors.white,
    brightness: Brightness.light,
    color: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
    ),
    elevation: 1,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
  cardColor: const Color(0xaaF5E0C3),
  dividerColor: const Color(0x1f6D42CE),
  iconTheme: const IconThemeData(color: Colors.black),
  focusColor: const Color(0xDD000000),
  cardTheme: const CardTheme(
    margin: EdgeInsets.all(2),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  visualDensity: const VisualDensity(vertical: 0.5, horizontal: 0.5),
  primarySwatch: const MaterialColor(0xFFF5E0C3, <int, Color>{
    50: Color(0x1a5D4524),
    100: Color(0xa15D4524),
    200: Color(0xaa5D4524),
    300: Color(0xaf5D4524),
    400: Color(0x1a483112),
    500: Color(0xa1483112),
    600: Color(0xaa483112),
    700: Color(0xff483112),
    800: Color(0xaf2F1E06),
    900: Color(0xff2F1E06),
  }),
  primaryColor: const Color(0xFF212121),
  fontFamily: 'Georgia',
  primaryColorBrightness: Brightness.dark,
  primaryColorLight: Colors.grey.shade200,
  primaryColorDark: Colors.grey.shade800,
  canvasColor: Colors.transparent,
  accentColor: const Color(0xff457BE0),
  accentColorBrightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xDD000000),
  iconTheme: const IconThemeData(color: Colors.white),
  textTheme: const TextTheme(),
  appBarTheme: const AppBarTheme(
    brightness: Brightness.dark,
    color: Colors.black,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    titleTextStyle: TextStyle(color: Colors.white),
    elevation: 1,
  ),
  bottomAppBarColor: const Color(0xff6D42CE),
  cardColor: const Color(0xFF303030),
  dividerColor: const Color(0x1f6D42CE),
  buttonColor: const Color(0xFF303030),
  focusColor: const Color(0xFFFFFFFF),
  cardTheme: const CardTheme(
    margin: EdgeInsets.all(2),
  ),
);
