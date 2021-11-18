// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:myxmi/models/product.dart';
// import 'package:myxmi/views/products/add/views.dart';
// import 'read/products_list.dart';
// import 'read/widgets/auto_complete_products.dart';
// import 'read/widgets/cart_button.dart';

// TextEditingController _searchProductsCtrl = TextEditingController();

// class ProductsView extends StatelessWidget {
//   final List<ProductModel> products;
//   final String type;
//   const ProductsView({
//     Key key,
//     @required this.products,
//     @required this.type,
//   }) : super(key: key);

//   List<ProductModel> _filterProducts() {
//     final List<ProductModel> _filteredProducts = [];
//     final Iterable _filter = products.asMap().entries.where((entry) {
//       return entry.value.toMap().containsValue(
//             _searchProductsCtrl.text.trim().toLowerCase(),
//           );
//     });
//     final _filtered = Map.fromEntries(_filter as Iterable<MapEntry>);
//     _filtered.forEach((key, value) {
//       _filteredProducts.add(value as ProductModel);
//     });
//     return _filteredProducts;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StatefulBuilder(
//       builder: (context, StateSetter stateSetter) {
//         return Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: AutoCompleteProducts(
//                       suggestions: products,
//                       controller: _searchProductsCtrl,
//                       onSubmit: () {
//                         // _filteredProducts.clear();
//                         stateSetter(() {});
//                       },
//                       onClear: () {
//                         _filterProducts().clear();
//                         _searchProductsCtrl.clear();
//                         stateSetter(() {});
//                       }),
//                 ),
//                 if (type == 'AddProcuctsToRecipe')
//                   Center(
//                     child: IconButton(
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (_) => AddNewProduct(),
//                           ),
//                         );
//                       },
//                       tooltip: 'addProduct'.tr(),
//                       icon: const Icon(
//                         Icons.add_circle,
//                         color: Colors.green,
//                         size: 40,
//                       ),
//                     ),
//                   )
//                 else
//                   const CartButton()
//               ],
//             ),
//             const SizedBox(
//               height: 4,
//             ),
//             Expanded(
//               child: ProductsList(
//                 products: _searchProductsCtrl.text.isEmpty
//                     ? products
//                     : _filterProducts(),
//                 type: type,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
