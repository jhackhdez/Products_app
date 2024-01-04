import 'dart:html';

import 'package:flutter/material.dart';
import 'package:products_app/models/models.dart';
import 'package:products_app/screens/screens.dart';
import 'package:products_app/services/services.dart';
import 'package:products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    if (productsService.isLoading) return const LoadingScreenScreen();
    return Scaffold(
      // leading: colocaría btn a la izquierda
      // actions: de define como un listado y lo coloca a la derecha
      appBar: AppBar(title: const Text('Productos'), actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: IconButton(
              onPressed: () {
                authService.logout();
                Navigator.pushReplacementNamed(context, 'login');
              },
              icon: const Icon(Icons.login_outlined)),
        ),
      ]),
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
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            productsService.selectedProduct =
                Product(available: false, name: '', price: 0);
            Navigator.pushNamed(context, 'product');
          }),
    );
  }
}
