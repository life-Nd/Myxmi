import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/screens/products/add/app_scanner.dart';
import 'package:openfoodfacts/model/Nutriments.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

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
      appBar: AppBar(),
      bottomSheet: _code.isNotEmpty
          ? Container(
              alignment: Alignment.bottomCenter,
              height: 400,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      title:
                          Text('Searching product with barcode: $_code ... '),
                    ),
                    FutureBuilder<Product?>(
                      future: _getProduct(_code),
                      builder: (_, AsyncSnapshot<Product?> snapshot) {
                        if (snapshot.hasData) {
                          final _data = snapshot.data!;
                          final Product _product = _data;
                          debugPrint('Product: ${_product.toJson()}');
                          final Nutriments _nutriments = _product.nutriments!;
                          return Column(
                            children: [
                              Card(
                                child: ListTile(
                                  leading: Image.network(
                                    _product.images![0].url!,
                                    width: 77,
                                    height: 77,
                                  ),
                                  title: Text(
                                    '${_product.productName}',
                                  ),
                                  subtitle: Text(
                                    'Categories: ${_product.categories}',
                                  ),
                                  trailing: Card(
                                    elevation: 20,
                                    child: Text(
                                      '${_product.countriesTags}',
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('${'nutritionFacts'.tr()} '),
                                  Text('For ${_product.servingSize}'),
                                ],
                              ),
                              const Divider(
                                color: Colors.grey,
                                endIndent: 44,
                                indent: 44,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('${'energyInCalories'.tr()} '),
                                  Text(
                                    '${_nutriments.energy} ${_product.nutrimentDataPer}',
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
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('${'fat'.tr()} '),
                                  Text(
                                    '${_nutriments.fatServing}',
                                  ),
                                ],
                              ),
                              // const Divider(
                              //   color: Colors.grey,
                              //   endIndent: 44,
                              //   indent: 44,
                              // ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     Text('${'saturatedFat'.tr()} '),
                              //     Text(
                              //       '${_nutriments.saturatedFat} ${_nutriments.saturatedFatServing}',
                              //     ),
                              //   ],
                              // ),
                              const Divider(
                                color: Colors.grey,
                                endIndent: 44,
                                indent: 44,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('${'sugars'.tr()} '),
                                  Text(
                                    '${_nutriments.sugars} ${_nutriments.sugarsServing}',
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
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('${'proteins'.tr()} '),
                                  Text(
                                    '${_nutriments.proteins} ${_nutriments.proteinsUnit}',
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Colors.grey,
                                endIndent: 44,
                                indent: 44,
                              ),
                            ],
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: Stack(
        children: [
          AppBarcodeScannerWidget.defaultStyle(
            resultCallback: (String code) {
              setState(() {
                _code = code;
              });
            },
          ),
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
