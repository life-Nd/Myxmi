import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/products/add/add_new_product_view.dart';

class ProductsTypeSelector extends StatelessWidget {
  const ProductsTypeSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 2,
      ),
      children: [
        ProductEntryType(
          type: 'fruit',
          color: Colors.orange.shade300,
        ),
        ProductEntryType(
          type: 'vegetable',
          color: Colors.green.shade300,
        ),
        ProductEntryType(
          type: 'dairy',
          color: Colors.yellow.shade400,
        ),
        ProductEntryType(
          type: 'meat&seafood&alt',
          color: Colors.red.shade100,
        ),
        ProductEntryType(
          type: 'sauces&spices',
          color: Colors.yellow.shade400,
        ),
        ProductEntryType(
          type: 'other',
          color: Colors.grey.shade700,
        ),
      ],
    );
  }
}

class ProductEntryType extends StatelessWidget {
  final String type;
  final Color color;
  const ProductEntryType({
    Key? key,
    required this.type,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _product = ref.watch(productEntryProvider);
        return RawMaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          fillColor: _product.type == type
              ? color
              : Theme.of(context).scaffoldBackgroundColor,
          onPressed: () {
            _product.changeType(type);
          },
          child: Padding(
            padding: const EdgeInsets.only(
              right: 4,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (type != 'other')
                  Expanded(
                    child: Image.asset(
                      'assets/$type.png',
                    ),
                  )
                else
                  const Expanded(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Text(
                        '?',
                        style: TextStyle(fontSize: 80),
                      ),
                    ),
                  ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Text(
                      type.tr(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
