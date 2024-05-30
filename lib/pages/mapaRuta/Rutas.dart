import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kaypi/pages/model/linea.dart';
import 'package:flutter_kaypi/pages/model/puntoEstrategico.dart';
import 'package:flutter_kaypi/provider/lineas_api.dart';
import 'package:flutter_kaypi/provider/puntosEstrategicos_api.dart';
import 'package:flutter_kaypi/provider/rutas_providers.dart';
import 'package:flutter_kaypi/zoom_drawer.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

const Color colorPage11 = Color.fromARGB(255, 239, 234, 225);
const Color colorCabecera11 = Color(0xFF387990);

class Rutas extends StatefulWidget {
  const Rutas({Key? key}) : super(key: key);

  @override
  _RutasState createState() => _RutasState();
}

class _RutasState extends State<Rutas> {
  //declaracion de variables
  late GoogleMapController mapController;
  List<Linea> lines = [];
  List<Linea> nlines = [];
  List<PuntoEstrategico> points = [];
  Set<Marker> markers = {};
  Set<Polyline> polyline = Set<Polyline>();
  List<LatLng> latlng = [];
  List<LatLng> latlngPuntos = [];
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  bool bandera = false;
  int posicion = 0;
  final _rutasProvider = RutasProvider();
  int direccionRuta = 0;
  Set<Circle> circles = Set<Circle>();
  int _sliderValue = 500; // Variable para almacenar el valor del slider
  bool _showSlider = false; // Variable para controlar la visibilidad del slider

  CameraPosition _initialLocation =
  CameraPosition(target: LatLng(-17.4139766, -66.1653224), zoom: 12.0);
  late Position _currentPosition;

