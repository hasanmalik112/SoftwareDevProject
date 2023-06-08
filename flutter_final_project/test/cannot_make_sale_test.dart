import 'package:flutter/material.dart';
import 'package:flutter_final_project/utilities/dialogs/cannot_make_sale.dart';
import 'package:flutter_final_project/utilities/dialogs/make_sale_dialog.dart';
import 'package:flutter_final_project/utilities/generics/get_arguments.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Show Cannot Make Sale Dialog', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () async {
                await showCannotMakeSaleDialog(context);
              },
              child: const Text('Show Dialog'),
            );
          },
        ),
      ),
    );

    // Tap the button to show the dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Verify the presence of the dialog
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Error'), findsOneWidget);
    expect(find.text('cannot make this Sale'), findsOneWidget);
    expect(find.text('OK'), findsOneWidget);

    // Tap the OK button to dismiss the dialog
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Verify that the dialog is dismissed
    expect(find.byType(AlertDialog), findsNothing);
  });
}
