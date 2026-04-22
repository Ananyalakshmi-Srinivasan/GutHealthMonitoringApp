import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'firebase_options.dart';
import 'services/fcm_service.dart';
import 'dart:async';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      theme: ThemeData(fontFamily: 'Poppins'),
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
