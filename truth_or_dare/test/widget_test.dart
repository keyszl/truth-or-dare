// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truth_or_dare/firstscreen.dart';
import 'package:truth_or_dare/main.dart';
import 'package:truth_or_dare/secondscreen.dart';

void main() {
  testWidgets('presence of screen1', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainScreen()));
    expect(find.byType(MainScreen), findsOneWidget);
  });
  testWidgets(
      'Presence of both icons on the botton bar and navigation to second screen ',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainScreen()));
    expect(find.byKey(const Key('iconhome')), findsNWidgets(1));
    expect(find.byKey(const Key('iconcontacts')), findsOneWidget);
    await tester.tap(find.byKey(const Key('iconcontacts')));
    await tester.pump();
    //await tester.tap(find.byKey(Key('iconcontacts')));
    await tester.pump();
    expect(find.byType(MainScreen), findsOneWidget);
  });

  //   testWidgets('Contacts IconButton on Home screen goes to contacts screen',
  //     (tester) async {
  //   await tester.pumpWidget(const MaterialApp(home: MainScreen()));
  //   expect(find.byKey(Key('iconbutton1')), findsNWidgets(1));
  //   expect(find.byKey(Key('iconbutton2')), findsNWidgets(1));
  //   await tester.tap(find.byKey(Key('iconbutton2')));
  //   await tester.pump();
  //   await tester.pump();
  //   expect(find.byType(ContactsScreen), findsOneWidget);
  // });
}
