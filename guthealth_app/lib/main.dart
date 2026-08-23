import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:guthealth_app/utils/theme/theme.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart';
import 'services/fcm_service.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env"); // Load environment variables
  } catch (e) {
    throw Exception('Error loading .env file: $e'); // Print error if any
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const MyApp());

  unawaited(
    NotificationService.instance.initialize(
      navigatorKey: navigatorKey,
    ),
  );

  unawaited(
    NotificationService.instance.handleInitialMessage(navigatorKey),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ferrocalm app',
      themeMode: ThemeMode.system,

      // two themes -- this helps reduce repetition in individual pages --> as you can refer to the default theme config here.
      // further reduce repetition : there's a lot of similarities between the two themes e.g. font family, text theme sizes etc.
      // only colour is different so find a way to reduce this excessive repeat.
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(customerId : 1),


        // add customisation further customisation like colour blind themes etc.


    );
  }
}
