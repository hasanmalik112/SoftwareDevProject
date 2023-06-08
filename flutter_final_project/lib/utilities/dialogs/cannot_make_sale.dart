import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<void> showCannotMakeSaleDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Error',
    content: 'cannot make this Sale',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
