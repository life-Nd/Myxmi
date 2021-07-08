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
    return ListTile(
      dense: true,
      title: TextField(
        onTap: () {},
        onChanged: (value) {
          _view.searchText = value;
        },
        controller: _searchCtrl,
        focusNode: _searchNode,
        onEditingComplete: () {
          _view.view == 2
              ? _fav.filter(filter: _searchFilter, text: _searchCtrl.text)
              : debugPrint('not favorite screen');
          _view.doSearch(value: true);
          // _view.searchRecipe(
          //   filter: _searchFilter,
          //   text: _searchCtrl.text,
          //   uid: _user.account.uid,
          //   fav: _fav,
          // );
          FocusScope.of(context).requestFocus(FocusNode());
          Future.delayed(const Duration(seconds: 2), () {
            _searchCtrl.clear();
          });
          _change.value = !_change.value;
        },
        onSubmitted: (submitted) {
          _view.view == 2
              ? _fav.filter(filter: _searchFilter, text: _searchCtrl.text)
              : debugPrint('not favorite screen');
          _view.doSearch(value: true);
          // _view.searchRecipe(
          //   filter: _searchFilter,
          //   text: _searchCtrl.text,
          //   uid: _user.account.uid,
          //   fav: _fav,
          // );
          FocusScope.of(context).requestFocus(FocusNode());
          Future.delayed(const Duration(seconds: 2), () {
            _searchCtrl.clear();
          });
          _change.value = !_change.value;
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
        onPressed: () {
          debugPrint("IconButton Search filter: $_searchFilter");
          debugPrint("IconButton Search text: ${_searchCtrl.text}");

          _view.view == 2
              ? _fav.filter(filter: _searchFilter, text: _searchCtrl.text)
              : debugPrint('not favorite screen');
          _view.doSearch(value: true);
          // _view.searchRecipe(
          //   filter: _searchFilter,
          //   text: _searchCtrl.text,
          //   uid: _user.account.uid,
          //   fav: _fav,
          // );
          FocusScope.of(context).requestFocus(FocusNode());
          Future.delayed(const Duration(seconds: 2), () {
            _searchCtrl.clear();
          });
          _change.value = !_change.value;
        },
      ),
    );
  }
}
