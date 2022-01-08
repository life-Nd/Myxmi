import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/products/add/add_product_manually.dart';
import 'package:openfoodfacts/model/Nutriments.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class NutritionDetails extends StatefulWidget {
  final String? code;

  const NutritionDetails({Key? key, this.code}) : super(key: key);

  @override
  State<NutritionDetails> createState() => _NutritionDetailsState();
}

class _NutritionDetailsState extends State<NutritionDetails> {
  Future<Product?>? getProduct;
  @override
  void initState() {
    getProduct = _getProduct(widget.code!);
    super.initState();
  }

  Future<Product?> _getProduct(String code) async {
    final ProductQueryConfiguration _configuration = ProductQueryConfiguration(
      code,
      language: OpenFoodFactsLanguage.ENGLISH,
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

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, watch) {
        final _productScannedProvider = ref.watch(productScannedProvider);
        final _productEntryProvider = ref.watch(productEntryProvider);
        return FutureBuilder<Product?>(
          future: getProduct,
          builder: (_, AsyncSnapshot<Product?> snapshot) {
            if (snapshot.hasData) {
              final _data = snapshot.data!;
              final Product _product = _data;
              debugPrint('🍅 Product: ${_product.toJson()}');
              final Nutriments _nutriments = _product.nutriments!;
              debugPrint('🧨 Nutriments: ${_nutriments.toJson()}}');
              // debugPrint('🙂  Details: ${_product.}');
              final String _ingredientsText = _product.ingredientsText ?? '';
              final String _imageUrl = _product.images![0].url!;
              // TODO Show Environemental facts
              _productScannedProvider.code = widget.code;
              _productScannedProvider.productName = _product.productName;
              _productScannedProvider.photoUrl = _imageUrl;
              _productEntryProvider.type = _product.brands;
              final CachedNetworkImage _image = CachedNetworkImage(
                imageUrl: _imageUrl,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              );
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
                              contentPadding: const EdgeInsets.all(1),
                              leading: _image,
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  endIndent: 44,
                                  indent: 44,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${'energyInCalories'.tr()} ',
                                      ),
                                      Text(
                                        '${_nutriments.energyKcal} ${_nutriments.energyKcalUnit.toString().split('.').last}',
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  endIndent: 44,
                                  indent: 44,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${'fat'.tr()} '),
                                      Text(
                                        '${_nutriments.fat} ${_nutriments.fatUnit.toString().split('.').last}',
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  endIndent: 44,
                                  indent: 44,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${'saturatedFat'.tr()} ',
                                      ),
                                      Text(
                                        '${_nutriments.saturatedFat} ${_nutriments.fatUnit.toString().split('.').last}',
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  endIndent: 44,
                                  indent: 44,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'carboHydrates',
                                      ),
                                      Text(
                                        '${_nutriments.proteins} ${_nutriments.proteinsUnit.toString().split('.').last}',
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  endIndent: 44,
                                  indent: 44,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${'sugars'.tr()} ',
                                      ),
                                      Text(
                                        '${_nutriments.sugars} g',
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  endIndent: 44,
                                  indent: 44,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${'proteins'.tr()} ',
                                      ),
                                      Text(
                                        '${_nutriments.proteins} ${_nutriments.proteinsUnit.toString().split('.').last}',
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  endIndent: 44,
                                  indent: 44,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${'salt'.tr()} '),
                                      Text(
                                        '${_nutriments.salt} ${_nutriments.saltServing}',
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  endIndent: 44,
                                  indent: 44,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${'sodium'.tr()} ',
                                      ),
                                      Text(
                                        '${_nutriments.sodium} ${_nutriments.sodiumUnit.toString().split('.').last}',
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  endIndent: 44,
                                  indent: 44,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${'alcohol'.tr()} ',
                                      ),
                                      Text(
                                        '${_nutriments.alcohol} ${_nutriments.alcoholUnit.toString().split('.').last}',
                                      ),
                                    ],
                                  ),
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
                              padding: const EdgeInsets.all(8.0),
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
        );
      },
    );
  }
}

final productScannedProvider = Provider<ProductScannedFromApiProvider>(
  (ref) => ProductScannedFromApiProvider(),
);

class ProductScannedFromApiProvider {
  String? code;
  String? productName;
  String? photoUrl;
  bool enterProductDetails = false;
  bool dataFoundWithCode = false;
}