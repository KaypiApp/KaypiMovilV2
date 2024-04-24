import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_kaypi/pages/model/linea.dart';
import 'package:http/http.dart' as http;

class LineasApi {
  List<Linea> info = [];

  LineasApi();

  //Metodo cargarData()
  //Obtiene de un json localmente y retorna una lista parseo Json
  /*Future<List<Linea>> cargarData() async {
    final listJson = 'lib/utils/Lineas.json';
    final response = await rootBundle.loadString(listJson);
    final data = await json.decode(response);
    final list = data['Lineas'] as List<dynamic>;

    list.sort((a, b) => a.toString().compareTo(b.toString()));
    
    return info = list.map((e) => Linea.fromJson(e)).toList();
  }*/

  //Metodo getLineas()
  //Obtiene de una url el json y retorna una lista parseo Json
  //
  Future<List<Linea>> cargarData() async {
    //En https://containers.back4app.com/ vincular con el repositorio git del admin que debe
    //tener su Dockerfile. Actualizar en el admin src>public>js>listaLineas.js
    //fetch('https://kaypiadmin3-z5xp9o37.b4a.run/listLineas')
    http.Response response = await http.get(Uri.parse('https://kaypi-0aad18445e35.herokuapp.com/api/lineas'));
    final body = await json.decode(response.body);

    final list = body['lineas'] as List<dynamic>;

    return info = list.map((e) => Linea.fromJson(e)).toList();
  }
  
}

final lineasApi = new LineasApi();