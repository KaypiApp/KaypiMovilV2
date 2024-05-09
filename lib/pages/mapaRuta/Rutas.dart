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

class Rutas extends StatefulWidget {
  const Rutas({Key? key}) : super(key: key);

  @override
  _RutasState createState() => _RutasState();
}

class _RutasState extends State<Rutas> {
  //declaracion de variables
  late GoogleMapController mapController;
  final _carouselController = new CarouselController();
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
  //var cont = 0;
  bool bandera = false;
  int posicion = 0;
  final _rutasProvider = RutasProvider();
  int direccionRuta = 0;
  Set<Circle> circles = Set<Circle>();

  CameraPosition _initialLocation =
      CameraPosition(target: LatLng(-17.4139766, -66.1653224), zoom: 12.0);
  late Position _currentPosition;

//metodo para obtener la ubicacion actual del dispositivo de manera asincronica
  // Method for retrieving the current location
  // ignore: unused_element
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
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getPuntos();
    getLineas();
    //_getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text('Rutas',
            style: TextStyle(
              color: Colors.white,
            )),
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
                  child: GestureDetector(
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
                ),
              ],
            ),
          ),
          nlines.length > 0
              ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: nlines.length,
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    posicion = index;
                    latlng.clear();
                    setState(() {});
                    for (var i in nlines[posicion].ruta[direccionRuta].puntos) {
                      latlng.add(new LatLng(i.lat, i.lng));
                    }
                    _OnMapCreated(mapController);
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
                      ),
                      title: Text(
                        nlines[posicion].nombre,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(nlines[posicion].horarios[0]),
                      trailing: TextButton(
                        onPressed: () {
                          setState(() {
                            if (direccionRuta == 0) {
                              direccionRuta = 1;
                            } else if (direccionRuta == 1) {
                              direccionRuta = 0;
                            }
                            if (nlines.length > 0) {
                              latlng.clear();
                              setState(() {});
                              for (var i
                              in nlines[posicion].ruta[direccionRuta].puntos) {
                                latlng.add(new LatLng(i.lat, i.lng));
                              }
                              _OnMapCreated(mapController);
                              bandera = false;
                            } else {
                              bandera = true;
                            }
                          });
                        },
                        child: direccionRuta == 0
                            ? Icon(Icons.arrow_downward_sharp)
                            : Icon(Icons.arrow_upward),
                      ),
                    ),
                  );
                },
              ),
              Divider(height: 2),
              AnimatedSmoothIndicator(
                effect: SlideEffect(dotHeight: 8, dotWidth: 8),
                activeIndex: posicion,
                count: nlines.length,
              ),
              SizedBox(height: 6),
            ],
          )
              : Container(),
        ],
      ),

    );
  }

  //metodo de marcador y obteniendo puntos del mapa
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

        // Dibujar un círculo alrededor del marcador tocado
        Circle circle = Circle(
          circleId: CircleId('circle_${markers.length}'), // Identificador único para cada círculo
          center: point, // El centro del círculo es el punto tocado
          radius: 1000,
          fillColor: //Colors.blue.withOpacity(0.3),
          markers.length == 1
              ? Colors.red.withOpacity(0.3)
              : Colors.blue.withOpacity(0.3),
          strokeWidth: 0,
        );
        // Agrega el círculo al conjunto de círculos
        circles.add(circle);

        // Actualiza el estado para reflejar los cambios
        setState(() {});
      }
    });
    if (markers.length == 2) {
      _rutasProvider
          .getPuntosCercanos(points, lines, latlngPuntos)
          .then((value) => {
        setState(() {
          nlines = value;
          if (nlines.length > 0) {
            latlng.clear();
            setState(() {});
            //ciclo para añadir la direccion de las lineas por los puntos seleccionados
            for (var i in nlines[posicion].ruta[direccionRuta].puntos) {
              //print(new LatLng(i.lat, i.lng));
              latlng.add(new LatLng(i.lat, i.lng));
            }
            _OnMapCreated(mapController);
            bandera = false;
          } else {
            bandera = true;
          }
        })
      });
    }
  }

//dibujando el trazo de cada linea que pasa por los puntos marcados
  // ignore: non_constant_identifier_names
  void _OnMapCreated(GoogleMapController mapController) {
    setState(() {
      mapController = mapController;
      polyline.add(Polyline(
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          polylineId: PolylineId('linea'),
          visible: true,
          points: latlng,
          width: 3,
          color: Color.fromRGBO(48, 79, 254, 1.0)));
    });
  }
}
