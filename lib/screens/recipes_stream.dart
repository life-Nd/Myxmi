import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:myxmi/screens/home.dart';
import 'package:flutter/foundation.dart';
import 'package:myxmi/widgets/recipes_grid.dart';

import '../widgets/auto_complete_recipes.dart';

TextEditingController _searchMyRecipesCtrl = TextEditingController();

class RecipesStream extends StatefulWidget {
  final Stream<QuerySnapshot> path;
  final double height;
  final bool autoCompleteField;
  const RecipesStream(
      {Key key,
      @required this.path,
      @required this.height,
      @required this.autoCompleteField})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecipesState();
}

class _RecipesState extends State<RecipesStream> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<RecipeModel> _recipes({QuerySnapshot querySnapshot}) {
      return querySnapshot.docs.map((QueryDocumentSnapshot data) {
        return RecipeModel.fromSnapshot(
          snapshot: data.data() as Map<String, dynamic>,
          keyIndex: data.id,
        );
      }).toList();
    }

    debugPrint('building recipe');
    return Consumer(
      builder: (_, watch, __) {
        final _view = watch(viewProvider);
        final _recipe = watch(recipeProvider);
        return StreamBuilder<QuerySnapshot>(
          stream: widget.path,
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text(
                'somethingWentWrong'.tr(),
                style: const TextStyle(color: Colors.white),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              debugPrint('----<<<<<Loading ${_view.view} from db....>>>>>----');
              return Center(
                child: Text(
                  "${'loading'.tr()}...",
                ),
              );
            }
            if (snapshot.data != null) {
              _recipe.recipesList = _recipes(querySnapshot: snapshot.data);
              return MyRecipesView(
                showAutoCompleteField: widget.autoCompleteField,
                myRecipes: _recipes(querySnapshot: snapshot.data),
                height: widget.height,
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

class MyRecipesView extends StatefulWidget {
  final List<RecipeModel> myRecipes;
  final bool showAutoCompleteField;
  final double height;

  const MyRecipesView(
      {Key key,
      @required this.myRecipes,
      @required this.height,
      @required this.showAutoCompleteField})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _MyRecipesViewState();
}

class _MyRecipesViewState extends State<MyRecipesView> {
  final List<RecipeModel> _filteredRecipes = [];
  List<RecipeModel> _filterRecipes() {
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
  void initState() {
    _searchMyRecipesCtrl = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return StatefulBuilder(
      builder: (context, StateSetter stateSetter) {
        return SingleChildScrollView(
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
                            _filteredRecipes.clear();
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
                          _filteredRecipes.clear();
                          _searchMyRecipesCtrl.clear();
                          stateSetter(() {});
                        },
                      ),
                    ],
                  ),
                ),
              RecipesGrid(
                recipes: _searchMyRecipesCtrl.text.isEmpty
                    ? widget.myRecipes
                    : _filterRecipes(),
                height: _size.height / 1.2,
              ),
            ],
          ),
        );
      },
    );
  }
}
