import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/create_recipe.dart';
import 'package:easy_localization/easy_localization.dart';

final TextEditingController _titleCtrl = TextEditingController();

class TitleField extends StatelessWidget {
  final FocusNode _titleNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 2, right: 20, left: 20),
      child: Consumer(builder: (_, watch, child) {
        final _recipe = watch(recipeProvider);
        return TextField(
          focusNode: _titleNode,
          controller: _titleCtrl,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: 'recipeTitle'.tr(),
            errorText: _recipe.recipeModel.title == null
                ? 'titleCantBeEmpty'.tr()
                : null,
          ),
          onEditingComplete: () {
            _recipe.changeTitle(newTitle: _titleCtrl.text);
          },
          onSubmitted: (submitted) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
        );
      }),
    );
  }
}
