import 'package:flutter/material.dart';
import 'package:flutter_final_project/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Logout Button",
    content: 'Do you want to logout?',
    optionsBuilder: () => {
      'cancel': false,
      'logout_button': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
