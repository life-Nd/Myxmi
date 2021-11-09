import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_infos_to_recipe.dart';

class TitleField extends StatelessWidget {
  const TitleField({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 2, right: 20, left: 20),
      child: Consumer(builder: (_, watch, child) {
        final _recipe = watch(recipeEntriesProvider);
        return TextField(
          controller: _recipe.titleCtrl,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: 'recipeTitle'.tr(),
            errorText:
                _recipe.recipe.title == null
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
