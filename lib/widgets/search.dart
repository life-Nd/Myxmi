import 'package:flutter/foundation.dart';
import 'package:myxmi/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchRecipes extends StatelessWidget {
  final Function onSubmit;
  final Function clear;

  const SearchRecipes({Key key, this.onSubmit, this.clear}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, __) {
      final _view = watch(homeViewProvider);
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: _view.searchCtrl,
              onSubmitted: (submitted) {
                _view.search();
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
              _view.doSearch(value: false);
            },
          ),
          // IconButton(
          //     icon: const Icon(
          //       Icons.search,
          //     ),
          //     onPressed: () {
          //       _view.search();
          //       !kIsWeb ?? FocusScope.of(context).requestFocus(FocusNode());
          //       FocusScope.of(context).unfocus();
          //     }),
        ],
      );
    });
  }
}
