// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lear_task/AppComponents/rounded_button.dart';

import 'package:lear_task/main.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows building and interacting
  // with widgets in the test environment.
  testWidgets('MyWidget has a title and message', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget( RoundedButton(text: "text",
        isLoading: true,
        enabled: true,
        press: (){},
        color: Colors.white,
        textColor: Colors.black,
        width: 12,
        cornerRadius: 2,
        height: 20));
    // Create the Finders.
    final titleFinder = find.text('text');
    final messageFinder = find.text('text');
    expect(titleFinder, 3);
    expect(messageFinder, findsOneWidget);
  });
}
