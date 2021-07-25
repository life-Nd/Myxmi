import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/widgets/drinks_subcategories.dart';
import 'package:myxmi/widgets/food_subcategories.dart';
import 'package:myxmi/widgets/products_list.dart';
import 'package:myxmi/widgets/save_recipe.dart';
import 'package:myxmi/widgets/vape_subcategories.dart';
import 'package:easy_localization/easy_localization.dart';
import '../main.dart';
import '../providers/recipe.dart';
import 'recipe_image.dart';
import 'recipe_instructions.dart';

TextEditingController _titleCtrl = TextEditingController();
TextEditingController _durationCtrl = TextEditingController();
TextEditingController _portionsCtrl = TextEditingController();
final recipeProvider =
    ChangeNotifierProvider<RecipeProvider>((ref) => RecipeProvider());
List steps = [];

// ignore: must_be_immutable
class AddRecipe extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            _recipe.unhide();
            Navigator.of(context).pop();
          },
        ),
        title: Text('addRecipe'.tr()),
        actions: [
          SaveButton(),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
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
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                      width: 4,
                      color: _recipe.pageIndex == 1
                          ? Theme.of(context).appBarTheme.titleTextStyle.color
                          : Theme.of(context).scaffoldBackgroundColor,
                    )),
                  ),
                  child: Text('products'.tr().toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                      width: 4,
                      color: _recipe.pageIndex == 2
                          ? Theme.of(context).appBarTheme.titleTextStyle.color
                          : Theme.of(context).scaffoldBackgroundColor,
                    )),
                  ),
                  child: Text('instructions'.tr().toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 4,
                        color: _recipe.pageIndex == 3
                            ? Theme.of(context).appBarTheme.titleTextStyle.color
                            : Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                  child: Text('image'.tr().toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: PageController(
                initialPage: _recipe.pageIndex,
              ),
              onPageChanged: (index) {
                _recipe.changeView(index);
              },
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Column(
                      children: [
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
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${'difficulty'.tr()}: '),
                                Text(
                                  _recipe.getDifficulty(),
                                  style: const TextStyle(
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
                                debugPrint("VALUE: $value");
                              },
                              activeColor: _recipe.difficultyValue == 0.0
                                  ? Colors.green
                                  : _recipe.difficultyValue == 0.5
                                      ? Colors.yellow
                                      : _recipe.difficultyValue == 1.0
                                          ? Colors.red
                                          : Colors.grey,
                              divisions: 2,
                              label: _recipe.recipeModel.difficulty,
                              inactiveColor: Colors.grey,
                            ),
                          ],
                        ),
                        Text('duration'.tr()),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 60, right: 60),
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
                                    prefixIcon: const Icon(Icons.timer),
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
                        const SizedBox(
                          height: 4,
                        ),
                        Text('portions'.tr()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 100, right: 100),
                                child: TextField(
                                  controller: _portionsCtrl,
                                  keyboardType: TextInputType.number,
                                  onSubmitted: (submitted) {
                                    _recipe.changePortions(
                                        newPortions: _portionsCtrl.text);
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.local_pizza_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    hintText: 'portions'.tr(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text('category'.tr()),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  fillColor:
                                      _recipe.recipeModel.category == 'drink'
                                          ? Colors.green
                                          : Theme.of(context).cardColor,
                                  onPressed: () {
                                    _recipe.changeCategory(
                                        newCategory: 'drink');
                                  },
                                  child: Text('drink'.tr()),
                                ),
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  fillColor:
                                      _recipe.recipeModel.category == 'food'
                                          ? Colors.green
                                          : Theme.of(context).cardColor,
                                  onPressed: () {
                                    _recipe.changeCategory(newCategory: 'food');
                                  },
                                  child: Text('foods'.tr()),
                                ),
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  fillColor:
                                      _recipe.recipeModel.category == 'vapes'
                                          ? Colors.green
                                          : Theme.of(context).cardColor,
                                  onPressed: () {
                                    _recipe.changeCategory(
                                        newCategory: 'vapes');
                                  },
                                  child: Text('vapes'.tr()),
                                ),
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  fillColor:
                                      _recipe.recipeModel.category == 'other'
                                          ? Colors.green
                                          : Theme.of(context).cardColor,
                                  onPressed: () {
                                    _recipe.changeCategory(
                                        newCategory: 'other');
                                  },
                                  child: Text('other'.tr()),
                                )
                              ]),
                        ),
                        subCategory(category: _recipe.recipeModel.category),
                      ],
                    ),
                  ),
                ),
                _ProductsView(),
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
      case 'foods':
        _subCategory = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('subCategory'.tr()),
            FoodSubCategories(),
          ],
        );
        return _subCategory;
      case 'drinks':
        _subCategory = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('subCategory'.tr()),
            DrinksSubCategories(),
          ],
        );
        return _subCategory;
      case 'vapes':
        _subCategory = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('subCategory'.tr()),
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

class _ProductsView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _user = useProvider(userProvider);
    final _recipe = useProvider(recipeProvider);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Container(
            alignment: Alignment.topRight,
            child: Card(
              color: Colors.grey.shade700,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8.0, right: 10, left: 10),
                child: Text(
                  '± ${_recipe.estimatedWeight.toStringAsFixed(3)} g',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
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
                .doc(_user.account.uid)
                .get(),
          ),
        ),
      ],
    );
  }
}
