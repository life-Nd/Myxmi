import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/recipe_entries.dart';

class DurationField extends StatelessWidget {
  const DurationField({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 60, right: 60),
            child: Consumer(
              builder: (_, ref, child) {
                final _recipe = ref.watch(recipeEntriesProvider);
                return TextField(
                  controller: _recipe.durationCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: true,
                    decimal: true,
                  ),
                  onChanged: (value) {
                    _recipe.setDuration();
                  },
                  onSubmitted: (submitted) {
                    _recipe.setDuration();
                    if (!kIsWeb) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
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
              },
            ),
          ),
        ),
      ],
    );
  }
}
