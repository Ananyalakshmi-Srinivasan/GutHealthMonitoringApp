import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guthealth_app/screens/past_data_screen.dart';
import 'package:guthealth_app/screens/home_screen.dart';

void main() {
  group('PastDataScreen widget tests', () {
    testWidgets('renders key UI and initial chart state',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: PastDataScreen(customerId: 1)));

          expect(find.text('Past Data'), findsOneWidget);
          expect(find.text('Symptom history:'), findsOneWidget);
          expect(find.text('Loose stool'), findsOneWidget);
          expect(find.byType(LineChart), findsOneWidget);
        });

    testWidgets('changing dropdown updates chart series',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: PastDataScreen(customerId: 1)));

          await tester.tap(find.text('Loose stool'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Constipation').last);
          await tester.pumpAndSettle();

          expect(find.text('Constipation'), findsOneWidget);
          expect(find.byType(LineChart), findsOneWidget);
        });

    testWidgets('back button falls back to HomeScreen at root',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: PastDataScreen(customerId: 1)));

          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();

          expect(find.byType(HomeScreen), findsOneWidget);
        });


  });
}
