import 'package:flutter/material.dart';
import 'package:products_app/screens/screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login': (_) => const LoginScreen(),
          'home': (_) => const HomeScreen()
        },
        // Se define color gris del scaffold (resto de la pantalla que no es purple)
        theme: ThemeData.light()
            .copyWith(scaffoldBackgroundColor: Colors.grey[300]));
  }
}