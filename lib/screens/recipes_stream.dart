import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/foundation.dart';
import 'package:myxmi/widgets/recipes_grid.dart';
import '../widgets/auto_complete_recipes.dart';

TextEditingController _searchMyRecipesCtrl = TextEditingController();

class RecipesStream extends StatelessWidget {
  final Stream<QuerySnapshot> path;

  final bool autoCompleteField;
  const RecipesStream(
      {Key key, @required this.path, @required this.autoCompleteField})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<RecipeModel> _recipes({QuerySnapshot querySnapshot}) {
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.map((QueryDocumentSnapshot data) {
          return RecipeModel.fromSnapshot(
            snapshot: data.data() as Map<String, dynamic>,
            keyIndex: data.id,
          );
        }).toList();
      } else {
        return [];
      }
    }

    final double _bottomPadding = MediaQuery.of(context).padding.bottom;
    return Consumer(
      builder: (_, watch, __) {
        final _recipe = watch(recipeProvider);
        return StreamBuilder<QuerySnapshot>(
          stream: path,
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text(
                'somethingWentWrong'.tr(),
                style: const TextStyle(color: Colors.white),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text(
                  "${'loading'.tr()}...",
                ),
              );
            }
            if (snapshot.data != null) {
              _recipe.recipesList = _recipes(querySnapshot: snapshot.data);
              return Padding(
                padding: EdgeInsets.only(bottom: _bottomPadding),
                child: RecipesView(
                  showAutoCompleteField: autoCompleteField,
                  myRecipes: _recipes(querySnapshot: snapshot.data),
                  // height: widget.height,
                ),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.only(bottom: 20.0, left: 40, right: 40.0),
                    child: LinearProgressIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                  ),
                  Text(
                    'noRecipes'.tr(),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }
}

class RecipesView extends StatefulWidget {
  final List<RecipeModel> myRecipes;
  final bool showAutoCompleteField;

  const RecipesView(
      {Key key, @required this.myRecipes, @required this.showAutoCompleteField})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {
  @override
  void initState() {
    _searchMyRecipesCtrl = TextEditingController();
    super.initState();
  }

  List<RecipeModel> _filterRecipes() {
    final List<RecipeModel> _filteredRecipes = [];
    final Iterable _filter = widget.myRecipes.asMap().entries.where((entry) {
      return entry.value.toMap().containsValue(
            _searchMyRecipesCtrl.text.trim().toLowerCase(),
          );
    });
    final _filtered = Map.fromEntries(_filter as Iterable<MapEntry>);
    _filtered.forEach((key, value) {
      _filteredRecipes.add(value as RecipeModel);
    });
    return _filteredRecipes;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, StateSetter stateSetter) {
        return RefreshIndicator(
          onRefresh: () async {
            _filterRecipes().clear();
            _searchMyRecipesCtrl.clear();
            stateSetter(() {});
          },
          child: Column(
            children: [
              if (widget.showAutoCompleteField)
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: AutoCompleteRecipes(
                          suggestions: widget.myRecipes,
                          controller: _searchMyRecipesCtrl,
                          onSubmit: () {
                            _filterRecipes().clear();
                            stateSetter(() {});
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _filterRecipes().clear();
                          _searchMyRecipesCtrl.clear();
                          stateSetter(() {});
                        },
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: RecipesGrid(
                  recipes: _searchMyRecipesCtrl.text.isEmpty
                      ? widget.myRecipes
                      : _filterRecipes(),
                  height: 80.h,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
