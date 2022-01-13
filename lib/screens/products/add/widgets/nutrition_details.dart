import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/utils/loading_column.dart';
import 'package:myxmi/utils/no_data.dart';
import 'package:openfoodfacts/model/Nutriments.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class NutritionDetails extends StatelessWidget {
  const NutritionDetails({Key? key}) : super(key: key);

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
        final _productScannedProvider = ref.watch(productScannerProvider);
        debugPrint('_NutritionDetailsState initState');
        return FutureBuilder<Product?>(
          future: _getProduct(_productScannedProvider.code),
          builder: (_, AsyncSnapshot<Product?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingColumn();
            }
            if (!snapshot.hasData) {
              return const NoData(
                type: 'product',
              );
            }
            if (snapshot.hasData) {
              final _data = snapshot.data!;
              final Product _product = _data;
              debugPrint('🍅 Product: ${_product.toJson()}');
              final Nutriments _nutriments = _product.nutriments!;
              debugPrint('🧨 Nutriments: ${_nutriments.toJson()}}');
              final String _ingredientsText = _product.ingredientsText ?? '';
              final String _imageUrl = _product.imageFrontUrl!;

              // TODO Show Environemental facts
              _productScannedProvider.productName = _product.productName;
              _productScannedProvider.photoUrl = _imageUrl;
              // _productEntryProvider.type = _product.brands;
              final String _nutriscore = _product.nutriscore ?? '';
              debugPrint('🧽 _imageUrl: $_imageUrl');
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
                              dense: false,
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'NUTRI-SCORE',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              _NutriscoreCard(
                                                letter: 'A',
                                                color: Colors.green,
                                                nutriScore: _nutriscore,
                                              ),
                                              _NutriscoreCard(
                                                letter: 'B',
                                                color: Colors.lightGreen,
                                                nutriScore: _nutriscore,
                                              ),
                                              _NutriscoreCard(
                                                letter: 'C',
                                                color: Colors.yellow,
                                                nutriScore: _nutriscore,
                                              ),
                                              _NutriscoreCard(
                                                letter: 'D',
                                                color: Colors.orange,
                                                nutriScore: _nutriscore,
                                              ),
                                              _NutriscoreCard(
                                                letter: 'E',
                                                color: Colors.deepOrange,
                                                nutriScore: _nutriscore,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const Text('NOVA'),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              _NutriscoreCard(
                                                letter:
                                                    '${_nutriments.novaGroup}',
                                                color: Colors.red,
                                                nutriScore:
                                                    '${_nutriments.novaGroup}',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Card(
                                //   shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(10),
                                //   ),
                                //   margin: const EdgeInsets.all(4),
                                //   child: Row(
                                //     children: [
                                //       if (_product.ecoscoreScore != null)
                                //         const Icon(Icons.device_unknown_sharp)
                                //       else
                                //         const Icon(Icons.device_unknown_sharp),
                                //       const Expanded(
                                //         child: Text(
                                //           'ECO SCORE',
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
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

class _NutriscoreCard extends StatelessWidget {
  final String letter;
  final Color color;
  final String nutriScore;
  const _NutriscoreCard({
    Key? key,
    required this.letter,
    required this.color,
    this.nutriScore = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('nutriScore: $nutriScore');

    final bool _selected = nutriScore.toUpperCase() == letter;

    return Card(
      elevation: _selected ? 20 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: letter == 'A' ? const Radius.circular(10) : Radius.zero,
          topLeft: letter == 'A' ? const Radius.circular(10) : Radius.zero,
          bottomRight: letter == 'E' ? const Radius.circular(10) : Radius.zero,
          topRight: letter == 'E' ? const Radius.circular(10) : Radius.zero,
        ),
      ),
      margin: _selected ? const EdgeInsets.all(4) : EdgeInsets.zero,
      child: Container(
        // margin: _selected ? const EdgeInsets.all(4) : EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: letter == 'A' ? const Radius.circular(10) : Radius.zero,
            topLeft: letter == 'A' ? const Radius.circular(10) : Radius.zero,
            bottomRight:
                letter == 'E' ? const Radius.circular(10) : Radius.zero,
            topRight: letter == 'E' ? const Radius.circular(10) : Radius.zero,
          ),
          color: nutriScore.isNotEmpty ? color : Colors.grey,
        ),
        padding: const EdgeInsets.all(10),
        child: Text(
          letter,
          style: TextStyle(
            color: Colors.white,
            fontSize: _selected ? 44 : 20,
          ),
        ),
      ),
    );
  }
}

final productScannerProvider = ChangeNotifierProvider<ProductScannerProvider>(
  (ref) => ProductScannerProvider(),
);

class ProductScannerProvider extends ChangeNotifier {
  String code = '';
  String? productName;
  String? photoUrl;

  bool enterProductDetails = false;
  bool dataFoundWithCode = false;

  void setCode(String _code) {
    code = _code;
    notifyListeners();
  }

  void changeEnterProductDetails() {
    enterProductDetails = true;
    notifyListeners();
  }

  void reset() {
    code = '';
    productName = '';
    photoUrl = '';
    enterProductDetails = false;
    dataFoundWithCode = false;
    notifyListeners();
  }
}

final scannerFlashProvider = ChangeNotifierProvider<ScannerFlashProvider>(
  (ref) => ScannerFlashProvider(),
);

class ScannerFlashProvider extends ChangeNotifier {
  bool isFlashOn = false;

  void toggleFlash({bool? value}) {
    isFlashOn = value!;
    notifyListeners();
  }
}
