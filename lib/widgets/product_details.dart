import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/product.dart';
import '../main.dart';

class ProductDetails extends StatelessWidget {
  final ProductModel product;
  const ProductDetails({@required this.product});

  @override
  Widget build(BuildContext context) {
    final String _name =
        '${product.name[0]?.toUpperCase()}${product.name?.substring(1, product.name?.length)}';
    return Consumer(builder: (_, watch, child) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          dense: true,
          title: Center(child: Text(_name)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(''),
              Text('Type: ${product.ingredientType}'),
              Text('Mesured in: ${product.mesureType}'),
              const Text(''),
              // Text('Quantity in stock: ${product.total} ${product.mesureType}'),
              // Text(
              //     'Expiry Date: ${DateFormat('EEE, MMM d, ' 'yy').format(DateTime.parse(product.expiration))}'),
            ],
          ),
          trailing: EditCartButton(name: product.name),
        ),
      );
    });
  }
}

class EditCartButton extends StatelessWidget {
  const EditCartButton({Key key, this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, watch, __) {
        final _prefs = watch(cartProvider);
        return IconButton(
          icon: _prefs?.cart != null && _prefs.cart.contains(name)
              ? const Icon(
                  Icons.shopping_cart,
                  color: Colors.green,
                )
              : const Icon(
                  Icons.add_shopping_cart,
                  color: Colors.grey,
                ),
          onPressed: () async {
            await _prefs.editCart(name: name);
          },
        );
      },
    );
  }
}
