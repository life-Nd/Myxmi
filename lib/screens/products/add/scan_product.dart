import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/home_screen.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/screens/products/add/app_scanner.dart';
import 'package:myxmi/screens/products/add/widgets/bottom_product_entry.dart';
import 'package:myxmi/screens/products/add/widgets/nutrition_details.dart';

class ScanProductScreen extends StatelessWidget {
  const ScanProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Consumer(
        builder: (context, ref, watch) {
          final _productScanner = ref.read(productScannerProvider);
          if (_productScanner.code.isNotEmpty &&
              !_productScanner.enterProductDetails) {
            return FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {
                _productScanner.changeEnterProductDetails();
              },
              child: const Icon(
                Icons.save_alt,
                color: Colors.white,
              ),
            );
          } else {
            return Container();
          }
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
            expandedHeight: 650,
            flexibleSpace: Consumer(
              builder: (_, ref, child) {
                final _productScanner = ref.read(productScannerProvider);
                return AppBarcodeScannerWidget.defaultStyle(
                  resultCallback: (String code) {
                    _productScanner.setCode(code);
                  },
                );
              },
            ),
          ),
          Consumer(
            builder: (_, ref, child) {
              final _productScanner = ref.watch(productScannerProvider);
              final String _code = _productScanner.code;
              return SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    if (_code.isNotEmpty) ...[
                      ListTile(title: Text('Barcode: $_code')),
                      const NutritionDetails(),
                    ]
                  ],
                ),
              );
            },
          )
        ],
      ),
      bottomSheet: const BottomSheetProductEntry(),
    );
  }
}
