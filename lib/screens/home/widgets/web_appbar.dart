import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/home_screen.dart';
import 'package:myxmi/providers/user.dart';
import 'package:myxmi/utils/user_avatar.dart';

class WebAppBar extends StatelessWidget {
  final String? uid;
  const WebAppBar({Key? key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Consumer(
      builder: (context, ref, child) {
        final _user = ref.watch(userProvider);
        return SizedBox(
          width: _size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_size.width >= 770)
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child:
                            _PageViewButton(uid: uid, index: 9, text: 'Myxmi'),
                      ),
                    const SizedBox(width: 40),
                    _PageViewButton(uid: uid, index: 0, text: 'home'.tr()),
                    _PageViewButton(uid: uid, index: 1, text: 'myRecipes'.tr()),
                    _PageViewButton(uid: uid, index: 2, text: 'favorites'.tr()),
                    _PageViewButton(uid: uid, index: 3, text: 'products'.tr()),
                  ],
                ),
              ),
              Row(
                children: [
                  if (uid != null)
                    _PageViewButton(uid: uid, index: 4, text: 'more'.tr())
                  else
                    _PageViewButton(uid: uid, index: 4, text: 'signIn'.tr()),
                  // if (uid == null)
                  //   _PageViewButton(uid: uid, index: 6, text: 'signUp'),
                  if (uid != null && _size.width >= 750)
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
                            if (_user.account!.photoURL != null)
                              UserAvatar(
                                photoUrl: _user.account?.photoURL,
                                radius: 50,
                              )
                            else
                              const Center(
                                child: Icon(
                                  Icons.person,
                                  size: 33 * 1.2,
                                ),
                              ),
                            if (_user.account?.displayName != null)
                              Text(_user.account!.displayName!)
                            else
                              Text(_user.account!.email!),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PageViewButton extends StatelessWidget {
  final int index;
  final String? uid;
  final String text;
  const _PageViewButton({
    required this.index,
    required this.uid,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _view = ref.watch(homeScreenProvider);
        return RawMaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: () {
            _view.changeViewIndex(index: index, uid: uid);
            _view.doSearch(value: false);
          },
          child: _SelectableContainer(
            selected: _view.view == index,
            text: text,
          ),
        );
      },
    );
  }
}

class _SelectableContainer extends StatelessWidget {
  final bool selected;
  final String text;
  const _SelectableContainer({required this.selected, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 4,
            color: selected
                ? Theme.of(context).appBarTheme.titleTextStyle!.color!
                : Colors.transparent,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: selected ? 17 : 19,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
