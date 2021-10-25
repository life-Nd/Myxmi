import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/image.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:myxmi/widgets/image_selector.dart';
import 'package:myxmi/widgets/save_recipe.dart';

import 'add_recipe_products.dart';

TextEditingController _stepCtrl = TextEditingController();

class AddRecipeInstructions extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      drawerDragStartBehavior: DragStartBehavior.down,
      drawer: SafeArea(
        child: Consumer(builder: (_, watch, child) {
          final _recipe = watch(recipeProvider);
          return Drawer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddRecipeProducts(),
                        ),
                      );
                    },
                  ),
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
                  child: _recipe.recipeModel.ingredientsCount != null
                      ? ListView.builder(
                          itemCount:
                              int.parse(_recipe.recipeModel.ingredientsCount),
                          itemBuilder: (_, int index) {
                            final List _keys =
                                _recipe.composition.keys.toList();
                            final String _keyIndex = '${_keys[index]}';
                            final String _name =
                                '${_keyIndex[0]?.toUpperCase()}${_keyIndex?.substring(1, _keyIndex?.length)}';
                            return Card(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                      '$_name:',
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
                        )
                      : Center(
                          child: Text(
                            'noProducts'.tr(),
                          ),
                        ),
                ),
              ],
            ),
          );
        }),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.dehaze),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
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
        final _image = watch(imageProvider);
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
                  return Dismissible(
                    key: UniqueKey(),
                    background: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'delete'.tr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            const Icon(Icons.delete),
                          ],
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      _recipe.removeStep(step: _steps[index] as String);
                    },
                    child: Card(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: ListTile(
                        title: Text('${'step'.tr()} $_index'),
                        subtitle: Text('${_steps[index]}'),
                      ),
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
                      onSubmitted: (submitted) {
                        !kIsWeb ??
                            FocusScope.of(context).requestFocus(FocusNode());
                      },
                      maxLines: null,
                      decoration: InputDecoration(
                          fillColor: Colors.grey,
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelText: '${'step'.tr()} $_newKey:'),
                    ),
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.all(2),
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: () {
                    _recipe.addStep(step: _stepCtrl.text);
                    _stepCtrl.clear();
                    kIsWeb
                        ? debugPrint('no keyboard')
                        : FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    if (_image.state != AppState.empty)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          '1',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ImageSelector(
                      onComplete: () {},
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
