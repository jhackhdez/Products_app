import 'package:flutter/services.dart';
import 'package:products_app/providers/product_form_provider.dart';
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
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productService.selectedProduct),
      child: _ProductScreenBody(productService: productService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    required this.productService,
  });

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
    // Referencia a provider
    final productForm = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      // SingleChildScrollView: Permite dejar hacer scroll para evitar que se tapen los inputs
      body: SingleChildScrollView(
        // Al hacer scroll se oculta el teclado
        // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
          onPressed: () async {
            // TODO: Guardar producto
            if (!productForm.isValidForm()) return;

            // Si el form es valid
            await productService.saveOrCreateProduct(productForm.product!);
          },
          child: const Icon(Icons.save_outlined)),
    );
  }
}

class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
            // Se asigna el key de ProductFormProvider al formulario
            key: productForm.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    initialValue: product!.name,
                    onChanged: (value) => product.name = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre es obligatorio';
                      }
                      return null;
                    },
                    decoration: InputDecorations.authInputDecoration(
                        hintText: 'Nombre del producto', labelText: 'Nombre:')),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                    // Esta conversión se hace porque las cajas de texto aceptan string, no números como es el caso de Price
                    initialValue: '${product.price}',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                    onChanged: (value) {
                      // Se pregunta si se puede parsear el valor entrado a entero
                      if (double.tryParse(value) == null) {
                        product.price = 0;
                      } else {
                        product.price = double.parse(value);
                      }
                    },
                    // Esto garantiza que se muestre el teclado numérico
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: '\$150', labelText: 'Precio:')),
                const SizedBox(height: 30),
                SwitchListTile(
                    value: product.available,
                    title: const Text('Disponible'),
                    activeColor: Colors.indigo,
                    onChanged: (value) =>
                        productForm.updateAvailability(value)),
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
