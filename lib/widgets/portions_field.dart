import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:easy_localization/easy_localization.dart';

class PortionsField extends StatefulWidget {
  const PortionsField({
    Key key,
  }) : super(key: key);
  @override
  _PortionsFieldState createState() => _PortionsFieldState();
}

class _PortionsFieldState extends State<PortionsField> {
  TextEditingController _portionsCtrl = TextEditingController();

  @override
  void initState() {
    _portionsCtrl = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 100, right: 100),
            child: Consumer(builder: (_, watch, child) {
              final _recipe = watch(recipeProvider);
              return TextField(
                controller: _portionsCtrl,
                keyboardType: TextInputType.number,
                onSubmitted: (submitted) {
                  _recipe.changePortions(newPortions: _portionsCtrl.text);
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.local_pizza_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'portions'.tr(),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
