import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/screens/products/add/add_new_product_view.dart';
import 'package:myxmi/screens/products/add/app_scanner.dart';
import 'package:openfoodfacts/model/Nutriments.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

bool enterProductDetails = false;

class CustomSizeScannerPage extends StatefulWidget {
  const CustomSizeScannerPage({Key? key}) : super(key: key);
  @override
  _CustomSizeScannerPageState createState() => _CustomSizeScannerPageState();
}

class _CustomSizeScannerPageState extends State<CustomSizeScannerPage> {
  String _code = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: _code.isNotEmpty
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
      appBar: AppBar(
        title: Text(
          'addProduct'.tr(),
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      bottomSheet: _code.isNotEmpty
          ? !enterProductDetails
              ? Container(
                  alignment: Alignment.topCenter,
                  height: 400,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('Barcode: $_code'),
                          ),
                          FutureBuilder<Product?>(
                            future: _getProduct(_code),
                            builder: (_, AsyncSnapshot<Product?> snapshot) {
                              if (snapshot.hasData) {
                                final _data = snapshot.data!;
                                final Product _product = _data;
                                debugPrint('Product: ${_product.toJson()}');
                                final Nutriments _nutriments =
                                    _product.nutriments!;

                                final String _ingredientsText =
                                    _product.ingredientsText!;
                                return Card(
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
                                );
                              }
                              return Container();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : null
          : null,
      body: !enterProductDetails
          ? AppBarcodeScannerWidget.defaultStyle(
              resultCallback: (String code) {
                setState(() {
                  _code = code;
                });
              },
            )
          : Column(
              children: [
                const QuantityEntry(),
                const ExpirationEntry(),
                const Spacer(),
                RawMaterialButton(
                  fillColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    // _product.saveToDb(
                    //             uid: _user.account?.uid,
                    //             name: _nameCtrl.text,
                    //             quantity: _quantityCtrl.text,
                    //           );
                  },
                  child: Text(
                    'save'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Spacer(),
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
