import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/products.dart';
import 'package:myxmi/providers/user.dart';
import 'package:myxmi/screens/products/add/widgets/expiry_date_setter.dart';
import 'package:myxmi/screens/products/add/widgets/mesure_selector.dart';
import 'package:myxmi/screens/products/add/widgets/type_selector.dart';
import 'package:myxmi/utils/image_selector.dart';

final productEntryProvider = ChangeNotifierProvider<ProductEntryProvider>(
  (ref) => ProductEntryProvider(),
);

final TextEditingController _nameCtrl = TextEditingController();
final TextEditingController _quantityCtrl = TextEditingController();

class AddProductManuallyScreen extends StatefulWidget {
  const AddProductManuallyScreen({Key? key}) : super(key: key);

  @override
  State<AddProductManuallyScreen> createState() => _AddProductState();
}

class _AddProductState extends State<AddProductManuallyScreen> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Consumer(
      builder: (_, ref, child) {
        final _user = ref.watch(userProvider);
        final _product = ref.watch(productEntryProvider);
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text('newProduct'.tr()),
            actions: [
              ImageSelector(
                onComplete: () {},
              ),
            ],
          ),
          // TOOD Add Iconbutton to add image of the product
          bottomNavigationBar: _nameCtrl.text.isNotEmpty &&
                  _product.mesureType.isNotEmpty
              ? RawMaterialButton(
                  padding: const EdgeInsets.all(8),
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Colors.green,
                  onPressed: _nameCtrl.text.isNotEmpty &&
                          _product.mesureType.isNotEmpty
                      ? () async {
                          await _product.saveToDb(
                            uid: _user.account?.uid,
                            name: _nameCtrl.text,
                            quantity: _quantityCtrl.text,
                            ingredientType: _product.type!,
                            barcode: '${DateTime.now().millisecondsSinceEpoch}',
                            photoUrl:
                                'https://firebasestorage.googleapis.com/v0/b/myxmi-94982.appspot.com/o/file-unknown.png?alt=media&token=1ad45eb7-b8a2-4bab-aacb-eb77dfb88e34',
                          );
                          _nameCtrl.clear();
                          _quantityCtrl.clear();
                          if (!mounted) return;
                          Navigator.of(context).pop();
                        }
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                'fieldsEmpty'.tr(),
                              ),
                            ),
                          );
                        },
                  child: Text('save'.tr()),
                )
              : const Text(''),
          body: SizedBox(
            height: _size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    dense: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      'enterProductName'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    subtitle: _product.explainAccess
                        ? Text(
                            'youCanSaveProducts'.tr(),
                          )
                        : null,
                    trailing: IconButton(
                      icon: Icon(
                        _product.explainAccess ? Icons.close : Icons.help,
                        color:
                            _product.explainAccess ? Colors.red : Colors.grey,
                        size: 30,
                      ),
                      onPressed: () {
                        _product.changeExplainAccess();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60, right: 60),
                    child: TextField(
                      controller: _nameCtrl,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'productName'.tr(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  ListTile(
                    dense: true,
                    title: Text(
                      'productType'.tr(),
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const ProductsTypeSelector(),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    dense: true,
                    title: Text(
                      'mesuredIn'.tr(),
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const MesureTypeSetter(),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class QuantityEntry extends StatelessWidget {
  const QuantityEntry({
    Key? key,
    required this.ctrl,
  }) : super(key: key);
  final TextEditingController ctrl;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _product = ref.watch(productEntryProvider);
        return Column(
          children: [
            ListTile(
              dense: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: SingleChildScrollView(
                child: Text(
                  '${'quantityOnHand'.tr()} (${'optional'.tr()})',
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  _product.explainQuantity ? Icons.close : Icons.help,
                  color: _product.explainQuantity ? Colors.red : Colors.grey,
                  size: 30,
                ),
                onPressed: () {
                  _product.changeExplainQuantity();
                },
              ),
              subtitle: _product.explainQuantity
                  ? Text('enterTotalQuantity'.tr())
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60, right: 60),
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                controller: ctrl,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: _product.mesureType,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ExpirationEntry extends StatelessWidget {
  const ExpirationEntry({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _product = ref.watch(productEntryProvider);
        return Column(
          children: [
            ListTile(
              dense: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${'selectExpirationDate'.tr()} (${'optional'.tr()})',
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(
                  _product.explainExpiration ? Icons.close : Icons.help,
                  color: _product.explainExpiration ? Colors.red : Colors.grey,
                  size: 30,
                ),
                onPressed: () {
                  _product.changeExplainExpiration();
                },
              ),
              subtitle: _product.explainExpiration
                  ? Text('expirationDate'.tr())
                  : null,
            ),
            const ExpiryDateSetter(),
          ],
        );
      },
    );
  }
}
