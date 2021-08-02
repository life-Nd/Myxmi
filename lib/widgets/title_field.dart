import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:easy_localization/easy_localization.dart';

class TitleField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 2, right: 20, left: 20),
      child: Consumer(builder: (_, watch, child) {
        final _recipe = watch(recipeProvider);
        return TextField(
          controller: _recipe.titleCtrl,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: 'recipeTitle'.tr(),
            errorText: _recipe.recipeModel.title == null
                ? 'titleCantBeEmpty'.tr()
                : null,
          ),
          onChanged: (value) {
            _recipe.changeTitle();
          },
          onSubmitted: (submitted) {
            !kIsWeb ??
                !kIsWeb ??
                FocusScope.of(context).requestFocus(FocusNode());
          },
        );
      }),
    );
  }
}
