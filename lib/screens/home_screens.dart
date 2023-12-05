import 'package:flutter/material.dart';
import 'package:products_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      // ListView.builder crea widget de fora perezosa, solo cuando van a entrar en pantalla y no los mantiene creados todo el tiempo
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: ((context, index) =>
              // GestureDetector: Permite agregar acción al hacer clic encima del widget hijo
              GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'product'),
                  child: const ProductCard()))),
      floatingActionButton:
          FloatingActionButton(child: const Icon(Icons.add), onPressed: () {}),
    );
  }
}
