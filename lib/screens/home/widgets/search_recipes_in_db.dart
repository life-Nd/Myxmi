import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/home/home_screen.dart';

class SearchRecipesInDb extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        final _view = ref.watch(homeScreenProvider);
        return Padding(
          padding:
              const EdgeInsets.only(left: 10.0, right: 10.0, top: 4, bottom: 8),
          child: TextField(
            controller: _view.searchCtrl,
            onSubmitted: (submitted) {
              _view.search();
              if (!kIsWeb) {
                FocusScope.of(context).requestFocus(FocusNode());
              }
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
                  if (!kIsWeb) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  }
                  FocusScope.of(context).unfocus();
                  _view.searchCtrl.clear();
                  _view.doSearch(value: false);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
