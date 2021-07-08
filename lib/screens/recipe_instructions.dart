import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe.dart';

TextEditingController _stepCtrl = TextEditingController();

class RecipeInstructions extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
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
                padding: const EdgeInsets.only(left: 10, right: 30, bottom: 5),
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
             icon: const Icon(Icons.send, color: Colors.green),
              onPressed: () {
                _recipe.addStep(step: _stepCtrl.text);
                _stepCtrl.clear();
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
          ],
        ),
      ],
    );
  }
}
