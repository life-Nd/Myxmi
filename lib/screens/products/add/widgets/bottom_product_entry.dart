import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/image.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/providers/user.dart';
import 'package:myxmi/screens/products/add/add_product_manually.dart';
import 'package:myxmi/screens/products/add/widgets/nutrition_details.dart';

final TextEditingController _quantityCtrl = TextEditingController();

class BottomSheetProductEntry extends StatelessWidget {
  const BottomSheetProductEntry({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _router = ref.watch(routerProvider);
        final _product = ref.watch(productEntryProvider);
        final _productScannedProvider = ref.watch(productScannerProvider);
        final _image = ref.watch(imageProvider);
        final _productName = _productScannedProvider.productName;
        final _photoUrl = _productScannedProvider.photoUrl;
        final _user = ref.watch(userProvider);
        if (_productScannedProvider.enterProductDetails) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QuantityEntry(
                ctrl: _quantityCtrl,
              ),
              const SizedBox(
                width: 4,
              ),
              const ExpirationEntry(),
              const SizedBox(
                width: 4,
              ),
              Consumer(
                builder: (_, ref, child) {
                  final _productScanner = ref.read(productScannerProvider);
                  final _code = _productScanner.code;
                  return RawMaterialButton(
                    onPressed: () async {
                      debugPrint(_user.account?.uid);
                      debugPrint(_productName);
                      debugPrint(_quantityCtrl.text);
                      debugPrint(_code);
                      debugPrint(_photoUrl);
                      await _image.fileFromImageUrl(
                        imageName: _productName!,
                        imageUrl: _photoUrl!,
                      );
                      final String? _firestoreUrl =
                          await _image.addImageToDb(context: context);
                      await _product.saveToDb(
                        uid: _user.account?.uid,
                        name: _productName,
                        quantity: _quantityCtrl.text,
                        ingredientType: 'other',
                        barcode: _code,
                        photoUrl: _firestoreUrl!,
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
                  );
                },
              ),
            ],
          );
        }
        return const Text('');
      },
    );
  }
}
