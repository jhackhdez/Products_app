import 'package:flutter/material.dart';
import 'package:products_app/screens/screens.dart';
import 'package:provider/provider.dart';
import 'services/services.dart';

void main() => runApp(const AppState());

// AppState: Define Provider de manera Global, permite cargar de forma lazy
class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    // Se crea MultiProvider para trabajar con varios de ellos en la app
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProductsService())],
      child: const MyApp(),
    );
  }
}

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
          'register': (_) => const RegisterScreen(),
          'home': (_) => const HomeScreen(),
          'product': (_) => const ProductScreen()
        },
        // Se define color gris del scaffold (resto de la pantalla que no es purple)
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.grey[300],
            appBarTheme: const AppBarTheme(elevation: 0, color: Colors.indigo),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.indigo, elevation: 0)));
  }
}
