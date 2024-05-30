import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kaypi/pages/model/puntoEstrategico.dart';
import 'package:flutter_kaypi/pages/puntosEstrategicos/lineaspuntos.dart';
import 'package:flutter_kaypi/pages/lugaresTuristicos/listaLugaresTuristicos.dart';
import 'package:flutter_kaypi/provider/puntosEstrategicos_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const Color colorPage10 = Color.fromARGB(255, 239, 234, 225);
const Color colorCabecera10 = Color(0xFF387990);
const Color colorBoton = Color(0xFF387990);

class PuntoSearch extends StatefulWidget {
  final Lugar lugar;
  const PuntoSearch({
    Key? key,
    required this.lugar,
  }) : super(key: key);

  @override
  _PuntoSearchState createState() {
    return _PuntoSearchState(lugar);
  }
}

class _PuntoSearchState extends State<PuntoSearch> {
  late Lugar _lugar;
  late Future<List<PuntoEstrategico>> futurePoints;

  _PuntoSearchState(Lugar lugar) {
    _lugar = lugar;
  }

  @override
  void initState() {
    super.initState();
    futurePoints = puntoEstrategicoApi.cargarData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorCabecera10,
        title: Text(_lugar.titulo, style: TextStyle(color: Colors.white)),
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
      backgroundColor: colorPage10,
      body: FutureBuilder<List<PuntoEstrategico>>(
        future: futurePoints,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los puntos estratégicos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No se encontraron puntos estratégicos'));
          } else {
            PuntoEstrategico punto = snapshot.data!.firstWhere(
                    (point) => point.nombre.toLowerCase().contains(_lugar.titulo.toLowerCase()),
                orElse: () => throw 'Punto no encontrado'
            );
            return _buildPuntoEspecifico(punto, context);
          }
        },
      ),
    );
  }

  Widget _buildPuntoEspecifico(PuntoEstrategico puntosEstrategicos, context) {
    final puntos = puntosEstrategicos;
    return Scaffold(
      body: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        margin: EdgeInsets.all(15),
        elevation: 10,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: ClipRRect(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(1),
                  child: Text(puntos.categoria,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                Container(
                  padding: EdgeInsets.all(1),
                  child: Text(puntos.zonasCBBA,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      puntos.descripcion,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: colorBoton),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PuntosMarcadorGoogle(puntos: puntos),
                          ),
                        )
                      },
                      child: Text(
                        "Puntos",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 15),
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: colorBoton),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LineasPuntos(puntos: puntos),
                          ),
                        )
                      },
                      child: Text(
                        "Lineas",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PuntosMarcadorGoogle extends StatelessWidget {
  final PuntoEstrategico puntos;
  late GoogleMapController mapController;
  late Position _currentPosition;
  CameraPosition _initialLocation =
  CameraPosition(target: LatLng(-17.399468, -66.157664));
  late Marker m;
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  PuntosMarcadorGoogle({Key? key, required this.puntos}) : super(key: key);
  Set<Marker> _createMarker() {
    double longitude = double.parse(puntos.punto.lng.toString());
    double latitude = double.parse(puntos.punto.lat.toString());
    return {
      Marker(
        markerId: MarkerId("marker_2"),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(title: puntos.nombre, snippet: puntos.descripcion),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    double longitude = double.parse(puntos.punto.lng.toString());
    double latitude = double.parse(puntos.punto.lat.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("Vista de Marcador", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: colorCabecera10,
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: _createMarker(),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
            ].toSet(),
            initialCameraPosition:
            CameraPosition(target: LatLng(latitude, longitude), zoom: 15),
            minMaxZoomPreference: MinMaxZoomPreference(13, 17),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              mapController.animateCamera(
                CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), 15),
              );
              controller.showMarkerInfoWindow(MarkerId('marker_2'));
            },
          ),
        ],
      ),
    );
  }
}
