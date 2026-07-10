import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
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
      themeMode: ThemeMode.system,
      theme: ThemeData(
          fontFamily: 'Poppins',
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(backgroundColor: const Color(0xFF1B9FAE),
                                   centerTitle: true,),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: const Color(0xFF1B9FAE),
                                                                selectedItemColor: Colors.white,
                                                                unselectedItemColor: Colors.white.withValues(alpha: 0.7))
        ),

      darkTheme: ThemeData(
          fontFamily: 'Poppins',
          brightness: Brightness.dark,
          primaryColor: Color(0xFF35EBFF),
          scaffoldBackgroundColor: const Color(0xFF393737),
          appBarTheme: AppBarTheme(backgroundColor: const Color(0xFF090808),
            centerTitle: true,),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: const Color(
              0xFF090808),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withValues(alpha: 0.7))
          //  textTheme: TextTheme(headlineLarge: TextStyle().copyWith(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFF35EBFF)),
          //      headlineMedium: TextStyle().copyWith(fontSize: 23, fontWeight: FontWeight.w600, color: Colors.white)
          // )
      ),
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(customerId: 1),
    );
  }
}
