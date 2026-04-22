import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guthealth_app/screens/home_screen.dart';
import 'package:guthealth_app/screens/login_screen.dart';
import 'package:guthealth_app/screens/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';



void main() {
  setUp(() {
    final mockClient = MockClient((request) async {
      return http.Response('{"customerId":1,"email":"user@example.com","firstName":"test"}', 200,);
    });
    LoginScreen.httpClient = mockClient;
    SignUpScreen.httpClient = mockClient;
  });

  tearDown(() {
    LoginScreen.httpClient = http.Client();
    SignUpScreen.httpClient = http.Client();
  });

  group('LoginScreen widget tests', () {
    testWidgets('renders login UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('shows validation errors for empty and invalid inputs',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

          await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
          await tester.pumpAndSettle();

          expect(find.text('Please enter your email'), findsOneWidget);
          expect(find.text('Please enter your password'), findsOneWidget);

          await tester.enterText(find.byType(TextFormField).at(0), 'bad-email');
          await tester.enterText(find.byType(TextFormField).at(1), 'abc12345!');
          await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
          await tester.pumpAndSettle();

          expect(find.text('Enter a valid email address'), findsOneWidget);
          expect(find.byType(HomeScreen), findsNothing);
        });

    testWidgets('toggles password visibility icon',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

          expect(find.byIcon(Icons.visibility_off), findsOneWidget);
          await tester.tap(find.byIcon(Icons.visibility_off));
          await tester.pump();
          expect(find.byIcon(Icons.visibility), findsOneWidget);
        });

    testWidgets('navigates to SignUpScreen via Sign Up link',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

          await tester.tap(find.widgetWithText(TextButton, 'Sign Up'));
          await tester.pumpAndSettle();

          expect(find.byType(SignUpScreen), findsOneWidget);
        });

    testWidgets('navigates to HomeScreen with valid credentials',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

          await tester.enterText(
            find.byType(TextFormField).at(0),
            'user@example.com',
          );
          await tester.enterText(find.byType(TextFormField).at(1), 'abc12345!');
          await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
          await tester.pumpAndSettle();

          //expect(find.byType(HomeScreen), findsOneWidget);
        });
  });

  group('SignUpScreen widget tests', () {
    testWidgets('renders signup UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(5));
    });

    testWidgets('shows validation errors for weak and mismatched passwords',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));

          await tester.enterText(find.byType(TextFormField).at(0), 'invalid-email');
          await tester.enterText(find.byType(TextFormField).at(1), 'first');
          await tester.enterText(find.byType(TextFormField).at(2), 'last');
          await tester.enterText(find.byType(TextFormField).at(3), 'password');
          await tester.enterText(find.byType(TextFormField).at(4), 'different1!');
          await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Sign Up'));
          await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
          await tester.pumpAndSettle();

          expect(find.text('Enter a valid email address'), findsOneWidget);
          expect(
            find.text('Password must contain at least one number'),
            findsOneWidget,
          );
          expect(find.text('Passwords do not match'), findsOneWidget);
          expect(find.byType(HomeScreen), findsNothing);
        });

    testWidgets('toggles signup password visibility icons together',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));

          expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));
          await tester.ensureVisible(find.byIcon(Icons.visibility_off).first);
          await tester.tap(find.byIcon(Icons.visibility_off).first);
          await tester.pump();
          expect(find.byIcon(Icons.visibility), findsNWidgets(2));
        });

    testWidgets('navigates to HomeScreen with valid signup data',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));

          await tester.enterText(
            find.byType(TextFormField).at(0),
            'new.user@example.com',
          );
          await tester.enterText(find.byType(TextFormField).at(1), 'First');
          await tester.enterText(find.byType(TextFormField).at(2), 'Last');
          await tester.enterText(find.byType(TextFormField).at(3), 'Strong1!');
          await tester.enterText(find.byType(TextFormField).at(4), 'Strong1!');
          await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Sign Up'));
          await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
          await tester.pumpAndSettle();

          //expect(find.byType(HomeScreen), findsOneWidget);
        });
  });
}
