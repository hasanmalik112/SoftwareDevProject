import 'package:flutter/material.dart';
import 'package:flutter_final_project/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Reset your Password',
    content: 'resetting your password',
    optionsBuilder: () => {
      'ok': null,
    },
  );
}
