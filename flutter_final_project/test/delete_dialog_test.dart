import 'package:flutter/material.dart';
import 'package:flutter_final_project/utilities/dialogs/delete_dialog.dart';
import 'package:flutter_final_project/utilities/dialogs/generic_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Show Delete Dialog', (WidgetTester tester) async {
    bool? dialogResult;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () async {
                final result = await showDeleteDialog(context);
                dialogResult = result;
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
    expect(find.text('Delete Item'), findsOneWidget);
    expect(find.text('Delete this Item?'), findsOneWidget);
    expect(find.text('cancel'), findsOneWidget);
    expect(find.text('yes'), findsOneWidget);

    // Tap the 'yes' button to confirm deletion
    await tester.tap(find.text('yes'));
    await tester.pumpAndSettle();

    // Verify that the dialog is dismissed and the result is true
    expect(find.byType(AlertDialog), findsNothing);
    expect(dialogResult, equals(true));
  });
}
