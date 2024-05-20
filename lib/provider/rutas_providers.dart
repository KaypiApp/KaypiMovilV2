import 'dart:collection';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';

import 'package:flutter_kaypi/pages/model/linea.dart';
import 'package:flutter_kaypi/pages/model/puntoEstrategico.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RutasProvider with ChangeNotifier {
  //metodo que obtiene las lineas, mas cercanas, por los puntos estrategicos con un rango definido por marcador
  Future<List<Linea>> getPuntosCercanos(List<PuntoEstrategico> points,
      List<Linea> lines, List<LatLng> latlng) async {
    List<Linea> nlineas = [];
    Map<String, double> puntoscernaos = new Map<String, double>();
    for (int i = 0; i < points.length; i++) {
      _coordinateDistance(latlng[0].latitude, latlng[0].longitude,
                  points[i].punto.lat, points[i].punto.lng) <=
              1000.0
          ? puntoscernaos.putIfAbsent(
              points[i].id,
              () => _coordinateDistance(latlng[0].latitude, latlng[0].longitude,
                  points[i].punto.lat, points[i].punto.lng))
          : print('object');
      _coordinateDistance(latlng[0].latitude, latlng[0].longitude,
                  points[i].punto.lat, points[i].punto.lng) <=
              1000.0
          ? puntoscernaos.putIfAbsent(
              points[i].id,
              () => _coordinateDistance(latlng[1].latitude, latlng[1].longitude,
                  points[i].punto.lat, points[i].punto.lng))
          : print('object');
    }

    if (puntoscernaos.length > 0) {
      var sortedKeys = puntoscernaos.keys.toList(growable: false)
        ..sort((k1, k2) =>
            puntoscernaos[k1]!.compareTo(puntoscernaos[k2]!.toInt()));
      LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
          key: (k) => k, value: (k) => puntoscernaos[k]);

      for (int j = 0; j < points.length; j++) {
        if (points[j].id == sortedMap.entries.toList()[0].key) {
          nlineas = lines
              .where((item) => points[j].lineas.contains(item.nombre))
              .toList();
        }
      }
    }
    else{
      Fluttertoast.showToast(
          msg: "No se encontraron líneas que pasen por los puntos seleccionados." ,
          toastLength: Toast.LENGTH_SHORT, // Duración del mensaje (Toast.LENGTH_SHORT o Toast.LENGTH_LONG)
          gravity: ToastGravity.TOP, // Posición del mensaje (TOP, CENTER, BOTTOM)
          backgroundColor: Colors.blue.shade900.withOpacity(0.8), // Color de fondo del mensaje
          textColor: Colors.white, // Color del texto del mensaje
        );
    }
    return nlineas;
  }

  Future<List<Linea>> getLineasCercanas(List<Linea> lines, List<LatLng> latlng) async {
    List<Linea> nlineas = [];

    for (int i = 0; i < lines.length; i++) {
      bool isCloseToStart = false;
      bool isCloseToEnd = false;

      for (int j = 0; j < lines[i].ruta[0].puntos.length; j++) {
        double distanceToStart = _coordinateDistance(
          latlng[0].latitude,
          latlng[0].longitude,
          lines[i].ruta[0].puntos[j].lat,
          lines[i].ruta[0].puntos[j].lng,
        );

        double distanceToEnd = _coordinateDistance(
          latlng[1].latitude,
          latlng[1].longitude,
          lines[i].ruta[0].puntos[j].lat,
          lines[i].ruta[0].puntos[j].lng,
        );

        if (distanceToStart <= 1000.0) {
          isCloseToStart = true;
        }

        if (distanceToEnd <= 1000.0) {
          isCloseToEnd = true;
        }

        // Si ya hemos encontrado puntos cercanos tanto al inicio como al fin, no es necesario seguir revisando
        if (isCloseToStart && isCloseToEnd) {
          nlineas.add(lines[i]);
          break;
        }
      }
    }

    if (nlineas.isEmpty) {
      Fluttertoast.showToast(
        msg: "No se encontraron líneas que pasen por los puntos seleccionados.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.blue.shade900.withOpacity(0.8),
        textColor: Colors.white,
      );
    }

    return nlineas;
  }

// Fórmula para calcular la distancia entre dos coordenadas.
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295; // Valor de pi / 180 para convertir a radianes
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    // La distancia se devuelve en kilómetros, así que la convertimos a metros multiplicando por 1000
    return 1000 * 12742 * asin(sqrt(a));
  }



}
