import 'package:flutter_kaypi/dbHelper/mongodb.dart';
import 'package:flutter_kaypi/pages/model/linea.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class LineasApi {
  LineasApi();

  Future<List<Linea>> cargarData() async {
    await MongoDatabase.connect();
    final List<Map<String, dynamic>> lineas = await MongoDatabase.lineasCollection.find().toList();

    return lineas.map((linea) => Linea.fromJson(linea)).toList();
  }

  /*Future<List<Linea>> cargarData() async {
    http.Response response = await http.get(Uri.parse('https://kaypi-fb8a2735368d.herokuapp.com/api/lineas'));
    //http.Response response = await http.get(Uri.parse('http://10.0.2.2:3000/api/lineas'));
    final body = await json.decode(response.body);
    final list = body['lineas'] as List<dynamic>;

    return list.map((e) => Linea.fromJson(e)).toList();
  }*/
  
}

final lineasApi = new LineasApi();
