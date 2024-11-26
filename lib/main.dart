import 'package:casaproy/pages/temporizador/temporizador.dart';
import 'package:casaproy/pages/house.dart';
import 'package:casaproy/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: GoRouter(initialLocation: '/login', routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => Login()
        ),
        GoRoute(
          path: '/house',
          builder: (context, state) => House()
        ),
        GoRoute(
          path: '/clock',
          builder: (context, state) => CountdownPage(),
        )
      ]),
    );
  }
}