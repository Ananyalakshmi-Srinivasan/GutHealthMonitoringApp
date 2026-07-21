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

      // two themes -- this helps reduce repetition in individual pages --> as you can refer to the default theme config here.
      // further reduce repetition : there's a lot of similarities between the two themes e.g. font family, text theme sizes etc.
      // only colour is different so find a way to reduce this excessive repeat.

      theme: ThemeData(
          fontFamily: 'Poppins',
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(backgroundColor: const Color(0xFF1B9FAE),
                                   centerTitle: true,),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
                                                                backgroundColor: const Color(0xFF1B9FAE),
                                                                selectedItemColor: Colors.white,
                                                                unselectedItemColor: Colors.white.withValues(alpha: 0.7),
                                                                selectedLabelStyle: const TextStyle(
                                                                  //fontFamily: 'Poppins',
                                                                  fontWeight: FontWeight.w600,
                                                                )),
          textTheme: TextTheme(
                      displayLarge: const TextStyle(
                      color: Color(0xFF1B9FAE),
                      fontSize: 50,
                      fontWeight: FontWeight.w600,
                      ),
                      titleLarge: const TextStyle(
                      color: Color(0xFF1B9FAE),
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      ),
                      bodyLarge: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      ),
                      bodyMedium: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      ),
                      bodySmall: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      ),
                      labelSmall: const TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                    )

          ),
      ),

      darkTheme: ThemeData(
          fontFamily: 'Poppins',
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF191919),
          appBarTheme: AppBarTheme(backgroundColor: const Color(
              0xFF090808),
            centerTitle: true,),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: const Color(
              0xFF090808),
              selectedItemColor: const Color(0xFFE0868D), //const Color(0xFFE0868D),
              unselectedItemColor: Colors.white.withValues(alpha: 0.7),
              selectedLabelStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Poppins',
              )),
          textTheme: TextTheme(
                displayLarge: const TextStyle(
                  color: Color(0xFFE0868D),
                  fontSize: 50,
                  fontWeight: FontWeight.w600,
                ),
                titleLarge: const TextStyle(
                  color: Color(0xFFE0868D),
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
                bodyLarge: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                bodyMedium: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),

                bodySmall: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                labelSmall: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                )
        ),
      ),

        // add customisation further customisation like colour blind themes etc.

        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(customerId: 1),
    );
  }
}
