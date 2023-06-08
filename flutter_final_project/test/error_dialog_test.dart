import 'package:flutter/material.dart';
import 'package:flutter_final_project/utilities/dialogs/error_dialog.dart';
import 'package:flutter_final_project/utilities/dialogs/generic_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Show Error Dialog', (WidgetTester tester) async {
    bool dialogClosed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () async {
                await showErrorDialog(context, 'This is an error message');
                dialogClosed = true;
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
    expect(find.text('Generic Error'), findsOneWidget);
    expect(find.text('This is an error message'), findsOneWidget);
    expect(find.text('Ok'), findsOneWidget);

    // Tap the 'Ok' button to close the dialog
    await tester.tap(find.text('Ok'));
    await tester.pumpAndSettle();

    // Verify that the dialog is dismissed
    expect(find.byType(AlertDialog), findsNothing);
    expect(dialogClosed, equals(true));
  });
}
