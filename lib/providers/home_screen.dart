import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final homeScreenProvider = ChangeNotifierProvider<HomeScreenProvider>(
  (ref) => HomeScreenProvider(),
);

class HomeScreenProvider extends ChangeNotifier {
  bool showDownloadDialog = true;
  bool showCalendarBottom = false;
  TextEditingController searchCtrl = TextEditingController();
  bool? searchRecipesInDb = false;
  bool loading = false;
  int webIndex = -1;
  int bottomIndex = 0;

  void changeView({required int index}) {
    webIndex = index;
    bottomIndex = index;
  }

  void changeBottom({bool? show}) {
    showCalendarBottom = show!;
    notifyListeners();
  }

  void loadingEntry({required bool isLoading}) {
    loading = isLoading;
    notifyListeners();
  }

  void changeViewIndex({
    required int index,
    required String? uid,
  }) {
    changeView(index: index);
    searchCtrl.clear();
    searchRecipesInDb = false;
    if (webIndex == 2 || bottomIndex == 2) {
      streamRecipesWith(key: 'uid', value: uid);
    }
    notifyListeners();
  }

  String textToSearchWith() {
    final String _text = searchCtrl.text.trim().toLowerCase();
    return _text;
  }

  Query streamRecipesWith({required String key, required String? value}) {
    final _stream = FirebaseFirestore.instance
        .collection('Recipes')
        .where(key, isEqualTo: value);
    return _stream;
  }

  Query searchWithCtrl({required String searchKey}) {
    return streamRecipesWith(key: searchKey, value: textToSearchWith());
  }

  void search(BuildContext context) {
    if (searchCtrl.text.isNotEmpty) {
      if (webIndex == 1 || bottomIndex == 1) {
        searchRecipesInDb = true;
      } else {
        searchWithCtrl(searchKey: 'title');
      }
      notifyListeners();
    }
  }

  void doSearch({bool? value}) {
    searchRecipesInDb = value;
    notifyListeners();
  }
}
