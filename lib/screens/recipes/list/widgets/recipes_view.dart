import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/recipes/list/widgets/recipes_grid.dart';
import 'package:myxmi/screens/recipes/list/widgets/recipes_search_field.dart';
import 'package:myxmi/screens/recipes/list/widgets/suggestions.dart';

class RecipesView extends StatelessWidget {
  final QuerySnapshot? querySnapshot;
  final bool showAutoCompleteField;

  const RecipesView({
    Key? key,
    required this.querySnapshot,
    required this.showAutoCompleteField,
  }) : super(key: key);
  // List<RecipeModel> _recipes() {
  //   if (querySnapshot.docs.isNotEmpty) {
  //     return querySnapshot.docs.map((QueryDocumentSnapshot data) {
  //       return RecipeModel.fromSnapshot(
  //         snapshot: data.data() as Map<String, dynamic>,
  //         keyIndex: data.id,
  //       );
  //     }).toList();
  //   } else {
  //     return [];
  //   }
  // }

  // List<RecipeModel> _filterRecipes() {
  //   final List<RecipeModel> _filteredRecipes = [];
  //   final Iterable _filter = _recipes().asMap().entries.where((entry) {
  //     return entry.value.toMap().containsValue(
  //           _searchMyRecipesCtrl.text.trim().toLowerCase(),
  //         );
  //   },);
  //   final _filtered = Map.fromEntries(_filter as Iterable<MapEntry>);
  //   _filtered.forEach((key, value) {
  //     _filteredRecipes.add(value as RecipeModel);
  //   },);
  //   return _filteredRecipes;
  // }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, StateSetter stateSetter) {
        return Consumer(
          builder: (_, ref, child) {
            final _recipesSearch = ref.watch(recipesSearchProvider);
            _recipesSearch.allRecipes(querySnapshot!);
            return Column(
              children: [
                if (showAutoCompleteField)
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                            top: 4,
                            bottom: _recipesSearch.isSearching ? 1 : 8,
                          ),
                          child: const RecipesSearchField(),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 4),
                Expanded(
                  child: Stack(
                    children: [
                      RecipesGrid(recipes: _recipesSearch.recipes()),
                      if (_recipesSearch.isSearching)
                        const RecipesSuggestions(),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}


// TODO change this to use the paginate_firestore package
    //  in the future if the data is inefficiently read from firestore

  //   return Consumer(
  //     builder: (_, watch, child) {
  //       return PaginateFirestore(
  //         // orderBy is compulsory to enable pagination
  //         query: query.limit(10),

  //         //Change types accordingly
  //         itemBuilderType: PaginateBuilderType.gridView,
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           childAspectRatio: 0.6,
  //           crossAxisCount: kIsWeb && 100.w > 500 ? 4 : 2,
  //         ),
  //         padding: const EdgeInsets.all(1),
  //         // to fetch real-time data
  //         isLive: true,
  //         emptyDisplay: NoRecipes(),
  //         //item builder type is compulsory.
  //         itemBuilder: (index, context, DocumentSnapshot documentSnapshot) {
  //           final _data = documentSnapshot.data() as Map;
  //           return RecipeTile(
  //             index: index,
  //             recipes: _recipes(
  //               data: _data,
  //               recipeId: documentSnapshot.id,
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
