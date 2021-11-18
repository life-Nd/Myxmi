import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/views/home/home_view.dart';

class SearchRecipesInDb extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, __) {
      final _view = watch(homeViewProvider);
      return Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: TextField(
          controller: _view.searchCtrl,
          onSubmitted: (submitted) {
            _view.search();
            !kIsWeb ?? FocusScope.of(context).requestFocus(FocusNode());
          },
          decoration: InputDecoration(
            filled: true,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            hintText: 'searchRecipe'.tr(),
            prefixIcon: IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.red,
              ),
              onPressed: () {
                !kIsWeb ?? FocusScope.of(context).requestFocus(FocusNode());
                FocusScope.of(context).unfocus();
                _view.searchCtrl.clear();
                _view.doSearch(value: false);
              },
            ),
          ),
        ),
      );
    });
  }
}
