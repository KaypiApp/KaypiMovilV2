import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_kaypi/pages/model/puntoEstrategico.dart';
import 'package:http/http.dart' as http;

class PuntoEstrategicoApi {
  List<PuntoEstrategico> info = [];
  PuntoEstrategicoApi();
  //Metodo cargarData()

  Future<List<PuntoEstrategico>> cargarData() async {
    //En https://containers.back4app.com/ vincular con el repositorio git del admin que debe
    //tener su Dockerfile. Actualizar en el admin src>public>js>listaPuntosEstrategicos.js
    //fetch('https://kaypiadmin3-z5xp9o37.b4a.run/listPuntos')
    //http.Response response = await http.get(Uri.parse('https://kaypi-0aad18445e35.herokuapp.com/api/puntos'));
    http.Response response = await http.get(Uri.parse('http://10.0.2.2:3000/api/puntos'));
    final body = await json.decode(response.body);

    final list = body['puntosEstrategicos'] as List<dynamic>;

    return info = list.map((e) => PuntoEstrategico.fromJson(e)).toList();
  }

/*
  Future<List<PuntoEstrategico>> cargarData() async {
    try {
      http.Response response = await http.get(Uri.parse('http://10.0.2.2:3000/api/puntos'));
      if (response.statusCode == 200) {
        final body = await json.decode(response.body);

        final list = body['puntosEstrategicos'] as List<dynamic>;

        return list.map((e) => PuntoEstrategico.fromJson(e)).toList();
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }
*/
}

final puntoEstrategicoApi = new PuntoEstrategicoApi();