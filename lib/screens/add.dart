import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../provider/image.dart';
import '../widgets/added_images.dart';
import '../provider/recipe.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/components_list.dart';
import '../widgets/save_recipe.dart';
import '../widgets/change_value_type.dart';

TextEditingController _recipeNameCtrl = TextEditingController();

final recipeProvider =
    ChangeNotifierProvider<RecipeProvider>((ref) => RecipeProvider());

class AddRecipe extends HookWidget {
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
    final _image = useProvider(imageProvider);
    return Scaffold(
      floatingActionButton: SaveButton(),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            _recipe.unhide();
            Navigator.of(context).pop();
          },
        ),
        title: Text('${'add'.tr()}'),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  alignment: Alignment.topRight,
                  child: Card(
                    color: Colors.greenAccent.shade700,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, right: 10, left: 10),
                      child: Text(
                        '${_recipe.estimatedWeight.toStringAsFixed(3)} g',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 2, right: 40, left: 40),
                child: TextField(
                  controller: _recipeNameCtrl,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: 'Recipe name',
                  ),
                  onChanged: (value) {
                    _recipe.changeName(newName: _recipeNameCtrl.text);
                  },
                  onSubmitted: (submitted) {
                    _recipe.changeName(newName: _recipeNameCtrl.text);
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              children: [
                Column(
                  children: [
                    Text('${'difficulty'.tr()}'),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RawMaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            fillColor: _recipe.difficulty == 'Easy'
                                ? Colors.green
                                : Theme.of(context).cardColor,
                            onPressed: () {
                              _recipe.changeDifficulty(newDifficulty: 'Easy');
                            },
                            child: Text('${'easy'.tr()}'),
                          ),
                          RawMaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            fillColor: _recipe.difficulty == 'Medium'
                                ? Colors.green
                                : Theme.of(context).cardColor,
                            onPressed: () {
                              _recipe.changeDifficulty(newDifficulty: 'Medium');
                            },
                            child: Text('${'medium'.tr()}'),
                          ),
                          RawMaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            fillColor: _recipe.difficulty == 'Hard'
                                ? Colors.green
                                : Theme.of(context).cardColor,
                            onPressed: () {
                              _recipe.changeDifficulty(newDifficulty: 'Hard');
                            },
                            child: Text('${'hard'.tr()}'),
                          )
                        ]),
                    Text('${'category'.tr()}'),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RawMaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            fillColor: _recipe.category == 'Drinks'
                                ? Colors.green
                                : Theme.of(context).cardColor,
                            onPressed: () {
                              _recipe.changeCategory(newCategory: 'Drinks');
                            },
                            child: Text('${'drinks'.tr()}'),
                          ),
                          RawMaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            fillColor: _recipe.category == 'Food'
                                ? Colors.green
                                : Theme.of(context).cardColor,
                            onPressed: () {
                              _recipe.changeCategory(newCategory: 'Food');
                            },
                            child: Text('${'food'.tr()}'),
                          ),
                          RawMaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            fillColor: _recipe.category == 'E-Liquid'
                                ? Colors.green
                                : Theme.of(context).cardColor,
                            onPressed: () {
                              _recipe.changeCategory(newCategory: 'E-Liquid');
                            },
                            child: Text('${'eliquid'.tr()}'),
                          ),
                          RawMaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            fillColor: _recipe.category == 'Other'
                                ? Colors.green
                                : Theme.of(context).cardColor,
                            onPressed: () {
                              _recipe.changeCategory(newCategory: 'Other');
                            },
                            child: Text('${'other'.tr()}'),
                          )
                        ]),
                    Text('${'subCategory'.tr()}'),
                    _recipe.category != null
                        ? _recipe.category == 'Food'
                            ? FoodSubCategories()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                    RawMaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      fillColor: _recipe.category == 'Public'
                                          ? Colors.green
                                          : Theme.of(context).cardColor,
                                      onPressed: () {
                                        _recipe.changeCategory(
                                            newCategory: 'Public');
                                      },
                                      child: Text('${'public'.tr()}'),
                                    ),
                                    RawMaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      fillColor: _recipe.category == 'Private'
                                          ? Colors.green
                                          : Theme.of(context).cardColor,
                                      onPressed: () {
                                        _recipe.changeCategory(
                                            newCategory: 'Private');
                                      },
                                      child: Text('${'private'.tr()}'),
                                    )
                                  ])
                        : Container(),

                    // Text('${'accessibility'.tr()}'),
                    // Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    //   RawMaterialButton(
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(20)),
                    //     fillColor: _recipe.access == 'Public'
                    //         ? Colors.green
                    //         : Theme.of(context).cardColor,
                    //     onPressed: () {
                    //       _recipe.changeAccess(newAccess: 'Public');
                    //     },
                    //     child: Text('${'public'.tr()}'),
                    //   ),
                    //   RawMaterialButton(
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(20)),
                    //     fillColor: _recipe.access == 'Private'
                    //         ? Colors.green
                    //         : Theme.of(context).cardColor,
                    //     onPressed: () {
                    //       _recipe.changeAccess(newAccess: 'Private');
                    //     },
                    //     child: Text('${'private'.tr()}'),
                    //   )
                    // ]),

                    ListTile(
                      title: Text(
                        'ingredients'.tr(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => changeValueType(context: context),
                      ),
                    ),
                    ComponentsList(),
                    Text('1-3')
                  ],
                ),
                Column(
                  children: [
                    ListTile(
                        title: Text(
                          'images'.tr(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.add_a_photo,
                          ),
                          onPressed: () =>
                              _image.chooseImageSource(context: context),
                        )),
                    Spacer(),
                    AddedImages(),
                    Text('2-3')
                  ],
                ),
                Column(
                  children: [
                    ListTile(
                        title: Text(
                          'images'.tr(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.add_a_photo,
                          ),
                          onPressed: () =>
                              _image.chooseImageSource(context: context),
                        )),
                    AddedImages(),
                    Spacer(),
                    Text('3-3')
                  ],
                ),
               
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FoodSubCategories extends HookWidget {
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RawMaterialButton(
            child: Text('appetizer'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'Appetizer');
            },
            fillColor: _recipe.subCategory == 'Appetizer'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            child: Text('salad'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'Salad');
            },
            fillColor: _recipe.subCategory == 'Salad'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            child: Text('vegetables'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'Vegetables');
            },
            fillColor: _recipe.subCategory == 'Vegetables'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            child: Text('mainDish'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'Main Dish');
            },
            fillColor: _recipe.subCategory == 'Main Dish'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            child: Text('dessert'.tr()),
            fillColor: _recipe.subCategory == 'Dessert'
                ? Colors.green
                : Theme.of(context).cardColor,
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'Dessert');
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            child: Text('others'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'Other');
            },
            fillColor: _recipe.subCategory == 'Other'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          )
        ],
      ),
    );
  }
}
