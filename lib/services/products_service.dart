import 'dart:convert';
import 'dart:io';

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

  File? newPictureFile;

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

  void updateSelectedProductImage(String path) {
    selectedProduct?.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    // Como medida de seguridad se asegura que exista una imagen a la hora de subirla
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dmzjmqksn/image/upload?upload_preset=q5i3ggfo');

    // Crear request y asignar imagen al file (este file es el que cargamos en el postman)
    final imageUploadRequest = http.MultipartRequest('POST', url);

    // Adjunto el archivo
    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    // Se adjunta file a request
    imageUploadRequest.files.add(file);

    // Se dispara la petición
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salió mal');
      print(resp.body);
      return null;
    }

    // Seteo newPictureFile para indicar que ya está subida la imagen
    newPictureFile = null;

    final decodeData = jsonDecode(resp.body);
    return decodeData['secure_url'];
  }
}
