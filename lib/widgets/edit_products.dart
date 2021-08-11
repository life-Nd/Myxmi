import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myxmi/models/product.dart';
import '../main.dart';

class EditProducts extends StatelessWidget {
  final ProductModel product;
  const EditProducts({@required this.product});

  @override
  Widget build(BuildContext context) {
    debugPrint('product?.name: ${product?.name}');
    final String _title =
        '${product.name[0]?.toUpperCase()}${product.name?.substring(1, product.name?.length)}';
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        // TODO change the first letter of the title to a capital letter
        title: Center(child: Text(_title)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${product.ingredientType}'),
            Text('Mesured in: ${product.mesureType}'),
            Text('Quantity in stock: ${product.total} ${product.mesureType}'),
            Text(
                'Expiry Date: ${DateFormat('EEE, MMM d, ' 'yy').format(DateTime.parse(product.expiration))}'),
          ],
        ),
        trailing: Consumer(builder: (_, watch, __) {
          final _prefs = watch(prefProvider);
          return IconButton(
              icon: _prefs?.cart != null && _prefs.cart.contains(product.name)
                  ? const Icon(
                      Icons.shopping_cart,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.grey,
                    ),
              onPressed: () async {
                await _prefs.editCart(name: product.name);
              });
        }),
      ),
    );
  }
}
