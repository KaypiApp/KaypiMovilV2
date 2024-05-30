import 'package:flutter/material.dart';
import 'package:flutter_kaypi/pages/lineasInfo/linea_ruta.dart';
import 'package:flutter_kaypi/pages/mapaRuta/Rutas.dart';
import 'package:flutter_kaypi/pages/model/linea.dart';
import 'package:flutter_kaypi/pages/model/puntoEstrategico.dart';

const Color colorPage6 = Color.fromARGB(255, 239, 234, 225);
const Color colorCabecera6 = Color(0xFF387990);


class LineaPage extends StatelessWidget {
  PuntoEstrategico? p;
  final Linea linea;

  LineaPage({
    Key? key,
    required this.linea,
    this.p,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: colorCabecera6,
          title: Text(
            linea.nombre,
            style: TextStyle(color: Colors.white),
          ),
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
        backgroundColor: colorPage6,
        body: _detalleLineaView(context),
      );

  Widget _detalleLineaView(BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 100, horizontal: 16), // Ajuste del padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 30), // Nuevo padding superior
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/img/KaypiLogoNegro.png'),
                backgroundColor: Colors.transparent,
                radius: 80,
              ),
            ),
            const SizedBox(height: 25),
            Text(
              linea.nombre,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            _buildCard('CATEGORIA', linea.categoria),
            _buildCard('PASAJES', linea.pasajes.join('\n')),
            _buildCard('HORARIOS', linea.horarios.join('\n')),
            _buildCard('CALLES', linea.calles.join('\n')),
            _buildCard('TELEFONOS', linea.telefonos.join('\n')),
            _buildCard('ZONA', linea.zonasCBBA.join('\n')),
            const SizedBox(height: 25),
            ElevatedButton(
              child: Text(
                'RUTAS',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LineaRuta(
                      newdata: p,
                    ),
                    settings: RouteSettings(arguments: linea),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorCabecera6,
              ),
            ),
          ],
        ),
      );

  Widget _buildCard(String title, String content) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
