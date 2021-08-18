import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myxmi/screens/home.dart';
import 'package:myxmi/widgets/selected_container.dart';
import 'package:myxmi/widgets/user_avatar.dart';

class WebAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Consumer(builder: (context, watch, child) {
      final _user = watch(userProvider);
      debugPrint('AVATAR: ${_user?.account?.photoURL}');
      return SizedBox(
        width: _size.width,
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Myxmi',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
//OLD IMAGE:  https://firebasestorage.googleapis.com/v0/b/myxmi-94982.appspot.com/o/1625900439775-46743.jpg?alt=media&token=58f5250d-dde1-4de2-89dc-4a2c8af50846
                mainAxisSize: MainAxisSize.min,
                children: const [
                  _PageViewButton(index: 0, text: 'home'),
                  _PageViewButton(index: 1, text: 'myRecipes'),
                  _PageViewButton(index: 2, text: 'favorites'),
                  _PageViewButton(index: 3, text: 'products'),
                ],
              ),
              Row(
                children: [
                  if (_user.account?.uid != null)
                    const _PageViewButton(index: 4, text: 'more')
                  else
                    const _PageViewButton(index: 3, text: 'signIn'),
                  if (_user?.account?.uid == null)
                    const _PageViewButton(index: 3, text: 'signUp'),
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
                            UserAvatar(
                                photoURL: _user?.account?.photoURL, radius: 33),
                            if (_user?.account?.displayName != null)
                              Text(_user?.account?.displayName)
                            else
                              Text(_user?.account?.email),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _PageViewButton extends StatelessWidget {
  final int index;
  final String text;
  const _PageViewButton({@required this.index, @required this.text});
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, child) {
      final _view = watch(homeViewProvider);
      final _user = watch(userProvider);
      return RawMaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          _view.changeViewIndex(index: index, uid: _user?.account?.uid);
          _view.doSearch(value: false);
        },
        child: SelectableContainer(
          selected: _view.view == index,
          text: text.tr(),
        ),
      );
    });
  }
}
