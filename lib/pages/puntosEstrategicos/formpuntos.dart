import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kaypi/pages/model/puntoEstrategico.dart';
import 'package:flutter_kaypi/pages/puntosEstrategicos/lineaspuntos.dart';
import 'package:flutter_kaypi/provider/puntosEstrategicos_api.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const Color colorPage13 = Color.fromARGB(255, 239, 234, 225);
const Color colorCabecera13 = Color(0xFF387990);

const Color colorBoton = Color(0xFF387990);

List<String> listalineas = <String>[];
class FormPuntos extends StatefulWidget {
  const FormPuntos({Key? key}) : super(key: key);

  @override
  _FormPuntosState createState() => _FormPuntosState();
}

class _FormPuntosState extends State<FormPuntos> {
  late Future<List<PuntoEstrategico>> futurePoints;
   List points = [];
   List filteredPoints = [];
   bool isSearching = false;

   void initState() {
     futurePoints = puntoEstrategicoApi.cargarData();
    puntoEstrategicoApi.cargarData().then((data) {
      setState(() {
        points = filteredPoints = data;
        points.sort((a, b) => a.nombre.compareTo(b.nombre));
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
      filteredPoints.sort((a, b) => a.nombre.compareTo(b.nombre));
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: colorPage13,
      appBar: AppBar(
        backgroundColor: colorCabecera13,
        title:  !isSearching
            ? Text(
            'Puntos Estrategicos',
            style: TextStyle(
              color: Colors.white,
            ))
            : TextField(
                onChanged: (value) {
                  _filterPoints(value);
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hoverColor: colorCabecera13,
                    hintText: "Busca tu lugar de preferencia",
                    hintStyle: TextStyle(color: Colors.white60, decoration:TextDecoration.none),
                     enabledBorder: UnderlineInputBorder(      
                      borderSide: BorderSide(color: Colors.white30),   
                      ),  
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                   ),
                ),
                
              ), 
      actions: <Widget>[
          isSearching
              ? IconButton(
                  icon: Icon(Icons.cancel,
                    color: Colors.white,),
                  onPressed: () {
                    setState(() {
                      this.isSearching = false;
                      filteredPoints = points;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search, color: Colors.white,),
                  onPressed: () {
                    setState(() {
                      this.isSearching = true;
                    });
                  },
                )
        ],      
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
      body: !isSearching    
      ? _lista(context)
      : Container(
        padding: EdgeInsets.all(10),
        child: filteredPoints.length > 0
            ? ListView.builder(
                itemCount: filteredPoints.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: ()=> Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>_buildPuntoEspecifico(filteredPoints[index],context),
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
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
      ) 
      );
  }

  Widget _lista(context) => FutureBuilder<List<PuntoEstrategico>>(
    future: futurePoints,
    initialData: [],
    builder: (context, AsyncSnapshot<dynamic> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator(
          color: Colors.black,
        ));
      } else if (snapshot.hasError) {
        return Center(child: Text('Error'));
      } else if (!snapshot.hasData) {
        return Center(child: Text('No hay data'));
      } else {
        List<PuntoEstrategico> lineas = snapshot.data;
        // Ordenar alfabéticamente
        lineas.sort((a, b) => a.nombre.compareTo(b.nombre));
        return RefreshIndicator(
          child: _buildLineas(lineas, context),
          onRefresh: _pullRefresh,
        );
      }
    },
  );


  Widget _buildLineas(List<PuntoEstrategico> puntosEstrategicos, context) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: puntosEstrategicos.length,
        itemBuilder: (context, index) {
          final puntos = puntosEstrategicos[index];
          return Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            margin: EdgeInsets.all(15),
            elevation: 10,
            child: Container(
                decoration: BoxDecoration(
                   color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: ClipRRect(
                  // Los bordes del contenido del card se cortan usando BorderRadius
                  // widget hijo que será recortado segun la propiedad anterior
                  child: Column(
                    children: <Widget>[
                      // widget Image para mostrar una imagen
                      SizedBox(
                        height: 10,
                      ),
                      /*Image(
                                // Como queremos traer una imagen desde un url usamos NetworkImage
                                image: AssetImage(puntos.imagen),
                              ),*/

                      // Usamos Container para el contenedor de la descripción
                      Container(
                        padding: EdgeInsets.all(1),
                        child: Text(puntos.nombre,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                        textAlign: TextAlign.center,),
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              puntos.descripcion,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            width: 15,
                          ),  
                          TextButton(
                              style: TextButton.styleFrom(
                                //primary: Colors.white,
                                backgroundColor: colorBoton,
                                //onSurface: Colors.blue.shade100,
                              ),
                              onPressed: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PuntosMarcadorGoogle(
                                                puntos: puntos,
                                              )),
                                    )
                                  },
                              child: Text('Puntos', style: TextStyle(color: Colors.white),
                              )),
                          SizedBox(
                            width: 15,
                          ),                
                          TextButton(
                              style: TextButton.styleFrom(
                                //color: Colors.white,
                                backgroundColor: colorBoton,
                                //onSurface: Colors.blue.shade100,
                              ),
                              onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LineasPuntos(puntos: puntos))),
                                  },
                              child: Text('Lineas', style: TextStyle(color: Colors.white)))
                        ],
                      )
                    ],
                  ),
                )),
            // Dentro de esta propiedad usamos ClipRRect
          );
        });
  }
   Future<void> _pullRefresh() async {
     List<PuntoEstrategico> freshPoints = await puntoEstrategicoApi.cargarData();
     setState(() {
      futurePoints = Future.value(freshPoints);
    });
 }
}

Widget _buildPuntoEspecifico(PuntoEstrategico puntosEstrategicos, context) {
  final puntos = puntosEstrategicos;
  return Scaffold(
      appBar: AppBar(
        title: Text(puntos.nombre , style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: colorCabecera13,
      ),
      body: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        margin: EdgeInsets.all(15),
        elevation: 10,

        child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: ClipRRect(
              // Los bordes del contenido del card se cortan usando BorderRadius

              // widget hijo que será recortado segun la propiedad anterior
              child: Column(
                children: <Widget>[
                  // widget Image para mostrar una imagen
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(1),
                    child: Text(puntos.categoria,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  Container(
                    padding: EdgeInsets.all(1),
                    child: Text(puntos.zonasCBBA,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          puntos.descripcion,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextButton(
                          style: TextButton.styleFrom(
                            //primary: Colors.white,
                            backgroundColor: colorBoton,
                            //onSurface: Colors.blue.shade100,
                          ),
                          onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PuntosMarcadorGoogle(
                                            puntos: puntos,
                                          )),
                                )
                              },
                          child: Text('Puntos' ,style: TextStyle(color: Colors.white))),
                      SizedBox(
                        width: 15,
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                            //primary: Colors.white,
                            backgroundColor: colorCabecera13,
                            //onSurface: Colors.blue.shade100,
                          ),
                          onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LineasPuntos(puntos: puntos))),
                              },
                          child: Text('Lineas' ,style: TextStyle(color: Colors.white)))
                    ],
                  )
                ],
              ),
            )),
        // Dentro de esta propiedad usamos ClipRRect
      ));
}

// ignore: must_be_immutable
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
