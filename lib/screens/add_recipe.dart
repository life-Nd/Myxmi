import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/widgets/drinks_subcategories.dart';
import 'package:myxmi/widgets/food_subcategories.dart';
import 'package:myxmi/widgets/save_recipe.dart';
import 'package:myxmi/widgets/vape_subcategories.dart';
import '../main.dart';
import '../providers/recipe.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/products_list.dart';
import 'add_product.dart';
import 'recipe_instructions.dart';
import 'recipe_image.dart';

TextEditingController _titleCtrl = TextEditingController();
TextEditingController _durationCtrl = TextEditingController();

final recipeProvider =
    ChangeNotifierProvider<RecipeProvider>((ref) => RecipeProvider());
List steps = [];

// ignore: must_be_immutable
class AddRecipe extends HookWidget {
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
    final _user = useProvider(userProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            _recipe.unhide();
            Navigator.of(context).pop();
          },
        ),
        title: Text('${'addRecipe'.tr()}'),
        actions: [
          SaveButton(),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 4,
                      color: _recipe.pageIndex == 0
                          ? Theme.of(context).appBarTheme.titleTextStyle.color
                          : Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
                child: Text('details'.tr().toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                    width: 4,
                    color: _recipe.pageIndex == 1
                        ? Theme.of(context).appBarTheme.titleTextStyle.color
                        : Theme.of(context).scaffoldBackgroundColor,
                  )),
                ),
                child: Text('instructions'.tr().toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 4,
                      color: _recipe.pageIndex == 2
                          ? Theme.of(context).appBarTheme.titleTextStyle.color
                          : Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
                child: Text('image'.tr().toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: PageController(
                initialPage: _recipe.pageIndex,
                keepPage: true,
              ),
              onPageChanged: (index) {
                _recipe.changeView(index);
              },
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                alignment: Alignment.topRight,
                                child: Card(
                                  color: Colors.grey.shade700,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0,
                                        bottom: 8.0,
                                        right: 10,
                                        left: 10),
                                    child: Text(
                                      '± ${_recipe.estimatedWeight.toStringAsFixed(3)} g',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 2, right: 40, left: 40),
                              child: TextField(
                                controller: _titleCtrl,
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  hintText: 'recipeName'.tr(),
                                ),
                                onSubmitted: (submitted) {
                                  _recipe.changeTitle(newName: _titleCtrl.text);
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${'difficulty'.tr()}: '),
                                  Text(
                                    _recipe.getDifficulty(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  )
                                ],
                              ),
                              Slider(
                                value: _recipe.difficultyValue,
                                onChanged: (value) {
                                  _recipe.changeDifficulty(
                                      newDifficultyValue: value);
                                  print("VALUE: $value");
                                },
                                activeColor: _recipe.difficultyValue == 0.0
                                    ? Colors.green
                                    : _recipe.difficultyValue == 0.5
                                        ? Colors.yellow
                                        : _recipe.difficultyValue == 1.0
                                            ? Colors.red
                                            : Colors.grey,
                                max: 1.0,
                                min: 0.0,
                                divisions: 2,
                                label: _recipe.details.difficulty,
                                inactiveColor: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        Text('duration'.tr()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 80, right: 80),
                                child: TextField(
                                  controller: _durationCtrl,
                                  keyboardType: TextInputType.number,
                                  onSubmitted: (submitted) {
                                    _recipe.changeDuration(
                                        newDuration: _durationCtrl.text);
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.timer),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    hintText: 'time'.tr(),
                                    suffixText: 'min',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text('${'category'.tr()}'),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  fillColor: _recipe.details.category == 'drink'
                                      ? Colors.green
                                      : Theme.of(context).cardColor,
                                  onPressed: () {
                                    _recipe.changeCategory(
                                        newCategory: 'drink');
                                  },
                                  child: Text('${'drink'.tr()}'),
                                ),
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  fillColor: _recipe.details.category == 'food'
                                      ? Colors.green
                                      : Theme.of(context).cardColor,
                                  onPressed: () {
                                    _recipe.changeCategory(newCategory: 'food');
                                  },
                                  child: Text('food'.tr()),
                                ),
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  fillColor: _recipe.details.category == 'vape'
                                      ? Colors.green
                                      : Theme.of(context).cardColor,
                                  onPressed: () {
                                    _recipe.changeCategory(newCategory: 'vape');
                                  },
                                  child: Text('${'vape'.tr()}'),
                                ),
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  fillColor: _recipe.details.category == 'other'
                                      ? Colors.green
                                      : Theme.of(context).cardColor,
                                  onPressed: () {
                                    _recipe.changeCategory(
                                        newCategory: 'other');
                                  },
                                  child: Text('${'other'.tr()}'),
                                )
                              ]),
                        ),
                        subCategory(category: _recipe.details.category),
                        ListTile(
                          title: Text(
                            'products'.tr(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => NewProduct(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: ProductsList(
                            uid: _user.account.uid,
                            type: 'AddRecipe',
                            componentsFuture: FirebaseFirestore.instance
                                .collection('Products')
                                .doc('${_user.account.uid}')
                                .get(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                RecipeInstructions(),
                RecipeImage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget subCategory({String category}) {
    Widget _subCategory;
    switch (category) {
      case ('food'):
        _subCategory = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${'subCategory'.tr()}'),
            FoodSubCategories(),
          ],
        );
        return _subCategory;
      case ('drink'):
        _subCategory = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${'subCategory'.tr()}'),
            DrinksSubCategories(),
          ],
        );
        return _subCategory;
      case ('vape'):
        _subCategory = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${'subCategory'.tr()}'),
            VapeSubCategories(),
          ],
        );
        return _subCategory;
      default:
        _subCategory = Container();
        return _subCategory;
    }
  }
}
