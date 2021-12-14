import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipe.dart';

TextEditingController _searchRecipesCtrl = TextEditingController();

class RecipesSearchField extends StatelessWidget {
  const RecipesSearchField({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _recipesSearch = ref.watch(recipesSearchProvider);
        return TextField(
          controller: _searchRecipesCtrl,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            filled: true,
            hintText: 'searchRecipe'.tr(),
            prefixIcon: IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.red,
              ),
              onPressed: () {
                _searchRecipesCtrl.clear();
                _recipesSearch.cancelSearch();
                if (!kIsWeb) {
                  FocusScope.of(context).requestFocus(FocusNode());
                }
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          onChanged: (value) => _recipesSearch.searchTextChanged(value),
        );
      },
    );
  }
}

class RecipesSearchFieldProvider extends ChangeNotifier {
  bool isSearching = false;
  RecipeModel? selectedRecipe;
  late String searchText;
  List<RecipeModel> _recipes = [];

  List<RecipeModel?> recipes() {
    if (selectedRecipe?.title == null) {
      return _recipes;
    } else {
      return [selectedRecipe];
    }
  }

  List<RecipeModel> allRecipes(QuerySnapshot querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      return _recipes = querySnapshot.docs.map((QueryDocumentSnapshot data) {
        return RecipeModel.fromSnapshot(
          snapshot: data.data()! as Map<String, dynamic>,
          keyIndex: data.id,
        );
      }).toList();
    } else {
      return [];
    }
  }

  List<RecipeModel> suggestions() {
    return _recipes.where((recipe) {
      return searchText.isNotEmpty &&
          recipe.title!.contains(searchText.trim().toLowerCase());
    }).toList();
  }

  void search() {
    isSearching = true;
    _searchRecipesCtrl.text = selectedRecipe!.title!;
    notifyListeners();
  }

  void searchTextChanged(String ctrl) {
    searchText = ctrl;
    isSearching = true;
    notifyListeners();
  }

  void cancelSearch() {
    isSearching = false;
    selectedRecipe = null;
    notifyListeners();
  }

  void selectRecipe(RecipeModel product) {
    selectedRecipe = product;
    _searchRecipesCtrl.text = selectedRecipe!.title!;
    isSearching = false;
    notifyListeners();
  }
}

final recipesSearchProvider =
    ChangeNotifierProvider<RecipesSearchFieldProvider>(
  (ref) => RecipesSearchFieldProvider(),
);
