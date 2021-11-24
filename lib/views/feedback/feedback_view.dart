import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/streams/feedbacks.dart';
import 'widgets/experience_selector.dart';
import 'widgets/experience_textfield.dart';

class FeedbackView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('feedback'.tr()),
      ),
      body: Consumer(
        builder: (_, watch, child) {
          return const StreamFeedbackBuilder();
        },
      ),
      extendBody: true,
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          ExperiencesSelector(),
          ExperienceTextfield(),
        ],
      ),
    );
  }
}
