import 'package:flutter/material.dart';
import 'package:flutter_final_project/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete?',
    content: 'Are you sure you want to delte this?',
    optionsBuilder: () => {
      'cancel': false,
      'yes': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
