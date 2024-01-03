import 'package:flutter/material.dart';
import 'package:products_app/screens/screens.dart';
import 'package:products_app/services/services.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Listen: false porque no necesito redibujar esta pantalla nunca
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
          // FutureBuilder: Me permite redirigir a una pantalla u otra
          child: FutureBuilder(
              future: authService.readToken(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (!snapshot.hasData) {
                  return const Text('Espere...');
                }
                if (snapshot.data == '') {
                  // Se ejecuta a penas termine la construcción de este widget
                  Future.microtask(() => {
                        Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    const LoginScreen(),
                                transitionDuration: const Duration(seconds: 0)))
                      });
                } else {
                  Future.microtask(() => {
                        Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (_, __, ___) => const HomeScreen(),
                                transitionDuration: const Duration(seconds: 0)))
                      });
                }
                return Container();
              })),
    );
  }
}
