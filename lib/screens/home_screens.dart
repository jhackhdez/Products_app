import 'package:flutter/material.dart';
import 'package:products_app/screens/screens.dart';
import 'package:products_app/services/services.dart';
import 'package:products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    if (productsService.isLoading) return const LoadingScreenScreen();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      // ListView.builder crea widget de forma perezosa, solo cuando van a entrar en pantalla y no los mantiene creados todo el tiempo
      body: ListView.builder(
          itemCount: productsService.products.length,
          itemBuilder: ((context, index) =>
              // GestureDetector: Permite agregar acción al hacer clic encima del widget hijo
              GestureDetector(
                  onTap: () {
                    // Se asigna a "productsService.selectedProduct" una copia del producto seleccionado
                    productsService.selectedProduct =
                        productsService.products[index].copy();
                    Navigator.pushNamed(context, 'product');
                  },
                  child: ProductCard(
                    product: productsService.products[index],
                  )))),
      floatingActionButton:
          FloatingActionButton(child: const Icon(Icons.add), onPressed: () {}),
    );
  }
}
