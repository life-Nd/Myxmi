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
        final _instructionsPageView = ref.read(instructionsProvider);
        final _instructions = ref.watch(instructionsProvider);
        _instructions.instructions = instructions!;
        final _checkedInstructions = _instructions.checked;
        final List _keys = _instructions.instructions.toList();
        return PageView.builder(
          itemCount: _keys.length,
          controller: _instructionsPageView.pageController,
          onPageChanged: (int viewIndex) {
            debugPrint('viewIndex: $viewIndex');
            _instructionsPageView.setPageViewIndex(viewIndex);
          },
          itemBuilder: (_, int index) {
            final bool _checked = _checkedInstructions
                .contains(_instructions.instructions[index]);
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
                IconButton(
                  icon: _checked
                      ? const Icon(
                          Icons.check_box,
                          color: Colors.green,
                          size: 44,
                        )
                      : const Icon(
                          Icons.check_box_outline_blank,
                          size: 44,
                        ),
                  onPressed: () {
                    _instructions.toggleInstruction(
                      _instructions.instructions[index].toString(),
                    );
                  },
                ),
                const Spacer(),
              ],
            );
          },
        );
      },
    );
  }
}
