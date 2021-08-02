import 'package:flutter/foundation.dart';
import 'package:myxmi/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../app.dart';

TextEditingController _searchCtrl = TextEditingController();
FocusNode _searchNode = FocusNode();
String _searchFilter = 'title';

class SearchRecipes extends HookWidget {
  final bool showFilter;
  const SearchRecipes({this.showFilter = true});
  @override
  Widget build(BuildContext context) {
    final _view = useProvider(viewProvider);
    final _change = useState<bool>(false);
    final _fav = useProvider(favProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        dense: true,
        title: TextField(
          onTap: () {},
          onChanged: (value) {
            _view.searchText = value;
          },
          controller: _searchCtrl,
          focusNode: _searchNode,
          onEditingComplete: _searchCtrl.text.isNotEmpty
              ? () {
                  _view.view == 2 ??
                      _fav.filter(
                          filter: _searchFilter, text: _searchCtrl.text);
                  _view.doSearch(value: true);
                  !kIsWeb ?? FocusScope.of(context).requestFocus(FocusNode());
                  Future.delayed(const Duration(seconds: 4), () {
                    _searchCtrl.clear();
                  });
                  _change.value = !_change.value;
                }
              : () {
                  !kIsWeb ?? FocusScope.of(context).requestFocus(FocusNode());
                },
          onSubmitted: _searchCtrl.text.isNotEmpty
              ? (submitted) {
                  _view.view == 2 ??
                      _fav.filter(
                          filter: _searchFilter, text: _searchCtrl.text);
                  _view.doSearch(value: true);
                  !kIsWeb ?? FocusScope.of(context).requestFocus(FocusNode());
                  Future.delayed(const Duration(seconds: 2), () {
                    _searchCtrl.clear();
                  });
                  _change.value = !_change.value;
                }
              : (submitted) {
                  !kIsWeb ?? FocusScope.of(context).requestFocus(FocusNode());
                },
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
                gapPadding: 2.0, borderRadius: BorderRadius.circular(20)),
            hintText: 'search'.tr(),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.search,
          ),
          onPressed: _searchCtrl.text.isNotEmpty
              ? () {
                  debugPrint("IconButton Search filter: $_searchFilter");
                  debugPrint("IconButton Search text: ${_searchCtrl.text}");
                  _view.view == 2
                      ? _fav.filter(
                          filter: _searchFilter, text: _searchCtrl.text)
                      : debugPrint('not favorite screen');
                  _view.doSearch(value: true);
                  !kIsWeb ?? FocusScope.of(context).requestFocus(FocusNode());
                  Future.delayed(const Duration(seconds: 2), () {
                    _searchCtrl.clear();
                  });
                  _change.value = !_change.value;
                }
              : () {
                  !kIsWeb ?? FocusScope.of(context).requestFocus(FocusNode());
                },
        ),
      ),
    );
  }
}
