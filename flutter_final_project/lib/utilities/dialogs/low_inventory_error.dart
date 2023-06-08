import 'package:flutter/material.dart';
import 'package:flutter_final_project/utilities/dialogs/generic_dialog.dart';

Future<void> showLowInventoryDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Low Inventory',
    content: 'please Refill Your Inventory',
    optionsBuilder: () => {
      'ok': null,
    },
  );
}
