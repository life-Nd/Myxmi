import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final homeScreenProvider = ChangeNotifierProvider<HomeScreenProvider>(
  (ref) => HomeScreenProvider(),
);

class HomeScreenProvider extends ChangeNotifier {
  bool showDownloadDialog = true;
  bool showCalendarBottom = false;
  int? _view;

  TextEditingController searchCtrl = TextEditingController();
  bool? searchRecipesInDb = false;
  bool loading = false;
  int? get view {
    if (_view == null) {
      return _view = kIsWeb ? 9 : 0;
    } else {
      return _view;
    }
  }

  // ignore: use_setters_to_change_properties
  void changeView({required int index}) {
    _view = index;
  }

  void changeBottom({bool? show}) {
    showCalendarBottom = show!;
    notifyListeners();
  }

  void loadingEntry({required bool isLoading}) {
    loading = isLoading;
    notifyListeners();
  }

  void changeViewIndex({required int index, required String? uid}) {
    changeView(index: index);
    searchCtrl.clear();
    searchRecipesInDb = false;
    switch (view) {
      case 2:
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

  void search() {
    if (searchCtrl.text.isNotEmpty) {
      if (view == 1) {
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
