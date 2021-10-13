import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/instructions.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:myxmi/screens/home.dart';
import 'package:myxmi/screens/selected_recipe.dart';
import 'package:myxmi/widgets/add_reviews.dart';
import '../main.dart';
import 'ingredients_listview.dart';
import 'no_instructions.dart';
import 'rating_stars.dart';
import 'steps_listview.dart';

class RecipeDetails extends StatelessWidget {
  final InstructionsModel instructions;
  const RecipeDetails({Key key, this.instructions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final _user = watch(userProvider);
      final _selectedView = watch(selectedRecipeView);
      final _recipe = watch(recipeProvider);
      final _view = watch(homeViewProvider);
      return ExpandablePageView(
        controller: _selectedView.pageController,
        onPageChanged: (index) {
          _selectedView.changePageController(index);
        },
        children: [
          if (instructions.ingredients != null)
            IngredientsInRecipeListView(ingredients: instructions.ingredients)
            
          else
            const NoInstructions('noIngredients'),
          if (instructions.steps != null)
            StepsListView(
              steps: instructions.steps,

            )
          else
            const NoInstructions('noSteps'),
          if (instructions.reviews == null)
             Stack(
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Reviews')
                      .doc(_recipe.recipeModel.recipeId)
                      .snapshots(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data.data() != null) {
                      debugPrint('snapshot: ${snapshot.data.data()}');
                      final Map _data =
                          snapshot.data.data() as Map<String, dynamic>;
                        final List _keys =
                          _data?.keys != null ? _data?.keys?.toList() : [];
                      return ListView.builder(
                        itemCount: _keys.length,
                        itemBuilder: (_, int index) {
                          return Card(
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(1),
                              leading: CircleAvatar(
                                child: _data[_keys[index]]['photo_url'] !=
                                            null &&
                                          _data[_keys[index]]['photo_url'] !=
                                            'null'
                                    ? Image.network(
                                        '${_data[_keys[index]]['photo_url']}')
                                    : const Icon(Icons.person),
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child:
                                        Text('${_data[_keys[index]]['name']}'),
                                  ),
                                  RatingStars(
                                      stars: '${_data[_keys[index]]['stars']}',
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text('${_data[_keys[index]]['message']}'),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                          '${DateTime.fromMillisecondsSinceEpoch(int.parse('${_keys[index]}'))}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Center(
                      child: Text(
                        'noReviews'.tr(),
                      ),
                    );
                  },
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(7),
                  child: FloatingActionButton(
                    onPressed: _user?.account?.uid != null
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AddReviews(),
                              ),
                            );
                          }
                        : () {
                            _view.view = 4;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => Home(
                                  uid: _user?.account?.uid,
                                  photoUrl: _user?.account?.photoURL,
                                ),
                              ),
                            );
                          },
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
              )

          else
            const NoInstructions('noReviews'),
        ],
      );
    });
  }
}
