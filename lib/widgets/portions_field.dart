import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:easy_localization/easy_localization.dart';

class PortionsField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 100, right: 100),
            child: Consumer(builder: (_, watch, child) {
              final _recipe = watch(recipeProvider);
              return TextField(
                controller: _recipe.portionsCtrl,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _recipe.changePortions();
                },
                onSubmitted: (submitted) {
                  !kIsWeb ?? FocusScope.of(context).requestFocus(FocusNode());
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.local_pizza_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'portions'.tr(),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
