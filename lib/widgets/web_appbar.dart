import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myxmi/screens/home.dart';
import 'package:myxmi/widgets/selected_container.dart';
import 'package:myxmi/widgets/user_avatar.dart';

class WebAppBar extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _user = useProvider(userProvider);
    final _view = useProvider(viewProvider);
    final _change = useState<bool>(false);
    final Size _size = MediaQuery.of(context).size;
    return Row(
        children: [
          const Text(
            'Myxmi',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: _size.width / 11),
          Row(
          children: [
              RawMaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                _view.changeViewIndex(index: 0);
                _change.value = !_change.value;
              },
              child: SelectableContainer(
                selected: _view.view == 0,
                text: 'home'.tr(),
              ),
              ),
          ],
          ),
          RawMaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              _view.changeViewIndex(index: 1);
              _change.value = !_change.value;
            },
            child: SelectableContainer(
              selected: _view.view == 1,
              text: 'recipes'.tr(),
            ),
          ),
          RawMaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              _view.changeViewIndex(index: 2);
              _change.value = !_change.value;
            },
            child: SelectableContainer(
              selected: _view.view == 2,
              text: 'favorites'.tr(),
            ),
          ),
          RawMaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              _view.changeViewIndex(index: 3);
              _change.value = !_change.value;
            },
            child: SelectableContainer(
              selected: _view.view == 3,
              text: 'products'.tr(),
            ),
          ),
          const Spacer(),
          if (_user.account?.uid != null)
            RawMaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                _view.changeViewIndex(index: 4);
                _change.value = !_change.value;
              },
              child: SelectableContainer(
                selected: _view.view == 4,
                text: 'settings'.tr(),
              ),
            )
          else
            RawMaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                _view.changeViewIndex(index: 5);
                _change.value = !_change.value;
              },
              child: Text(
                'signIn'.tr(),
                style: const TextStyle(fontSize: 17),
              ),
            ),
          if (_user?.account?.uid == null)
            RawMaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                _view.changeViewIndex(index: 5);
                _change.value = !_change.value;
              },
              child: Text(
                'signUp'.tr(),
                style: const TextStyle(fontSize: 17),
              ),
            ),
          if (_user?.account?.uid != null)
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  bottomLeft: Radius.circular(100),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
                  children: [
                    UserAvatar(photoURL: _user?.account?.photoURL, radius: 33),
                    if (_user?.account?.displayName != null)
                      Text(_user?.account?.displayName)
                    else
                      Text(_user?.account?.email),
                  ],
                ),
              ),
            ),
        ],

    );
  }
}
