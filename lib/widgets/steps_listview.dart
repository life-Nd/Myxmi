import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StepsListView extends HookWidget {
  final List _checkedSteps = [];
  final List steps;
  StepsListView({this.steps});
  @override
  Widget build(BuildContext context) {
    final _change = useState<bool>(false);
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: steps.length,
          itemBuilder: (_, int index) {
            final _checked = _checkedSteps?.contains(steps[index]);
            return ListTile(
              onTap: () {
                _checked
                    ? _checkedSteps.remove(steps[index])
                    : _checkedSteps.add(steps[index]);
                _change.value = !_change.value;
              },
              leading: IconButton(
                icon: _checked
                    ? const Icon(Icons.check_circle_outline)
                    : const Icon(Icons.radio_button_unchecked),
                onPressed: () {
                  !_checked
                      ? _checkedSteps.add(steps[index])
                      : _checkedSteps.remove(steps[index]);
                  _change.value = !_change.value;
                },
              ),
              title: Text(
                '${steps[index]}',
              ),
            );
          },
        ),
      ],
    );
  }
}
