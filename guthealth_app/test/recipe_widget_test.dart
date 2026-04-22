import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guthealth_app/screens/recipe_screen.dart';

void main() {

  testWidgets('Recipes screen loads with title and buttons', (WidgetTester tester) async {

    await tester.pumpWidget(
      const MaterialApp(
        home: RecipesScreen(customerId: 1),
      ),
    );

    // Check page title
    expect(find.text('Recipes'), findsOneWidget);

    // Check recipe buttons
    expect(find.text('Breakfast'), findsOneWidget);
    expect(find.text('Lunch'), findsOneWidget);
    expect(find.text('Dinner'), findsOneWidget);
    expect(find.text('Soups & Salads'), findsOneWidget);
    expect(find.text('Smoothies'), findsOneWidget);

  });

  testWidgets('Bottom navigation bar shows Home and Calendar', (WidgetTester tester) async {

    await tester.pumpWidget(
      const MaterialApp(
        home: RecipesScreen(customerId: 1),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Calendar'), findsOneWidget);

    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.calendar_month), findsOneWidget);

  });

  testWidgets('Tapping recipe buttons triggers tap', (WidgetTester tester) async {

    await tester.pumpWidget(
      const MaterialApp(
        home: RecipesScreen(customerId: 1),
      ),
    );

    // Tap breakfast button
    await tester.tap(find.text('Breakfast'));
    await tester.pump();

    // Tap lunch button
    await tester.tap(find.text('Lunch'));
    await tester.pump();

    // Tap dinner button
    await tester.tap(find.text('Dinner'));
    await tester.pump();

  });

}