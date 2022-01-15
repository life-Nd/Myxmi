import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/home_screen.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/providers/user.dart';
import 'package:myxmi/screens/home/widgets/app_bottom_navigation.dart';
import 'package:myxmi/screens/home/widgets/body.dart';
import 'package:myxmi/screens/home/widgets/web_appbar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Consumer(
      builder: (_, ref, __) {
        final _home = ref.watch(homeScreenProvider);
        final _user = ref.watch(userProvider);
        final _router = ref.watch(routerProvider);
        final int _viewIndex =
            kIsWeb && _size.width > 700 ? _home.webIndex : _home.bottomIndex;

        return Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: true,
          appBar: _size.width > 700
              ? AppBar(
                  automaticallyImplyLeading: false,
                  flexibleSpace: WebAppBar(uid: _user.account?.uid),
                )
              : null,
          floatingActionButton: _viewIndex == 0 ||
                  _viewIndex == 1 && _user.account?.uid != null ||
                  _viewIndex == 3 && _user.account?.uid != null
              ? _user.account?.uid != null
                  ? FloatingActionButton(
                      backgroundColor: Colors.green.shade400,
                      onPressed: () {
                        final TargetPlatform _platform =
                            Theme.of(context).platform;
                        bool _onPhone = true;
                        try {
                          _onPhone = TargetPlatform.iOS == _platform ||
                              TargetPlatform.android == _platform;
                        } catch (error) {
                          _onPhone = MediaQuery.of(context).size.width <= 500;
                        }

                        _viewIndex != 3
                            ? _router.pushPage(name: '/add-recipe-infos')
                            : _onPhone
                                ? _router.pushPage(name: '/scan-product')
                                : _router.pushPage(
                                    name: '/add-product-manually',
                                  );
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    )
                  : FloatingActionButton(
                      backgroundColor: Colors.red,
                      onPressed: () {
                        _home.changeViewIndex(
                          index: 4,
                          uid: _user.account?.uid,
                        );
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    )
              : null,
          body: Padding(
            padding: EdgeInsets.only(
              left: _size.width > 700 ? 100 : 0,
              right: _size.width > 700 ? 100 : 0,
            ),
            child: Body(),
          ),
          // ignore: avoid_redundant_argument_values
          bottomNavigationBar:
              _size.width <= 700 ? AppBottomNavigation() : null,
        );
      },
    );
  }
}
