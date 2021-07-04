import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myxmi/app.dart';
import 'package:myxmi/screens/add_product.dart';

class EditProducts extends HookWidget {
  final Map data;
  final String indexKey;
  EditProducts({@required this.data, @required this.indexKey});

  Widget build(BuildContext context) {
    final _prefs = useProvider(prefProvider);
    final _change = useState<bool>(false);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => NewProduct(),
          ));
        },
        title: Center(child: Text('${data['Name']}')),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$indexKey'),
            Text('Type: ${data['IngredientType']}'),
            Text('Mesured in: ${data['MesureType']}'),
            Text('Quantity in stock: ${data['Total']} ${data['MesureType']}'),
            Text(
                'Expiry Date: ${DateFormat('EEE, MMM d, ' 'yy').format(DateTime.parse(data['Expiration']))}'),
          ],
        ),
        trailing: IconButton(
            icon: !_prefs.cart.contains(data['Name'])
                ? Icon(
                    Icons.add_shopping_cart,
                    color: Colors.grey,
                  )
                : Icon(
                    Icons.shopping_cart,
                    color: Colors.green,
                  ),
            onPressed: () async {
              await _prefs.editCart(name: '${data['Name']}');
              _change.value = !_change.value;
            }),
      ),
    );
  }
}
