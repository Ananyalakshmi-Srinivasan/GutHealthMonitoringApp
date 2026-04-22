import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guthealth_app/screens/calendar_screen.dart';
import 'package:guthealth_app/screens/home_screen.dart';
import 'package:guthealth_app/screens/mood_log.dart';
import 'package:guthealth_app/screens/past_data_screen.dart';
import 'package:guthealth_app/screens/recipe_screen.dart';
import 'package:guthealth_app/screens/survey_screen.dart';

void main() {
  group('HomeScreen widget tests', () {
    testWidgets('renders expected home UI blocks', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen(customerId: 1)));

      expect(find.text('Welcome user'), findsOneWidget);
      expect(find.text('Log Symptoms'), findsOneWidget);
      expect(find.text('Mood Log'), findsOneWidget);
      expect(find.text('Recipes'), findsOneWidget);
      expect(find.text('Past data'), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
    });

    testWidgets('tapping Log Symptoms opens SurveyScreen',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: HomeScreen(customerId: 1)));

          await tester.tap(find.text('Log Symptoms'));
          await tester.pumpAndSettle();

          expect(find.byType(SurveyScreen), findsOneWidget);
        });

    testWidgets('tapping Mood Log opens EmotionSearchPage',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: HomeScreen(customerId: 1)));

          await tester.tap(find.text('Mood Log'));
          await tester.pumpAndSettle();

          expect(find.byType(EmotionSearchPage), findsOneWidget);
        });

    testWidgets('tapping Past data opens PastDataScreen',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: HomeScreen(customerId: 1)));

          await tester.tap(find.text('Past data'));
          await tester.pumpAndSettle();

          expect(find.byType(PastDataScreen), findsOneWidget);
        });

    testWidgets('bottom nav Calendar opens CalendarScreen',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: HomeScreen(customerId: 1)));

          await tester.tap(find.text('Calendar'));
          await tester.pumpAndSettle();

          expect(find.byType(CalendarScreen), findsOneWidget);
        });

    testWidgets('tapping Recipes opens RecipeScreen',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: HomeScreen(customerId: 1)));

          await tester.tap(find.text('Recipes'));
          await tester.pumpAndSettle();

          expect(find.byType(RecipesScreen), findsOneWidget);
        });
  });
}