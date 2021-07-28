import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:easy_localization/easy_localization.dart';

class TitleField extends StatefulWidget {
  const TitleField({
    Key key,
  }) : super(key: key);

  @override
  _TitleFieldState createState() => _TitleFieldState();
}

class _TitleFieldState extends State<TitleField> {
  TextEditingController _titleCtrl = TextEditingController();
  @override
  void initState() {
    _titleCtrl = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 2, right: 20, left: 20),
      child: Consumer(builder: (_, watch, child) {
        final _recipe = watch(recipeProvider);
        return TextField(
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
            _recipe.changeTitle(newTitle: _titleCtrl.text);
            FocusScope.of(context).requestFocus(FocusNode());
          },
        );
      }),
    );
  }
}
