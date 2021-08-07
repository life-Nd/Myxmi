import 'package:flutter/foundation.dart';
import 'package:myxmi/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../app.dart';

class SearchRecipes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, __) {
      final _view = watch(viewProvider);
      final _fav = watch(favProvider);
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: _view.searchCtrl,
              onSubmitted: (submitted) {
                debugPrint('SUBMITTED: $submitted');
                _view.search(fav: _fav);
                !kIsWeb ?? FocusScope.of(context).requestFocus(FocusNode());
              },
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'search'.tr(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.clear,
              color: Colors.red,
            ),
            onPressed: () {
              !kIsWeb ?? FocusScope.of(context).requestFocus(FocusNode());
              FocusScope.of(context).unfocus();
              _view.searchCtrl.clear();
              _fav.showFilter(value: false);
              _view.doSearch(value: false);
            },
          ),
          IconButton(
              icon: const Icon(
                Icons.search,
              ),
              onPressed: () {
                _view.search(fav: _fav);
                !kIsWeb ?? FocusScope.of(context).requestFocus(FocusNode());
                FocusScope.of(context).unfocus();
              }),
        ],
      );
    });
  }
}
