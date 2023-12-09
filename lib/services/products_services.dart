import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:products_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-backend-e3433-default-rtdb.firebaseio.com';
  // Se define este objeto Final para no destruirlo y solo cambiar sus valores internos
  final List<Product> products = [];
  // late: indica que se utilizará la variable cuando se tenga un valor de la misma
  Product? selectedProduct;
  bool isLoading = true;

  ProductsService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    // Notifica al widget que consuma este método que isLoading=true
    notifyListeners();
    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.get(url);
    final Map<String, dynamic> productsMap = json.decode(resp.body);

    // Convertir el mapa recibido en un listado
    productsMap.forEach((key, value) {
      final tempProduct = Product.fromJson(value);
      tempProduct.id = key;
      // Se añade a mi lista de Products cada tempProduct
      products.add(tempProduct);
    });

    isLoading = false;
    // Notifica al widget que consuma este método que isLoading=false
    notifyListeners();

    return products;
  }
}
