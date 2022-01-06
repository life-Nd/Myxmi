import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/home_screen.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/providers/user.dart';
import 'package:myxmi/screens/products/add/add_product_manually.dart';
import 'package:myxmi/screens/products/add/app_scanner.dart';
import 'package:myxmi/screens/products/add/widgets/nutrition_details.dart';

final TextEditingController _quantityCtrl = TextEditingController();

class ScanProductScreen extends StatefulWidget {
  const ScanProductScreen({Key? key}) : super(key: key);
  @override
  _ScanProductScreenState createState() => _ScanProductScreenState();
}

class _ScanProductScreenState extends State<ScanProductScreen> {
  String _code = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: _code.isNotEmpty
          ? Consumer(
              builder: (context, ref, watch) {
                final _productScanned = ref.watch(productScannedProvider);
                if (!_productScanned.enterProductDetails) {
                  return FloatingActionButton(
                    backgroundColor: Colors.green,
                    onPressed: () {
                      setState(() {
                        _productScanned.enterProductDetails = true;
                      });
                    },
                    child: const Icon(Icons.check),
                  );
                } else {
                  return Container();
                }
              },
            )
          : null,
      bottomSheet: Consumer(
        builder: (_, ref, child) {
          final _router = ref.watch(routerProvider);
          final _product = ref.watch(productEntryProvider);
          final _productScannedProvider = ref.watch(productScannedProvider);
          final _productName = _productScannedProvider.productName;
          final _photoUrl = _productScannedProvider.photoUrl;
          final _user = ref.watch(userProvider);
          if (_productScannedProvider.enterProductDetails) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const QuantityEntry(),
                const SizedBox(
                  width: 4,
                ),
                const ExpirationEntry(),
                const SizedBox(
                  width: 4,
                ),
                RawMaterialButton(
                  onPressed: () async {
                    // TODO add product image to database before uploading the product
                    debugPrint(_user.account?.uid);
                    debugPrint(_productName);
                    debugPrint(_quantityCtrl.text);
                    debugPrint(_code);
                    debugPrint(_photoUrl);

                    await _product.saveToDb(
                      uid: _user.account?.uid,
                      name: _productName!,
                      quantity: _quantityCtrl.text,
                      barcode: _code,
                      photoUrl: _photoUrl!,
                    );
                    _router.pushPage(name: '/home');
                  },
                  fillColor: Colors.green,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Text('save'.tr()),
                ),
              ],
            );
          }
          return const Text('');
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Consumer(
              builder: (_, ref, child) {
                final _router = ref.watch(routerProvider);
                final _homeView = ref.watch(homeScreenProvider);
                return IconButton(
                  alignment: Alignment.topLeft,
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    _homeView.changeView(index: 3);
                    _router.pushPage(
                      name: '/home',
                    );
                  },
                );
              },
            ),
            title: Text(
              'addProduct'.tr(),
            ),
            expandedHeight: 700,
            flexibleSpace: Column(
              children: [
                Expanded(
                  child: AppBarcodeScannerWidget.defaultStyle(
                    resultCallback: (String code) {
                      setState(() {
                        _code = code;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_code.isNotEmpty)
            SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  if (_code.isNotEmpty)
                    ListTile(title: Text('Barcode: $_code')),
                  NutritionDetails(
                    code: _code,
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
