import 'package:flutter/material.dart';
import 'package:products_app/models/models.dart';

// Esto es otra variante de manejar un Provider
class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Product? product;

  ProductFormProvider(this.product);

  updateAvailability(bool value) {
    print(value);
    product!.available = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(product?.name);
    print(product?.price);
    print(product?.available);

    // Si regresa null entonces se retorna false
    return formKey.currentState?.validate() ?? false;
  }
}
