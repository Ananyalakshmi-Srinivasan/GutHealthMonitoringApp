import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guthealth_app/screens/home_screen.dart';
import 'package:guthealth_app/screens/mood_log.dart';
import 'package:guthealth_app/screens/calendar_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:guthealth_app/screens/journal.dart';



void main() {

  //calendar tests
  group('Calendar Tests', () {
    //check everything exists
    testWidgets('Calendar UI exists',(WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CalendarScreen(customerId: 1),
        ),
      );
      expect(find.byType(TableCalendar), findsOneWidget);
      expect(find.text('Mood'), findsOneWidget);
      expect(find.text('View Symptom Log'), findsOneWidget);
      expect(find.byKey(const Key('mood_emoji')), findsOneWidget);
    });
      

    //mood emoji shows correctly
    testWidgets('emoji correct', (tester) async {
      await tester.pumpWidget(
          const MaterialApp(
              home: CalendarScreen(customerId: 1)
          ));

      final emojiWidget = tester.widget<Text>(find.byKey(const Key('mood_emoji')));

      final emojiText = emojiWidget.data;
      expect(emojiText, isNotNull);
      expect(emojiText!.isNotEmpty, isTrue);


      // all the emoji must from the list
      expect(allEmotions.any((e) => e.emoji == emojiText), isTrue);
    });

    //select certain day will update emoji
    testWidgets('updates selected day (refresh happens)', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarScreen(customerId: 1)));

      final newDay = DateTime(2026, 2, 15);

      final tableBefore = tester.widget<TableCalendar>(find.byType(TableCalendar));
      tableBefore.onDaySelected?.call(newDay, newDay);
      await tester.pump();
      final tableAfter = tester.widget<TableCalendar>(find.byType(TableCalendar));
      expect(tableAfter.selectedDayPredicate?.call(newDay), isTrue);

      expect(find.byKey(const Key('mood_emoji')), findsOneWidget);
    });

    //test home bottom can navigate home page
    testWidgets('home navigation to home', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CalendarScreen(customerId: 1),
        ),
      );
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('View Journal navigates to JournalPage', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CalendarScreen(journal: 'My journal text',customerId: 1),
        ),
      );

      await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'View Journal'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'View Journal'));
      await tester.pumpAndSettle(); // ← 加这一行
      expect(find.byType(JournalPage), findsOneWidget);

      expect(find.byType(JournalPage), findsOneWidget);
      expect(find.text('My journal text'), findsOneWidget);
    });

    testWidgets('empty journal shows default text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CalendarScreen(customerId: 1),
        ),
      );

      await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'View Journal'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'View Journal'));
      await tester.pumpAndSettle(); // ← 加这一行
      expect(find.byType(JournalPage), findsOneWidget);

      expect(find.byType(JournalPage), findsOneWidget);
      expect(find.text('No journal for this day.'), findsOneWidget);
    });
  });

}

