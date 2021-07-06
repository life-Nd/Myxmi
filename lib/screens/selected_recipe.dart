import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/app.dart';
import 'package:myxmi/models/instructions.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myxmi/widgets/add_reviews.dart';
import '../main.dart';
import 'home.dart';
import 'dart:io';

class SelectedRecipe extends HookWidget {
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
    final _user = useProvider(userProvider);
    final _view = useProvider(viewProvider);
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('${_recipe.details.title}'),
      ),
      body: Container(
        height: _size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).cardColor,
              Theme.of(context).cardColor,
              Theme.of(context).cardColor,
              _recipe.details.difficulty == 'easy'
                  ? Colors.yellow.shade700
                  : _recipe.details.difficulty == 'medium'
                      ? Colors.orange.shade900
                      : _recipe.details.difficulty == 'hard'
                          ? Colors.red.shade700
                          : Colors.grey.shade700,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: _size.width / 1,
                    height: _size.height / 2.7,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Hero(
                        tag: '${_recipe.details.recipeId}',
                        child: _recipe.image,
                      ),
                    ),
                  ),
                  AddToFavoriteButton(
                    details: _recipe.details,
                  ),
                ],
              ),
            ),
            FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Instructions')
                    .doc('${_recipe.details.recipeId}')
                    .get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  final InstructionsModel _instructions = InstructionsModel();
                  if (snapshot.hasData && snapshot?.data?.data() != null)
                    _instructions.fromSnapshot(snapshot: snapshot.data.data());
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 5),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 4,
                                    color: _recipe.pageIndex == 0
                                        ? Theme.of(context)
                                            .appBarTheme
                                            .titleTextStyle
                                            .color
                                        : Colors.transparent),
                              ),
                            ),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: 'ingredients'.tr().toUpperCase(),
                                  ),
                                  WidgetSpan(
                                    child: Transform.translate(
                                      offset: const Offset(0.0, -9.0),
                                      child: Text(
                                        _instructions?.ingredients != null
                                            ? '${_instructions?.ingredients?.keys?.length}'
                                            : '0',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 5),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                width: 4,
                                color: _recipe.pageIndex == 1
                                    ? Theme.of(context)
                                        .appBarTheme
                                        .titleTextStyle
                                        .color
                                    : Colors.transparent,
                              )),
                            ),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: 'steps'.tr().toUpperCase(),
                                  ),
                                  WidgetSpan(
                                    child: Transform.translate(
                                      offset: const Offset(0.0, -9.0),
                                      child: Text(
                                        _instructions?.steps != null
                                            ? '${_instructions?.steps?.length}'
                                            : '0',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 5),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 4,
                                  color: _recipe.pageIndex == 2
                                      ? Theme.of(context)
                                          .appBarTheme
                                          .titleTextStyle
                                          .color
                                      : Colors.transparent,
                                ),
                              ),
                            ),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: 'reviews'.tr().toUpperCase(),
                                  ),
                                  WidgetSpan(
                                    child: Transform.translate(
                                      offset: const Offset(0.0, -9.0),
                                      child: Text(
                                        '00',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: _size.height / 1.9,
                        child: PageView(
                          controller: PageController(
                            initialPage: _recipe.pageIndex,
                            keepPage: true,
                          ),
                          onPageChanged: (index) {
                            _recipe.changeView(index);
                          },
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _instructions.ingredients != null
                                    ? _IngredientsListView(
                                        ingredients: _instructions.ingredients,
                                      )
                                    : _NoInstructions('noIngredients'),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _instructions.steps != null
                                    ? _StepsListView(
                                        steps: _instructions.steps,
                                      )
                                    : _NoInstructions('noSteps')
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _instructions.reviews == null
                                    ? Container(
                                        height: _size.height / 2,
                                        child: Stack(
                                          children: [
                                           
                                            StreamBuilder<DocumentSnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('Reviews')
                                                  .doc(
                                                      '${_recipe.details.recipeId}')
                                                  .snapshots(),
                                              builder: (context,
                                                  AsyncSnapshot<
                                                          DocumentSnapshot>
                                                      snapshot) {
                                                if (snapshot.hasData &&
                                                    snapshot.data.data() !=
                                                        null) {
                                                  print(
                                                      'snapshot: ${snapshot.data.data()}');
                                                  Map _data =
                                                      snapshot.data.data();
                                                  List _keys = _data?.keys !=
                                                          null
                                                      ? _data?.keys?.toList()
                                                      : [];
                                                  return Container(
                                                    child: ListView.builder(
                                                      itemCount: _keys.length,
                                                      itemBuilder:
                                                          (_, int index) {
                                                        return Card(
                                                          child: ListTile(
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    1),
                                                            leading:
                                                                CircleAvatar(
                                                              child: _data[_keys[index]]
                                                                              [
                                                                              'photo_url'] !=
                                                                          null &&
                                                                      _data[_keys[index]]
                                                                              [
                                                                              'photo_url'] !=
                                                                          'null'
                                                                  ? Image.network(
                                                                      '${_data[_keys[index]]['photo_url']}')
                                                                  : Icon(Icons
                                                                      .person),
                                                            ),
                                                            title: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                      '${_data[_keys[index]]['name']}'),
                                                                ),
                                                                RatingStars(
                                                                  stars: _data[
                                                                          _keys[
                                                                              index]]
                                                                      ['stars'],
                                                                ),
                                                              ],
                                                            ),
                                                            subtitle: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    '${_data[_keys[index]]['message']}'),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                        '${DateTime.fromMillisecondsSinceEpoch(int.parse(_keys[index]))}'),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
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
                                              padding: EdgeInsets.all(7),
                                              child: FloatingActionButton(
                                                onPressed: _user.account.uid !=
                                                        null
                                                    ? () {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                AddReviews(),
                                                          ),
                                                        );
                                                      }
                                                    : () {
                                                        _view.view = 2;
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                Home(),
                                                          ),
                                                        );
                                                      },
                                                child: Icon(Icons.add),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : _NoInstructions('noReviews')
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class RatingStars extends StatelessWidget {
  const RatingStars({@required this.stars});
  final String stars;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: double.parse(stars),
      minRating: 1,
      ignoreGestures: true,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 22,
      itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }
}

class AddToFavoriteButton extends HookWidget {
  final RecipesModel details;

  AddToFavoriteButton({@required this.details});
  @override
  Widget build(BuildContext context) {
    final _user = useProvider(userProvider);
    final _fav = useProvider(favProvider);
    final _view = useProvider(viewProvider);
    final _change = useState<bool>(false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _user.account?.uid == null
                ? IconButton(
                    icon: Icon(
                      Icons.favorite_border,
                    ),
                    onPressed: () {
                      _view.view = 2;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => Home(),
                        ),
                      );
                    },
                  )
                : !_fav.favorites.keys.contains(details.recipeId)
                    ? IconButton(
                        icon: Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                          size: 40,
                        ),
                        onPressed: () {
                          print('DETAILS ${details.recipeId}');
                          Map<String, dynamic> _data = {};
                          print('DETAILS: ${details.recipeId}');
                          _data[details.recipeId] = {
                            'title': '${details.title}',
                            'image_url': '${details.imageUrl}',
                            'joined': 'false',
                            'steps_count': '${details.stepsCount}',
                            'ingredients_count': '${details.ingredientsCount}'
                          };
                          FirebaseFirestore.instance
                              .collection('Favorites')
                              .doc('${_user.account.uid}')
                              .set(_data, SetOptions(merge: true));
                          _fav.addFavorites(newFavorite: _data);
                          _change.value = !_change.value;
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.favorite_outlined,
                          size: 40,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('Favorites')
                              .doc('${_user.account.uid}')
                              .update(
                                  {'${details.recipeId}': FieldValue.delete()});
                          _fav.removeFavorites(newFavorite: details.recipeId);
                          _change.value = !_change.value;
                        },
                      ),
            IconButton(
              icon: Icon(
                Platform.isIOS
                    ? Icons.ios_share_outlined
                    : Icons.share_outlined,
              ),
              onPressed: () {},
            ),
          ],
        ),
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RatingStars(
              stars: details.stars != null ? '${details.stars}' : '0.0',
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AddReviews(),
              ),
            );
          },
        ),
      ],
    );
  }
}

