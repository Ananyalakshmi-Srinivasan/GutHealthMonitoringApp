import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guthealth_app/screens/journal.dart';

void main() {
  group('JournalPage Tests', () {
    testWidgets('shows passed journal text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: JournalPage(journal: 'I felt calm and relaxed today'),
        ),
      );

      expect(find.text('Journal'), findsOneWidget);
      expect(find.text('I felt calm and relaxed today'), findsOneWidget);
    });

    testWidgets('shows fallback text when journal is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: JournalPage(journal: ''),
        ),
      );

      expect(find.text('Journal'), findsOneWidget);
      expect(find.text('No journal for this day.'), findsOneWidget);
    });
  });

}