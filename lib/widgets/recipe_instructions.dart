import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/create_recipe.dart';
import 'new_recipe_image.dart';
import 'save_recipe.dart';

TextEditingController _stepCtrl = TextEditingController();

class RecipeInstructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerDragStartBehavior: DragStartBehavior.down,
      drawer: SafeArea(
        child: Consumer(builder: (_, watch, child) {
          final _recipe = watch(recipeProvider);
          return Drawer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.only(top: 7),
                  title: Center(
                    child: Text(
                      'ingredients'.tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: int.parse(_recipe.recipeModel.ingredientsCount),
                    itemBuilder: (_, int index) {
                      final List _keys = _recipe.composition.keys.toList();
                      final String _keyIndex = '${_keys[index]}';
                      return Card(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(
                                '$_keyIndex:',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' ${_recipe.composition[_keyIndex]}',
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Consumer(builder: (_, watch, child) {
          final _recipe = watch(recipeProvider);
          return Text(
              '${'instructionsFor'.tr()}: ${_recipe.recipeModel.title}');
        }),
        actions: [
          SaveButton(),
        ],
      ),
      body: Consumer(builder: (_, watch, child) {
        final _recipe = watch(recipeProvider);
        final List _steps = _recipe?.instructions?.steps;
        final int _keys = _steps?.length != null ? _steps.length : 0;
        final int _newKey = _keys + 1;
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _keys,
                itemBuilder: (_, int index) {
                  final int _index = index + 1;
                  return Card(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: ListTile(
                      title: Text('${'step'.tr()} $_index'),
                      subtitle: Text('${_steps[index]}'),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 5, bottom: 5),
                    child: TextField(
                      controller: _stepCtrl,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          fillColor: Colors.grey,
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelText: '${'step'.tr()} $_newKey: '),
                    ),
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.all(2),
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: () {
                    _recipe.addStep(step: _stepCtrl.text);
                    _stepCtrl.clear();
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
                IconButton(
                  padding: const EdgeInsets.all(2),
                  icon: const Icon(Icons.add_a_photo),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => NewRecipeImage()),
                    );
                  },
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
