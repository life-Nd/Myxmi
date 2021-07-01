import 'package:myxmi/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../app.dart';
import 'package:easy_localization/easy_localization.dart';
import '../main.dart';

TextEditingController _searchCtrl = TextEditingController();
FocusNode _searchNode = FocusNode();
String _searchFilter = 'Reference';

class SearchRecipes extends HookWidget {
  final bool showFilter;
  SearchRecipes({this.showFilter = true});
  Widget build(BuildContext context) {
    final _user = useProvider(userProvider);
    final _view = useProvider(viewProvider);
    final _change = useState<bool>(false);
    final _fav = useProvider(favProvider);
    return ListTile(
      dense: true,
      title: TextField(
        onTap: () {
          _view.doSearch(true);
        },
        controller: _searchCtrl,
        focusNode: _searchNode,
        onEditingComplete: () {
          _view.searchRecipe(
            filter: _searchFilter,
            text: _searchCtrl.text,
            uid: _user.account.uid,
            fav: _fav,
          );
          FocusScope.of(context).requestFocus(FocusNode());
          Future.delayed(Duration(seconds: 2), () {
            _searchCtrl.clear();
          });
          _change.value = !_change.value;
        },
        onSubmitted: (submitted) {
          _view.searchRecipe(
            filter: _searchFilter,
            text: _searchCtrl.text,
            uid: _user.account.uid,
            fav: _fav,
          );
          FocusScope.of(context).requestFocus(FocusNode());
          Future.delayed(Duration(seconds: 2), () {
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
        icon: Icon(
          Icons.search,
        ),
        onPressed: () {
          print("IconButton Search filter: $_searchFilter");
          print("IconButton Search text: ${_searchCtrl.text}");
          _view.searchRecipe(
            filter: _searchFilter,
            text: _searchCtrl.text,
            uid: _user.account.uid,
            fav: _fav,
          );
          FocusScope.of(context).requestFocus(FocusNode());
          Future.delayed(Duration(seconds: 2), () {
            _searchCtrl.clear();
          });
          _change.value = !_change.value;
        },
      ),
    );
  }
}
