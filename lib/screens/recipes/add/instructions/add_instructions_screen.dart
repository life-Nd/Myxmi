import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/image.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/screens/recipes/add/infos/add_infos_screen.dart';
import 'package:myxmi/screens/recipes/add/instructions/widgets/save_recipe.dart';

import 'package:myxmi/utils/image_selector.dart';

TextEditingController _instructionCtrl = TextEditingController();

class AddRecipeInstructionsScreen extends StatelessWidget {
  AddRecipeInstructionsScreen({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    debugPrint('building: AddRecipeInstructionsScreen');
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      drawerDragStartBehavior: DragStartBehavior.down,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.dehaze),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: Consumer(
          builder: (_, ref, child) {
            final _recipe = ref.watch(recipeEntriesProvider);
            return Text('${'instructionsFor'.tr()}: ${_recipe.recipe.title}');
          },
        ),
        actions: [
          SaveButton(),
        ],
      ),
      drawer: SafeArea(
        child: Consumer(
          builder: (_, ref, child) {
            final _recipe = ref.watch(recipeEntriesProvider);
            final _router = ref.watch(routerProvider);
            return Drawer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        _router.pushPage(name: '/add-recipe-products');
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
                    child: _recipe.recipe.ingredientsCount != null
                        ? ListView.builder(
                            itemCount: _recipe.composition.length,
                            itemBuilder: (_, int index) {
                              final Map _composition = _recipe.composition;
                              final List _keys = _composition.keys.toList();
                              final String _keyIndex = '${_keys[index]}';
                              final Map _compositionIndex =
                                  _composition[_keyIndex] as Map;

                              final String _nameKey =
                                  '${_compositionIndex['name']}';
                              final String _name =
                                  '${_nameKey[0].toUpperCase()}${_nameKey.substring(1, _nameKey.length)}';
                              return Card(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
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
                                        ' ${_compositionIndex['value']} ${_compositionIndex['type']}',
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
          },
        ),
      ),
      body: Consumer(
        builder: (_, ref, child) {
          final _recipe = ref.watch(recipeEntriesProvider);
          final _image = ref.watch(imageProvider);
          final List _instructions = _recipe.instructions.toList();
          final int _keys = _instructions.isNotEmpty ? _instructions.length : 0;
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
                        _recipe.removeInstruction(
                          instruction: _instructions[index] as String,
                        );
                      },
                      child: Card(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: ListTile(
                          title: Text('${'step'.tr()} $_index'),
                          subtitle: Text('${_instructions[index]}'),
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
                        controller: _instructionCtrl,
                        keyboardType: TextInputType.multiline,
                        onSubmitted: (submitted) {
                          if (!kIsWeb) {
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                        },
                        maxLines: null,
                        decoration: InputDecoration(
                          fillColor: Colors.grey,
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelText: '${'step'.tr()} $_newKey:',
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    padding: const EdgeInsets.all(2),
                    icon: const Icon(Icons.send, color: Colors.green),
                    onPressed: () {
                      _recipe.addInstruction(
                        instruction: _instructionCtrl.text,
                      );
                      _instructionCtrl.clear();
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
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
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
        },
      ),
    );
  }
}
