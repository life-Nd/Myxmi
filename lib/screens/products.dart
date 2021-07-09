import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/app.dart';
import 'package:myxmi/main.dart';
import 'package:myxmi/widgets/products_list.dart';
import 'package:easy_localization/easy_localization.dart';

import 'add_product.dart';

int _pageIndex = 0;

class Products extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _fav = useProvider(favProvider);
    final _user = useProvider(userProvider);
    final _prefs = useProvider(prefProvider);
    final _change = useState<bool>(false);

    return RefreshIndicator(
      onRefresh: () async {
        _fav.showFilter(value: false);
        _change.value = !_change.value;
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: PageController(initialPage: _pageIndex),
                onPageChanged: (index) {
                  _pageIndex = index;
                },
                children: [
                  _EditProducts(uid: _user.account.uid),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _AllCart(
                        viewIndex: 1,
                      ),
                      Expanded(
                        child: FutureBuilder(
                          future: _prefs.readCart(),
                          builder: (_, AsyncSnapshot snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data.isNotEmpty as bool) {
                              debugPrint(
                                  'snapshot.hasData: ${snapshot.hasData}');
                              debugPrint(
                                  'snapshot: ${snapshot.data.runtimeType}');
                              return ListView.builder(
                                itemCount: snapshot.data.length as int,
                                itemBuilder: (_, int index) {
                                  return ListTile(
                                    leading: IconButton(
                                      icon: _prefs.checkedItem
                                              .contains(snapshot?.data[index])
                                          ? const Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.green,
                                            )
                                          : const Icon(
                                              Icons.radio_button_unchecked),
                                      onPressed: () async {
                                        await _prefs.editItems(
                                            item: '${snapshot.data[index]}');
                                        _change.value = !_change.value;
                                        debugPrint(
                                            'ITEMS: ${_prefs.checkedItem}');
                                      },
                                    ),
                                    title: Text('${snapshot?.data[index]}'),
                                  );
                                },
                              );
                            }
                            return Center(
                              child: Text(
                                'cartEmpty'.tr(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _EditProducts extends StatefulWidget {
  const _EditProducts({
    Key key,
    @required this.uid,
  }) : super(key: key);

  final String uid;
  @override
  State<StatefulWidget> createState() => _EditProductsState();
}

class _EditProductsState extends State<_EditProducts> {
  Future _future;
  @override
  void initState() {
    _future =
        FirebaseFirestore.instance.collection('Products').doc(widget.uid).get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const _AllCart(
              viewIndex: 0,
            ),
            Expanded(
              child: ProductsList(
                  uid: widget.uid,
                  type: 'EditProducts',
                  componentsFuture: _future),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NewProduct(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        )
      ],
    );
  }
}

class _AllCart extends StatelessWidget {
  final int viewIndex;
  const _AllCart({@required this.viewIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  width: 4,
                  color: viewIndex == 0
                      ? Theme.of(context).appBarTheme.titleTextStyle.color
                      : Colors.transparent),
            ),
          ),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Theme.of(context).appBarTheme.titleTextStyle.color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'all'.tr().toUpperCase(),
                ),
                WidgetSpan(
                  child: Transform.translate(
                    offset: const Offset(0.0, -9.0),
                    child: const Text(
                      '',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
              width: 4,
              color: viewIndex == 1
                  ? Theme.of(context).appBarTheme.titleTextStyle.color
                  : Colors.transparent,
            )),
          ),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                  color: Theme.of(context).appBarTheme.titleTextStyle.color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: 'cart'.tr().toUpperCase(),
                ),
                WidgetSpan(
                  child: Transform.translate(
                    offset: const Offset(0.0, -9.0),
                    child: const Text(
                      '',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
