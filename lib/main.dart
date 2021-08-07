import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:sizer/sizer.dart';
import 'package:myxmi/app.dart';
import 'providers/prefs.dart';
import 'providers/user.dart';
import 'services/auth.dart';
import 'utils/hot_restart_bypass.dart';

final userProvider =
    ChangeNotifierProvider<UserProvider>((ref) => UserProvider());

final prefProvider =
    ChangeNotifierProvider<PreferencesProvider>((ref) => PreferencesProvider());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
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
    cardColor: const Color(0xFFF5F5F5),
    dividerColor: const Color(0x1f6D42CE),
    highlightColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.black),
    focusColor: Colors.grey.shade800,
    cardTheme: const CardTheme(
      margin: EdgeInsets.all(2),
    ),
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    visualDensity: const VisualDensity(vertical: 0.5, horizontal: 0.5),
    primaryColor: const Color(0xFF212121),
    fontFamily: 'Georgia',
    primaryColorBrightness: Brightness.dark,
    primaryColorLight: Colors.grey.shade200,
    primaryColorDark: Colors.grey.shade800,
    canvasColor: Colors.grey.shade400,
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
    focusColor: Colors.grey.shade800,
    highlightColor: Colors.black,
    cardTheme: const CardTheme(
      margin: EdgeInsets.all(2),
    ),
  );

  runApp(
    Sizer(builder: (context, orientation, deviceType) {
      debugPrint('building runApp');
      return EasyLocalization(
        path: 'translations',
        supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
        child: ProviderScope(
          child: Consumer(builder: (context, watch, child) {
            final _pref = watch(prefProvider);
            return FutureBuilder(
                future: _pref.readPrefs(),
                builder: (context, snapshot) {
                  ThemeMode _storedTheme;
                  if (snapshot.hasData && snapshot.data[0] != null) {
                    _storedTheme =
                        snapshot.data[0] == null || snapshot.data[0] == 'Light'
                            ? ThemeMode.light
                            : ThemeMode.dark;
                  }
                  return MaterialApp(
                    localizationsDelegates: context.localizationDelegates,
                    supportedLocales: context.supportedLocales,
                    locale: context.locale,
                    theme: lightTheme,
                    darkTheme: darkTheme,
                    themeMode: _storedTheme,
                    debugShowCheckedModeBanner: false,
                    home: const Root(),
                  );
                });
          }),
        ),
      );
    }),
  );
}

class Root extends HookWidget {
  const Root({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    debugPrint('building root');
    if (foundation.kDebugMode && foundation.kIsWeb) {
      return HotRestartByPassBuilder(
        destinationFragment: App(),
        loginFragment: const _StreamAuthBuilder(),
      );
    }
    return const _StreamAuthBuilder();
  }
}

class _StreamAuthBuilder extends StatelessWidget {
  const _StreamAuthBuilder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('building streambuilder ');
    return Consumer(builder: (_, watch, __) {
      final _user = watch(userProvider);
      final AuthServices _authServices = AuthServices();
      return StreamBuilder<User>(
        stream: _authServices.userStream(),
        builder: (context, AsyncSnapshot<User> snapUser) {
          if (snapUser.connectionState == ConnectionState.waiting) {
            debugPrint('----snapUser loading');
          }

          if (snapUser != null) _user.loadUser(user: snapUser.data);
          return App();
        },
      );
    });
  }
}
