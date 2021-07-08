import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/instructions.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myxmi/widgets/add_favorite.dart';
import 'package:myxmi/widgets/add_reviews.dart';
import '../main.dart';
import 'home.dart';

class SelectedRecipe extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
    final _user = useProvider(userProvider);
    final _view = useProvider(viewProvider);
    final Size _size = MediaQuery.of(context).size;
    debugPrint('RECIPEID: ${_recipe.recipeModel.recipeId}');
    return Scaffold(
      appBar: AppBar(
        title: Text(_recipe.recipeModel.title),
      ),
      body: Container(
        height: _size.height,
        width: _size.width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).cardColor,
              Theme.of(context).cardColor,
              Theme.of(context).cardColor,
              if (_recipe.recipeModel.difficulty == 'easy')
                Colors.yellow.shade700
              else
                _recipe.recipeModel.difficulty == 'medium'
                    ? Colors.orange.shade900
                    : _recipe.recipeModel.difficulty == 'hard'
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
                  SizedBox(
                    width: _size.width / 1,
                    height: _size.height / 2.7,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: InteractiveViewer(child: _recipe.image),
                    ),
                  ),
                  AddToFavoriteButton(
                    recipe: _recipe.recipeModel,
                  ),
                ],
              ),
            ),
            FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Instructions')
                    .doc(_recipe.recipeModel.recipeId)
                    .get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  final InstructionsModel _instructions = InstructionsModel();
                  if (snapshot.hasData && snapshot?.data?.data() != null) {
                    _instructions.fromSnapshot(
                        snapshot: snapshot.data.data() as Map<String, dynamic>);
                  }
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
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
                                style: const TextStyle(
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
                                        style: const TextStyle(
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
                            padding: const EdgeInsets.only(
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
                                style: const TextStyle(
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
                                        style: const TextStyle(
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
                            padding: const EdgeInsets.only(
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
                                style: const TextStyle(
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
                                      child: const Text(
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
                      SizedBox(
                        height: _size.height / 1.9,
                        child: PageView(
                          controller: PageController(
                            initialPage: _recipe.pageIndex,
                          ),
                          onPageChanged: (index) {
                            _recipe.changeView(index);
                          },
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_instructions.ingredients != null)
                                  _IngredientsListView(
                                    ingredients: _instructions.ingredients,
                                  )
                                else
                                  const _NoInstructions('noIngredients'),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_instructions.steps != null)
                                  _StepsListView(
                                    steps: _instructions.steps,
                                  )
                                else
                                  const _NoInstructions('noSteps')
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_instructions.reviews == null)
                                  SizedBox(
                                    height: _size.height / 2,
                                    child: Stack(
                                      children: [
                                        StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('Reviews')
                                              .doc(_recipe.recipeModel.recipeId)
                                              .snapshots(),
                                          builder: (context,
                                              AsyncSnapshot<DocumentSnapshot>
                                                  snapshot) {
                                            if (snapshot.hasData &&
                                                snapshot.data.data() != null) {
                                              debugPrint(
                                                  'snapshot: ${snapshot.data.data()}');
                                              final Map _data =
                                                  snapshot.data.data()
                                                      as Map<String, dynamic>;
                                              final List _keys =
                                                  _data?.keys != null
                                                      ? _data?.keys?.toList()
                                                      : [];
                                              return ListView.builder(
                                                itemCount: _keys.length,
                                                itemBuilder: (_, int index) {
                                                  return Card(
                                                    child: ListTile(
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              1),
                                                      leading: CircleAvatar(
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
                                                            : const Icon(
                                                                Icons.person),
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
                                                            stars:
                                                                '${_data[_keys[index]]['stars']}',
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
                                            onPressed: _user?.account?.uid !=
                                                    null
                                                ? () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            AddReviews(),
                                                      ),
                                                    );
                                                  }
                                                : () {
                                                    _view.view = 2;
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (_) => Home(),
                                                      ),
                                                    );
                                                  },
                                            child: const Icon(Icons.add),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  const _NoInstructions('noReviews')
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
      allowHalfRating: true,
      itemSize: 22,
      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        debugPrint('$rating');
      },
    );
  }
}

List _checkedIngredients = [];

class _IngredientsListView extends HookWidget {
  final Map ingredients;
  const _IngredientsListView({this.ingredients});
  @override
  Widget build(BuildContext context) {
    final List _keys = ingredients.keys.toList();
    final Size _size = MediaQuery.of(context).size;
    final _change = useState<bool>(false);
    return SizedBox(
      height: _size.height / 2.1,
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
                      ? const Icon(Icons.check_circle_outline)
                      : const Icon(Icons.radio_button_unchecked),
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
  const _StepsListView({this.steps});
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final _change = useState<bool>(false);
    return SizedBox(
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
                      ? const Icon(Icons.check_circle_outline)
                      : const Icon(Icons.radio_button_unchecked),
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
  const _NoInstructions(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr(),
    );
  }
}
