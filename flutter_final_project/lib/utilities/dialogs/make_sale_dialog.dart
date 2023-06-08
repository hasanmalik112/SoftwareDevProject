import 'package:flutter/material.dart';
import 'package:flutter_final_project/utilities/dialogs/generic_dialog.dart';

Future<bool> showMakeSaleDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Make Sell',
    content: 'Cofirm Sell?',
    optionsBuilder: () => {
      'cancel': false,
      'yes': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
