import 'package:flutter_kaypi/dbHelper/mongodb.dart';
import 'package:flutter_kaypi/pages/model/puntoEstrategico.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class PuntoEstrategicoApi {
  PuntoEstrategicoApi();

  Future<List<PuntoEstrategico>> cargarData() async {
    await MongoDatabase.connect();
    final List<Map<String, dynamic>> puntos = await MongoDatabase.puntosCollection.find().toList();

    return puntos.map((punto) => PuntoEstrategico.fromJson(punto)).toList();
  }

  /*Future<List<PuntoEstrategico>> cargarData() async {
    http.Response response = await http.get(Uri.parse('https://kaypi-fb8a2735368d.herokuapp.com/api/puntos'));
    //http.Response response = await http.get(Uri.parse('http://10.0.2.2:3000/api/puntos'));
    final body = await json.decode(response.body);
    final list = body['puntosEstrategicos'] as List<dynamic>;

    return list.map((e) => PuntoEstrategico.fromJson(e)).toList();
  }*/
}

final puntoEstrategicoApi = new PuntoEstrategicoApi();