  //metodo para obtener la ubicacion actual del dispositivo de manera asincronica
  // Method for retrieving the current location
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 14.0,
            ),
          ),
        );
      });
    }).catchError((e) {
      print(e);
    });
  }

  //obteniendo puntos de los puntos estrategicos para referencia en el mapa.
  getPuntos() {
    puntoEstrategicoApi.cargarData().then((puntos) {
      setState(() {
        points = puntos;
      });
    });
  }

  //obteniendo todas las lineas de la base de datos
  getLineas() {
    lineasApi.cargarData().then((lineas) {
      setState(() {
        lines = lineas;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getPuntos();
    getLineas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorCabecera11,
        title: Text('Rutas', style: TextStyle(color: Colors.white)),
        elevation: 0,
        leading: InkWell(
          onTap: () => ZoomDrawer.of(context)!.toggle(),
          child: Icon(
            Icons.menu,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                    new Factory<OneSequenceGestureRecognizer>(
                          () => new EagerGestureRecognizer(),
                    )
                  ].toSet(),
                  markers: Set<Marker>.from(markers),
                  circles: circles,
                  initialCameraPosition: _initialLocation,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  compassEnabled: true,
                  polylines: polyline,
                  scrollGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  onTap: _handleTap,
                ),
                Positioned(
                  top: 60,
                  right: 11,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          markers.clear();
                          latlngPuntos.clear();
                          polyline.clear();
                          nlines = [];
                          setState(() {});
                          posicion = 0;
                          circles.clear();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.shade900,
                          ),
                          child: Icon(
                            Icons.delete_sweep_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showSlider = !_showSlider;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green.shade600,
                          ),
                          child: Icon(
                            Icons.tune,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          nlines.isNotEmpty
              ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CarouselSlider.builder(
                itemCount: nlines.length,
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() {
                      posicion = index;
                      latlng.clear();
                      for (var punto in nlines[posicion].ruta[direccionRuta].puntos) {
                        latlng.add(LatLng(punto.lat, punto.lng));
                      }
                      _drawPolyline();
                    });
                  },
                  enableInfiniteScroll: false,
                  height: 100,
                  viewportFraction: 1,
                ),
                itemBuilder: (_, i, ri) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    color: Colors.white,
                    child: ListTile(
                      leading: Image(
                        image: AssetImage('assets/img/KaypiLogo.png'),
                        width: 30,
                        height: 30,
                      ),
                      title: Text(
                        nlines[i].nombre,
                        style: TextStyle(color: Colors.blue.shade900),
                      ),
                      subtitle: Text(
                        nlines[i].horarios[0],
                        style: TextStyle(color: Colors.blue.shade900),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            direccionRuta = direccionRuta == 0 ? 1 : 0;
                            latlng.clear();
                            for (var punto in nlines[posicion].ruta[direccionRuta].puntos) {
                              latlng.add(LatLng(punto.lat, punto.lng));
                            }
                            _drawPolyline();
                          });
                        },
                        child: Text(
                          direccionRuta == 0 ? 'IDA' : 'VUELTA',
                          style: TextStyle(color: Colors.blue.shade900),
                        ),
                      ),
                    ),
                  );
                },
              ),
              AnimatedSmoothIndicator(
                activeIndex: posicion,
                count: nlines.length,
              ),
            ],
          )
              : Text("Para ajustar el rango de búsqueda presione el botón verde."),
          SizedBox(height: 16),
          if (_showSlider)
            Column(
              children: [
                Slider(
                  value: _sliderValue.toDouble(),
                  min: 100,
                  max: 1000,
                  divisions: 900,
                  label: _sliderValue.toString(),
                  activeColor: Colors.blue.shade900,
                  inactiveColor: Colors.blue.shade300,
                  onChanged: (double newValue) {
                    setState(() {
                      _sliderValue = newValue.toInt();
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _rutasProvider.setSliderValue(_sliderValue);
                    await _updateCircleRadius();
                    searchLines();
                  },
                  child: Text('Ajustar rango',
                      style: TextStyle(color: Colors.blue.shade900)),
                ),
              ],
            ),
        ],
      ),
    );
  }

  _handleTap(LatLng point) {
    setState(() {
      if (markers.length <= 1) {
        latlngPuntos.add(point);
        InfoWindow infoWindow;
        if (markers.isEmpty) {
          infoWindow = InfoWindow(title: 'Origen');
        } else {
          infoWindow = InfoWindow(title: 'Destino');
        }
        markers.add(Marker(
          markerId: MarkerId(markers.length.toString()),
          position: point,
          infoWindow: infoWindow,
          icon: markers.isEmpty
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
              : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ));

        Circle circle = Circle(
          circleId: CircleId('circle_${markers.length}'),
          center: point,
          radius: _sliderValue * 1.0,
          fillColor: markers.length == 1
              ? Colors.red.withOpacity(0.3)
              : Colors.blue.withOpacity(0.3),
          strokeWidth: 0,
        );
        circles.add(circle);
        setState(() {});
      }
    });
    if (markers.length == 2) {
      searchLines();
    }
  }

  Future<void> _updateCircleRadius() async {
    double newRadius = await _rutasProvider.getSliderValue();
    setState(() {
      circles = circles.map((circle) {
        return circle.copyWith(radiusParam: newRadius);
      }).toSet();
    });
  }

  void searchLines() {
    _rutasProvider
        .getLineasCercanas(lines, latlngPuntos)
        .then((value) {
      setState(() {
        nlines = value;
        if (nlines.isNotEmpty) {
          latlng.clear();
          posicion = 0; // Reiniciar la posición del carousel
          for (var punto in nlines[posicion].ruta[direccionRuta].puntos) {
            latlng.add(LatLng(punto.lat, punto.lng));
          }
          _drawPolyline();
        } else {
          polyline.clear();
        }
      });
    });
  }

  void _drawPolyline() {
    setState(() {
      polyline.clear();
      if (latlng.isNotEmpty) {
        polyline.add(Polyline(
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          polylineId: PolylineId('linea'),
          visible: true,
          points: latlng,
          width: 3,
          color: Color.fromRGBO(48, 79, 254, 1.0),
        ));
      }
    });
  }
}
