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
  bool isSaving = false;

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

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();
    if (product.id == null) {
      // Es necesario crear
      await createProduct(product);
    } else {
      // Actualizar
      await updateProduct(product);
    }
    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    // Lógica para hacer put a Firebase
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
    final resp = await http.put(url, body: product.toRawJson());
    final decodeData = resp.body;

    // indexWhere: loop que devuelve índice de elemento en una lista para actualizar listado de productos
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    // Lógica para hacer put a Firebase
    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.post(url, body: product.toRawJson());
    final decodeData = json.decode(resp.body);

    product.id = decodeData['name'];

    // Añadimos el producto creado a la lista
    products.add(product);

    return product.id!;
  }
}
