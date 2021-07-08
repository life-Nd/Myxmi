import 'package:myxmi/providers/favorites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'main.dart';
import 'providers/prefs.dart';
import 'screens/home.dart';

final firebaseAuth = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});
final favProvider = Provider<FavoritesProvider>(
  (ref) => FavoritesProvider(),
);

final prefProvider =
    ChangeNotifierProvider<PreferencesProvider>((ref) => PreferencesProvider());

class App extends HookWidget {
  @override
  Widget build(BuildContext context) {

    final _userProvider = useProvider(userProvider);
    final _prefProvider = useProvider(prefProvider);
    return FutureBuilder(
      future: _prefProvider.readLanguage(),
      builder: (_, data) {
        return Consumer(
          builder: (_, watch, child) {
            final _favProvider = watch(favProvider);
            return _userProvider.account != null
                ? StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Favorites')
                        .doc(_userProvider.account.uid)
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData && snapshot.data.data() != null) {
                        final _data = snapshot.data.data();
                        _favProvider.addFavorites(
                            newFavorite: _data as Map<String, dynamic>);
                      }
                      return Home();
                    },
                  )
                : Home();
          },
        );
      },
    );
  }
}
