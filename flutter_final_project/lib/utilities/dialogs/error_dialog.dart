import 'package:flutter/material.dart';
import 'package:flutter_final_project/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: "Generic Error",
    content: text,
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
