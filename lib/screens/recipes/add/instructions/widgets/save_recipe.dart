import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/image.dart';
import 'package:myxmi/providers/recipe_entries.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/providers/user.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

int value = 0;

class SaveButton extends StatefulWidget {
  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context: context);

    return Consumer(
      builder: (_, ref, child) {
        final _recipe = ref.watch(recipeEntriesProvider);
        final _image = ref.watch(imageProvider);
        final _user = ref.watch(userProvider);
        final _router = ref.watch(routerProvider);
        return RawMaterialButton(
          onPressed: _recipe.recipe.title != null
              ? () async {
                  _recipe.recipe.uid = _user.account!.uid;
                  _recipe.recipe.username = _user.account!.displayName;
                  _recipe.recipe.userphoto = _user.account!.photoURL;
                  pr.show(
                    max: 100,
                    msg: '${'loading'.tr()} ',
                  );
                  if (_image.state != AppState.empty) {
                    debugPrint('image is not empty');

                    pr.update(
                      value: 0,
                      msg: '${'uploading'.tr()} ${'image'.tr()}...',
                    );
                    await _image.addImageToDb(context: context).then(
                      (data) {
                        pr.update(
                          value: 20,
                          msg: '${'image'.tr()} ${'uploaded'.tr()} ✅',
                        );
                        _recipe.recipe.imageUrl =
                            _image.imageUrl.isNotEmpty ? _image.imageUrl : null;
                      },
                    );
                  }
                  pr.update(value: value++);
                  pr.update(
                    value: 40,
                    msg: '${'uploading'.tr()} ${'recipe'.tr()}...',
                  );
                  await _recipe.saveRecipeToDb();
                  pr.update(
                    value: 60,
                    msg: '${'ingredients'.tr()} ${'uploaded'.tr()} ✅',
                  );
                  await _recipe.saveDetailsToDb();
                  pr.update(
                    value: 80,
                    msg: '${'uploading'.tr()} ${'instructions'.tr()}...',
                  );
                  await _recipe.savePrivateInstructionsToDb();
                  pr.update(
                    value: 100,
                    msg: '${'instructions'.tr()} ${'uploaded'.tr()} ✅',
                  );
                  _image.reset();
                  _recipe.reset();
                  pr.close();
                  if (!mounted) return;
                  _router.pushPage(
                    name: '/home',
                  );
                }
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('fieldsEmpty'.tr()),
                    ),
                  );
                },
          child: Text(
            'save'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        );
      },
    );
  }
}
