import 'package:flutter/material.dart';
import 'package:flutter_final_project/utilities/dialogs/generic_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Show Generic Dialog', (WidgetTester tester) async {
    bool dialogClosed = false;
    String? selectedOption;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () async {
                final result = await showGenericDialog<String>(
                  context: context,
                  title: 'Test Dialog',
                  content: 'This is a test dialog',
                  optionsBuilder: () => {
                    'Option 1': 'Value 1',
                    'Option 2': 'Value 2',
                  },
                );
                dialogClosed = true;
                selectedOption = result;
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
    expect(find.text('Test Dialog'), findsOneWidget);
    expect(find.text('This is a test dialog'), findsOneWidget);
    expect(find.text('Option 1'), findsOneWidget);
    expect(find.text('Option 2'), findsOneWidget);

    // Tap the 'Option 1' button to select it
    await tester.tap(find.text('Option 1'));
    await tester.pumpAndSettle();

    // Verify that the dialog is dismissed and the correct option is returned
    expect(find.byType(AlertDialog), findsNothing);
    expect(dialogClosed, equals(true));
    expect(selectedOption, equals('Value 1'));
  });
}
