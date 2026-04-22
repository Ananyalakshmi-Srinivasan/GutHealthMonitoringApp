import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guthealth_app/screens/home_screen.dart';
import 'package:guthealth_app/screens/survey_screen.dart';

void main() {
  group('SurveyScreen widget tests', () {
    testWidgets('renders first question and controls',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: SurveyScreen(customerId: 1)));

          expect(find.text('Ferrocalm Survey'), findsOneWidget);
          expect(find.text('Loose stool'), findsOneWidget);
          expect(find.textContaining('On a scale of 0 to 10'), findsOneWidget);
          expect(find.byType(LinearProgressIndicator), findsOneWidget);
          expect(find.byType(Slider), findsOneWidget);
          expect(find.text('Symptom Description'), findsOneWidget);
          expect(find.text('Next'), findsOneWidget);
        });

    testWidgets('opens and closes symptom description dialog',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: SurveyScreen(customerId: 1)));

          await tester.tap(find.text('Symptom Description'));
          await tester.pumpAndSettle();

          expect(find.byType(AlertDialog), findsOneWidget);
          expect(find.text('Loose stool'), findsNWidgets(2));
          expect(
            find.textContaining(
              'Loose or watery bowel movements that occur more frequently than normal.',
            ),
            findsOneWidget,
          );

          await tester.tap(find.text('Got it'));
          await tester.pumpAndSettle();

          expect(find.byType(AlertDialog), findsNothing);
        });

    testWidgets('tapping Next advances to the next symptom',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: SurveyScreen(customerId: 1)));

          final progressBefore = tester.widget<LinearProgressIndicator>(
            find.byType(LinearProgressIndicator),
          );
          expect(progressBefore.value, closeTo(1 / 6, 0.0001));

          await tester.tap(find.text('Next'));
          await tester.pumpAndSettle();

          expect(find.text('Constipation'), findsOneWidget);
          expect(find.text('Loose stool'), findsNothing);

          final progressAfter = tester.widget<LinearProgressIndicator>(
            find.byType(LinearProgressIndicator),
          );
          expect(progressAfter.value, closeTo(2 / 6, 0.0001));
        });

    testWidgets('back button falls back to HomeScreen at root',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: SurveyScreen(customerId: 1)));

          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();

          expect(find.byType(HomeScreen), findsOneWidget);
        });
  });
}