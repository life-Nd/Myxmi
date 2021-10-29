import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/main.dart';
import 'package:myxmi/screens/home.dart';
import 'package:myxmi/widgets/selected_container.dart';
import 'package:myxmi/widgets/user_avatar.dart';

class WebAppBar extends StatelessWidget {
  final String uid;
  const WebAppBar({Key key, this.uid}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Consumer(builder: (context, watch, child) {
      final _user = watch(userProvider);
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
                children: [
                  _PageViewButton(uid: uid, index: 0, text: 'home'),
                  _PageViewButton(uid: uid, index: 1, text: 'myRecipes'),
                  _PageViewButton(uid: uid, index: 2, text: 'favorites'),
                  _PageViewButton(uid: uid, index: 3, text: 'products'),
                ],
              ),
              Row(
                children: [
                  if (uid != null)
                    _PageViewButton(uid: uid, index: 4, text: 'more')
                  else
                     _PageViewButton(uid: uid, index: 5, text: 'signIn'),
                  // if (uid == null)
                  //   _PageViewButton(uid: uid, index: 6, text: 'signUp'),
                  if (uid != null)
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
                            if (_user.account.photoURL != null)
                              UserAvatar(
                                  photoUrl: _user?.account?.photoURL,
                                  radius: 33)
                            else
                              const Center(
                                child: Icon(
                                  Icons.person,
                                  size: 33 * 1.2,
                                ),
                              ),
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
  final String uid;
  final String text;
  const _PageViewButton(
      {@required this.index, @required this.uid, @required this.text});
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, child) {
      final _view = watch(homeViewProvider);
      return RawMaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          _view.changeViewIndex(index: index, uid: uid);
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
