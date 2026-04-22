import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guthealth_app/screens/mood_log.dart';
import 'package:guthealth_app/screens/calendar_screen.dart';
import 'package:guthealth_app/screens/journal.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
//mood log tests
  group('Moodlog Tests', () {
// make sure ui exist
    testWidgets('Mood Log UI exists', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EmotionSearchPage(customerId: 1),
        ),
      );

      //include journal text field
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('All Moods'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
      expect(find.text('Happy'), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
      expect(find.text('Selected Moods'), findsNothing);

      //select mood not show in defalut setting
      expect(find.text('Selected Moods'), findsNothing);

    });


//make sure the search bar works
    testWidgets('Mood Log search works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EmotionSearchPage(customerId: 1),
        ),
      );
      expect(find.text('Happy'), findsOneWidget);
      await tester.enterText(find.byType(TextField).first, '  SAD  ');
      await tester.pump();
      expect(find.text('Sad'), findsOneWidget);
      expect(find.text('Happy'), findsNothing);
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();
      expect(find.text('Happy'), findsOneWidget);
    });

    testWidgets('journal input works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EmotionSearchPage(customerId: 1),
        ),
      );

      await tester.drag(find.byType(ListView).first, const Offset(0, -600));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'Today I feel much better');
      await tester.pump();

      expect(find.text('Today I feel much better'), findsOneWidget);
    });

    //test select and cancel mood works
    testWidgets('mood select and cancel works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EmotionSearchPage(customerId: 1),
        ),
      );
      expect(find.text('Selected Moods'), findsNothing);
      //select happy after click
      await tester.tap(find.text('Happy'));
      await tester.pumpAndSettle();
      expect(find.text('Selected Moods'), findsOneWidget);
      final selectedHappyEmoji = find.byWidgetPredicate((w) {
        return w is Text && w.data == '😄' && w.style?.fontSize == 28;
      });
      expect(selectedHappyEmoji, findsOneWidget);
      //cancel
      await tester.tap(find.text('Happy'));
      await tester.pump();
      expect(find.text('Selected Moods'), findsNothing);
    });

    testWidgets('Continue without selecting mood shows snackbar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EmotionSearchPage(customerId: 1),
        ),
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
      await tester.pump();

      expect(find.text('Please select at least one mood'), findsOneWidget);
      expect(find.byType(CalendarScreen), findsNothing);
    });


    //test continue can navigate to calendar page
    testWidgets('Continue navigate to calendar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EmotionSearchPage(customerId: 1),
        ),
      );

      await tester.tap(find.text('Happy'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
      await tester.pumpAndSettle();

      expect(find.byType(TableCalendar), findsOneWidget);

    });

    testWidgets('journal is passed from mood log to journal page', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EmotionSearchPage(customerId: 1),
        ),
      );

      await tester.tap(find.text('Happy'));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView).first, const Offset(0, -600));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'Today was a good day');
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
      await tester.pumpAndSettle();

      expect(find.byType(CalendarScreen), findsOneWidget);

      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -300));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'View Journal'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'View Journal'));
      await tester.pumpAndSettle(); // ← 加这一行
      expect(find.byType(JournalPage), findsOneWidget);

      expect(find.byType(JournalPage), findsOneWidget);
      expect(find.text('Today was a good day'), findsOneWidget);
    });
  });
}