List _checkedIngredients = [];

class _IngredientsListView extends HookWidget {
  final Map ingredients;
  _IngredientsListView({this.ingredients});
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    List _keys = ingredients.keys.toList();
    final _change = useState<bool>(false);
    return Container(
      height: _size.height / 2.1,
      width: _size.width / 1,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ListView.builder(
            itemCount: _keys.length,
            itemBuilder: (_, int index) {
              final _checked = _checkedIngredients.contains(_keys[index]);
              return ListTile(
                onTap: () {
                  _checked
                      ? _checkedIngredients.remove(_keys[index])
                      : _checkedIngredients.add(_keys[index]);
                  _change.value = !_change.value;
                },
                leading: IconButton(
                  icon: _checked
                      ? Icon(Icons.check_circle_outline)
                      : Icon(Icons.radio_button_unchecked),
                  onPressed: () {
                    !_checked
                        ? _checkedIngredients.add(_keys[index])
                        : _checkedIngredients.remove(_keys[index]);
                    _change.value = !_change.value;
                  },
                ),
                title: Row(
                  children: [
                    Text(
                      '${_keys[index]}: ',
                    ),
                    Text(
                      '${ingredients[_keys[index]]}',
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

List _checkedSteps = [];

class _StepsListView extends HookWidget {
  final List steps;
  _StepsListView({this.steps});
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final _change = useState<bool>(false);
    return Container(
      height: _size.height / 2.1,
      width: _size.width / 1,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ListView.builder(
            itemCount: steps.length,
            itemBuilder: (_, int index) {
              final _checked = _checkedSteps?.contains(steps[index]);
              return ListTile(
                onTap: () {
                  _checked
                      ? _checkedSteps.remove(steps[index])
                      : _checkedSteps.add(steps[index]);
                  _change.value = !_change.value;
                },
                leading: IconButton(
                  icon: _checked
                      ? Icon(Icons.check_circle_outline)
                      : Icon(Icons.radio_button_unchecked),
                  onPressed: () {
                    !_checked
                        ? _checkedSteps.add(steps[index])
                        : _checkedSteps.remove(steps[index]);
                    _change.value = !_change.value;
                  },
                ),
                title: Text(
                  '${steps[index]}',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NoInstructions extends HookWidget {
  final String text;
  _NoInstructions(this.text);
  Widget build(BuildContext context) {
    return Text(
      text.tr(),
    );
  }
}
