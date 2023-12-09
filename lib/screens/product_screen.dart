import 'package:products_app/services/services.dart';
import 'package:products_app/ui/input_decorations.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);
    return Scaffold(
      // SingleChildScrollView: Permite dejar hacer scroll para evitar que se tapen los inputs
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(url: productService.selectedProduct?.picture),
                // Positioned: Permite ubicar widget en lugares específicos dentro del Stack
                Positioned(
                    top: 60,
                    left: 20,
                    child: IconButton(
                        // De esta forma salimos de la pantalla
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 40,
                          color: Colors.white,
                        ))),
                Positioned(
                    top: 60,
                    right: 30,
                    child: IconButton(
                        // De esta forma salimos de la pantalla
                        onPressed: () {
                          // TODO Cámara o Galería
                        },
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          size: 40,
                          color: Colors.white,
                        )))
              ],
            ),
            _ProductForm(),
            const SizedBox(height: 100)
          ],
        ),
      ),
      // floatingActionButtonLocation: permite desplazar el botón para lograr animación
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Guardar producto
          },
          child: const Icon(Icons.save_outlined)),
    );
  }
}

class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
            child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Nombre del producto', labelText: 'Nombre:')),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
                // Esto garantiza que se muestre el teclado numérico
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '\$150', labelText: 'Precio:')),
            const SizedBox(height: 30),
            SwitchListTile(
                value: true,
                title: const Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged: (value) {
                  // TODO: Pendiente
                }),
            const SizedBox(
              height: 30,
            )
          ],
        )),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 5),
                blurRadius: 5)
          ]);
}
