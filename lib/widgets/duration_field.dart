import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/create_recipe.dart';
import 'package:easy_localization/easy_localization.dart';

final TextEditingController _durationCtrl = TextEditingController();

class DurationField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 60, right: 60),
            child: Consumer(builder: (_, watch, child) {
              final _recipe = watch(recipeProvider);
              return TextField(
                controller: _durationCtrl,
                keyboardType: TextInputType.number,
                onSubmitted: (submitted) {
                  _recipe.changeDuration(newDuration: _durationCtrl.text);
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.timer),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'time'.tr(),
                  suffixText: 'min',
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
