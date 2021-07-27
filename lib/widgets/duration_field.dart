import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:easy_localization/easy_localization.dart';

class DurationField extends StatefulWidget {
  const DurationField({
    Key key,
  }) : super(key: key);
  @override
  State createState() => _DurationFieldState();
}

class _DurationFieldState extends State<DurationField> {
  TextEditingController _durationCtrl = TextEditingController();
  @override
  void initState() {
    _durationCtrl = TextEditingController();
    super.initState();
  }

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
