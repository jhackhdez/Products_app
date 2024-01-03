import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyBbNIUvnr6UxGcw4aTFtKuLHYhPlMpEPjo';

  // Si retornamos algo es una error, si no, todo bien
  Future<String?> createUser(String email, String password) async {
    // Se crea la información de POST
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    // Se crea el URL (mismo que se pone en Postman)
    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});

    // Disparamos petición http
    final resp = await http.post(url, body: json.encode(authData));

    // Se decodifica resp
    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    if (decodeResp.containsKey('idToken')) {
      // Guardar token en lugar seguro
      // decodeResp['idToken'];
      return null;
    } else {
      return decodeResp['error']['message'];
    }
  }
}
