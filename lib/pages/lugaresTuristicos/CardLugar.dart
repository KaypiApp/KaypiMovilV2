import 'package:flutter/material.dart';
import 'package:flutter_kaypi/pages/lugaresTuristicos/listaLugaresTuristicos.dart';
import 'package:flutter_kaypi/pages/lugaresTuristicos/puntoSearch.dart';
import 'package:url_launcher/url_launcher.dart';

const Color colorPage9 = Color.fromARGB(255, 239, 234, 225);
const Color colorCabecera9 = Color(0xFF387990);

const Color colorBordeBoton = Color(0xFF387990);
const Color colorFondoBoton = Color.fromARGB(255, 239, 234, 225);

class CardLugar extends StatefulWidget {
  late Lugar _lugar;

  CardLugar(Lugar lugar) {
    _lugar = lugar;
  }

  @override
  State<StatefulWidget> createState() {
    return CardLugarState(_lugar);
  }
}

class CardLugarState extends State<CardLugar> {
  late Lugar _lugar;

  CardLugarState(Lugar lugar) {
    _lugar = lugar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPage9,
      appBar: AppBar(
        backgroundColor: colorCabecera9,
        elevation: 0,
        title: Text(
          _lugar.titulo,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        child: Column(
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 20),
                                Hero(
                                  tag: _lugar,
                                  child: Image.asset(
                                    _lugar.imagen,
                                    height: 100,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  _lugar.titulo.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  child: Text(
                                    "Ver Ubicación",
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    launch(_lugar.ubicacion);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    animationDuration: Duration(seconds: 4),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: colorBordeBoton,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    backgroundColor: colorFondoBoton,
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _lugar.info,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(height: 10),
                                SizedBox(height: 10),
                                Column(
                                  children: List.generate(
                                    _lugar.listaFuncionalidades.length,
                                    (index) {
                                      return Container(
                                        child: Column(
                                          children: [
                                            Text(
                                              _lugar.listaFuncionalidades[index]
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Hero(
                                              tag: _lugar,
                                              child: Image.asset(
                                                _lugar.listaImagenes[index],
                                                height: 280,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                  child: Text(
                                    "Más Información",
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    launch(_lugar.infoSitio);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    animationDuration: Duration(seconds: 4),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: colorBordeBoton,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    backgroundColor: colorFondoBoton,
                                  ),
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  child: Text(
                                    "Encontrar Punto Estrategico",
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PuntoSearch(lugar: _lugar),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    animationDuration: Duration(seconds: 4),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: colorBordeBoton,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    backgroundColor: colorFondoBoton,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}