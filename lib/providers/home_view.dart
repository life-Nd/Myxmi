import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeViewProvider extends ChangeNotifier {
  bool showDownloadDialog = true;
  int view = 0;
  TextEditingController searchCtrl = TextEditingController();
  bool searchRecipesInDb = false;
  bool loading = false;

  void loadingEntry({@required bool isLoading}) {
    loading = isLoading;
    notifyListeners();
  }

  void changeViewIndex({@required int index, @required String uid}) {
    view = index;
    searchCtrl.clear();
    searchRecipesInDb = false;
    switch (view) {
      case 1:
        streamRecipesWith(key: 'uid', value: uid);
    }
    notifyListeners();
  }

  String textToSearchWith() {
    final String _text = searchCtrl.text.toString().trim().toLowerCase();
    return _text;
  }

  Query streamRecipesWith({@required String key, @required String value}) {
    final _stream = FirebaseFirestore.instance
        .collection('Recipes')
        .where(key, isEqualTo: value);
    return _stream;
  }

  Query searchWithCtrl({@required String searchKey}) {
    return streamRecipesWith(key: searchKey, value: textToSearchWith());
  }

  void search() {
    if (searchCtrl.text.isNotEmpty) {
      if (view == 0) {
        searchRecipesInDb = true;
      } else {
        searchWithCtrl(searchKey: 'title');
      }
      notifyListeners();
    }
  }

  void doSearch({bool value}) {
    searchRecipesInDb = value;
    notifyListeners();
  }
}
