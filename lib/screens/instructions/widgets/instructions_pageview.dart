import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/instructions.dart';

class InstructionsPageView extends StatelessWidget {
  final List? instructions;
  const InstructionsPageView({Key? key, required this.instructions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _instructions = ref.watch(instructionsProvider);
        _instructions.instructions = instructions!;
        final _checkedInstructions = _instructions.checked;
        final List _keys = _instructions.instructions.toList();
        return PageView.builder(
          itemCount: _keys.length,
          itemBuilder: (_, int index) {
            final _checked = _checkedInstructions.contains(_keys[index]);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                if (_instructions.instructions[index] != '')
                  Card(
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          '${_instructions.instructions[index]}',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                const Spacer(),
                RawMaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Colors.green,
                  onPressed: () {
                    _instructions.toggleInstruction(
                      _instructions.instructions[index].toString(),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _checked
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                        ),
                        Text(
                          _checked ? '${'uncheck'} ' : '${'check'.tr()} ',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RawMaterialButton(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                    Text(
                      '${index + 1}/${_keys.length}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        index += 1;
                      },
                      child: Text(
                        'next'.tr(),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
