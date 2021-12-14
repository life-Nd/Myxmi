import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/instructions.dart';

class InstructionsListView extends StatelessWidget {
  final List? instructions;
  const InstructionsListView({Key? key, required this.instructions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _instructions = ref.watch(instructionsProvider);
        _instructions.instructions = instructions!;
        final _checkedInstructions = _instructions.checked;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _instructions.instructions.length,
          itemBuilder: (_, int index) {
            final bool _checked = _checkedInstructions
                .contains(_instructions.instructions[index]);
            return Column(
              children: [
                if (_instructions.instructions[index] != '')
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          _instructions.toggleInstruction(
                            _instructions.instructions[index].toString(),
                          );
                        },
                        leading: IconButton(
                          icon: _checked
                              ? const Icon(Icons.check_circle_outline)
                              : const Icon(Icons.radio_button_unchecked),
                          onPressed: () {
                            _instructions.toggleInstruction(
                              _instructions.instructions[index].toString(),
                            );
                          },
                        ),
                        title: Text(
                          '${_instructions.instructions[index]}',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
