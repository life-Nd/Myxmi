import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'main.dart';
import 'providers/favorites.dart';
import 'screens/home.dart';

final firebaseAuth = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});
final favProvider = Provider<FavoritesProvider>(
  (ref) => FavoritesProvider(),
);

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    debugPrint('building app');

    return Consumer(
      builder: (_, watch, child) {
        final _favProvider = watch(favProvider);
        final _userProvider = watch(userProvider);
        final streamBuilder = StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Favorites')
              .doc(_userProvider?.account?.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              debugPrint('--loading--firebase: favorites');
            }
            if (snapshot.hasData && snapshot.data.data() != null) {
              final Map _data = snapshot.data.data() as Map<String, dynamic>;
              debugPrint('fav: ${snapshot.data.data()}');
              _favProvider.allRecipes = _data as Map<String, dynamic>;
            }
            return const Home();
          },
        );
        return _userProvider.account != null ? streamBuilder : const Home();
      },
    );
  }
}
