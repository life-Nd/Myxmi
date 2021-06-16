import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/widgets/drinks_subcategories.dart';
import 'package:myxmi/widgets/food_subcategories.dart';
import '../providers/image.dart';
import '../widgets/added_images.dart';
import '../providers/recipe.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/components_list.dart';
import '../widgets/save_recipe.dart';
import '../widgets/add_component.dart';

TextEditingController _titleCtrl = TextEditingController();

final recipeProvider =
    ChangeNotifierProvider<RecipeProvider>((ref) => RecipeProvider());
List steps = [];

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
                  controller: _titleCtrl,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: 'Recipe name',
                  ),
                  onChanged: (value) {
                    _recipe.changeTitle(newName: _titleCtrl.text);
                  },
                  onSubmitted: (submitted) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Expanded(
            child: PageView(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${'difficulty'.tr()}: '),
                        Text(
                          _recipe.getDifficulty(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )
                      ],
                    ),
                    Slider(
                      value: _recipe.difficultyValue,
                      onChanged: (value) {
                        _recipe.changeDifficulty(newDifficultyValue: value);
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
                      label: _recipe.recipe.difficulty,
                      inactiveColor: Colors.grey,
                    ),
                    Text('${'category'.tr()}'),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RawMaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            fillColor: _recipe.recipe.category == 'Drink'
                                ? Colors.green
                                : Theme.of(context).cardColor,
                            onPressed: () {
                              _recipe.changeCategory(newCategory: 'Drink');
                            },
                            child: Text('${'drink'.tr()}'),
                          ),
                          RawMaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            fillColor: _recipe.recipe.category == 'Food'
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
                            fillColor: _recipe.recipe.category == 'E-Liquid'
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
                            fillColor: _recipe.recipe.category == 'Other'
                                ? Colors.green
                                : Theme.of(context).cardColor,
                            onPressed: () {
                              _recipe.changeCategory(newCategory: 'Other');
                            },
                            child: Text('${'other'.tr()}'),
                          )
                        ]),
                    subCategory(category: _recipe.recipe.category),
                    ListTile(
                      title: Text(
                        'ingredients'.tr(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AddComponent(),
                          ),
                        ),
                      ),
                    ),
                    ComponentsList(),
                    Text('1/3')
                  ],
                ),
                Column(
                  children: [
                    Text('instructions'.tr()),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (_, int index) {
                          int _index = index + 1;
                          return Card(
                            child: ListTile(
                              title: Text('${'step'.tr()} $_index'),
                              subtitle: Text('${index}'),
                            ),
                          );
                        },
                      ),
                    ),
                    Text('2/3'),
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
                    Text('3/3')
                  ],
                ),
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
      case ('Food'):
        _subCategory = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${'subCategory'.tr()}'),
            FoodSubCategories(),
          ],
        );
        return _subCategory;
      case ('Drink'):
        _subCategory = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${'subCategory'.tr()}'),
            DrinksSubCategories(),
          ],
        );
        return _subCategory;
      default:
        _subCategory = Container();
        return _subCategory;
    }
  }
}
