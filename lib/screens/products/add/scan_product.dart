import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/home_screen.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/providers/user.dart';
import 'package:myxmi/screens/products/add/add_product_manually.dart';
import 'package:myxmi/screens/products/add/app_scanner.dart';
import 'package:openfoodfacts/model/Nutriments.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

bool enterProductDetails = false;
bool _dataFoundWithCode = false;
final TextEditingController _quantityCtrl = TextEditingController();

class ScanProductScreen extends StatefulWidget {
  const ScanProductScreen({Key? key}) : super(key: key);
  @override
  _ScanProductScreenState createState() => _ScanProductScreenState();
}

class _ScanProductScreenState extends State<ScanProductScreen> {
  String _code = '';
  String _productName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: _code.isNotEmpty && _dataFoundWithCode
          ? !enterProductDetails
              ? FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: () {
                    setState(() {
                      enterProductDetails = true;
                    });
                  },
                  child: const Icon(Icons.check),
                )
              : null
          : null,
      bottomSheet: enterProductDetails
          ? Consumer(
              builder: (_, ref, child) {
                final _product = ref.watch(productEntryProvider);
                final _user = ref.watch(userProvider);
                return Column(
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
                        await _product.saveToDb(
                          uid: _user.account?.uid,
                          name: _productName,
                          quantity: _quantityCtrl.text,
                          barcode: _code,
                          // url: _imageUrl
                        );
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
              },
            )
          : null,
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
                    ListTile(title: Text('${'code'.tr()}: $_code')),
                  FutureBuilder<Product?>(
                    future: _getProduct(_code),
                    builder: (_, AsyncSnapshot<Product?> snapshot) {
                      if (snapshot.hasData) {
                        final _data = snapshot.data!;
                        _dataFoundWithCode = true;
                        final Product _product = _data;
                        debugPrint('Product: ${_product.toJson()}');
                        final Nutriments _nutriments = _product.nutriments!;
                        final String _ingredientsText =
                            _product.ingredientsText ?? '';
                        _productName = _product.productName!;
                        return Consumer(
                          builder: (_, ref, child) {
                            final _router = ref.watch(routerProvider);
                            return GestureDetector(
                              onTap: () {
                                _router.pushPage(name: '/');
                              },
                              child: Card(
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.all(1),
                                              leading: Image.network(
                                                _product.images![0].url!,
                                                width: 77,
                                                height: 77,
                                              ),
                                              title: Text(
                                                '${_product.productName}',
                                              ),
                                              subtitle: Text(
                                                '${_product.countriesTags}',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      '${'nutritionFacts'.tr()} ',
                                                    ),
                                                    Text(
                                                      'For ${_product.nutrimentDataPer}',
                                                    ),
                                                    Text(
                                                      'perServing'.tr(),
                                                    ),
                                                  ],
                                                ),
                                                const Divider(
                                                  color: Colors.grey,
                                                  endIndent: 44,
                                                  indent: 44,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      '${'energyInCalories'.tr()} ',
                                                    ),
                                                    Text(
                                                      '${_nutriments.energyKcal} ${_nutriments.energyKcalUnit.toString().split('.').last}',
                                                    ),
                                                  ],
                                                ),
                                                const Divider(
                                                  color: Colors.grey,
                                                  endIndent: 44,
                                                  indent: 44,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text('${'fat'.tr()} '),
                                                    Text(
                                                      '${_nutriments.fat} ${_nutriments.fatUnit.toString().split('.').last}',
                                                    ),
                                                  ],
                                                ),
                                                const Divider(
                                                  color: Colors.grey,
                                                  endIndent: 44,
                                                  indent: 44,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      '${'saturatedFat'.tr()} ',
                                                    ),
                                                    Text(
                                                      '${_nutriments.saturatedFat} ${_nutriments.fatUnit.toString().split('.').last}',
                                                    ),
                                                  ],
                                                ),
                                                const Divider(
                                                  color: Colors.grey,
                                                  endIndent: 44,
                                                  indent: 44,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    const Text(
                                                      'carboHydrates',
                                                    ),
                                                    Text(
                                                      '${_nutriments.proteins} ${_nutriments.proteinsUnit.toString().split('.').last}',
                                                    ),
                                                  ],
                                                ),
                                                const Divider(
                                                  color: Colors.grey,
                                                  endIndent: 44,
                                                  indent: 44,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      '${'sugars'.tr()} ',
                                                    ),
                                                    Text(
                                                      '${_nutriments.sugars} g',
                                                    ),
                                                  ],
                                                ),
                                                const Divider(
                                                  color: Colors.grey,
                                                  endIndent: 44,
                                                  indent: 44,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      '${'proteins'.tr()} ',
                                                    ),
                                                    Text(
                                                      '${_nutriments.proteins} ${_nutriments.proteinsUnit.toString().split('.').last}',
                                                    ),
                                                  ],
                                                ),
                                                const Divider(
                                                  color: Colors.grey,
                                                  endIndent: 44,
                                                  indent: 44,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text('${'salt'.tr()} '),
                                                    Text(
                                                      '${_nutriments.salt} ${_nutriments.saltServing}',
                                                    ),
                                                  ],
                                                ),
                                                const Divider(
                                                  color: Colors.grey,
                                                  endIndent: 44,
                                                  indent: 44,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      '${'sodium'.tr()} ',
                                                    ),
                                                    Text(
                                                      '${_nutriments.sodium} ${_nutriments.sodiumUnit.toString().split('.').last}',
                                                    ),
                                                  ],
                                                ),
                                                const Divider(
                                                  color: Colors.grey,
                                                  endIndent: 44,
                                                  indent: 44,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      '${'alcohol'.tr()} ',
                                                    ),
                                                    Text(
                                                      '${_nutriments.alcohol} ${_nutriments.alcoholUnit.toString().split('.').last}',
                                                    ),
                                                  ],
                                                ),
                                                const Divider(
                                                  color: Colors.grey,
                                                  endIndent: 44,
                                                  indent: 44,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(_ingredientsText),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  Future<Product?> _getProduct(String code) async {
    final ProductQueryConfiguration _configuration = ProductQueryConfiguration(
      code,
      language: OpenFoodFactsLanguage.GERMAN,
      fields: [ProductField.ALL],
    );
    final ProductResult _result =
        await OpenFoodAPIClient.getProduct(_configuration);

    if (_result.status == 1) {
      return _result.product;
    } else {
      throw Exception('product not found, please insert data for $code');
    }
  }
}
