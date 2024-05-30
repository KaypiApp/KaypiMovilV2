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

  _PuntoSearchState(Lugar lugar) {
    _lugar = lugar;
  }

  List points = [];
  List filteredPoints = [];
  void initState() {
    puntoEstrategicoApi.cargarData().then((data) {
      setState(() {
        points = filteredPoints = data;
      });
    });
    super.initState();
  }

  void _filterPoints(value) {
    setState(() {
      filteredPoints = points
          .where((point) =>
              point.nombre.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    _filterPoints(_lugar.titulo);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: colorCabecera10,
        title: Text("Puntos Estrategicos",
            style: TextStyle(
              color: Colors.white,
            )),
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
      body: Container(
        padding: EdgeInsets.all(10),
        child: filteredPoints.length > 0
            ? ListView.builder(
                itemCount: filteredPoints.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          _buildPuntoEspecifico(filteredPoints[index], context),
                    )),
                    child: Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 8),
                        child: Text(
                          filteredPoints[index].nombre,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  );
                })
            : Center(
                child: Text('Punto no encontrado'),
              ),
      ),
    );
  }

  Widget _buildPuntoEspecifico(
      PuntoEstrategico puntosEstrategicos, context) {
    final puntos = puntosEstrategicos;
    return Scaffold(
      appBar: AppBar(
        title: Text(puntos.nombre,
          style: TextStyle(color: Colors.white,),
        ),
        backgroundColor: colorCabecera10,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
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
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(1),
                  child: Text(puntos.categoria,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                Container(
                  padding: EdgeInsets.all(1),
                  child: Text(puntos.zonasCBBA,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      puntos.descripcion,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: colorBoton,
                        ),
                        onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PuntosMarcadorGoogle(
                                          puntos: puntos,
                                        )),
                              )
                            },
                          child: Text(
                            "Puntos",
                            style: TextStyle(

                             color: Colors.white,
                            ),
                          ),
                        ),
                    SizedBox(
                      width: 15,
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: colorBoton,
                        ),
                        onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LineasPuntos(
                                            puntos: puntos,
                                          ))),
                            },
                        child: Text(
                            "Lineas",
                            style: TextStyle(

                             color: Colors.white,
                            ),

                          )
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
          infoWindow:
          InfoWindow(title: puntos.nombre, snippet: puntos.descripcion)),
    };
  }

  @override
  Widget build(BuildContext context) {
    double longitude = double.parse(puntos.punto.lng.toString());
    double latitude = double.parse(puntos.punto.lat.toString());

    return Scaffold(
      appBar: AppBar(
          title: Text("Vista de Marcador", style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: colorCabecera13),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: _createMarker(),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer(),)
            ].toSet(),
            initialCameraPosition: CameraPosition(target: LatLng(latitude, longitude), zoom: 15), // Set the initial position to the marker
            minMaxZoomPreference: MinMaxZoomPreference(13, 17),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              mapController.animateCamera(
                CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), 15), // Center the map on the marker with zoom level
              );
              controller.showMarkerInfoWindow(MarkerId('marker_2'));
            },
          ),
        ],
      ),
    );
  }
}