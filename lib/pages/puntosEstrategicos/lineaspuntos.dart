import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_kaypi/pages/lineasInfo/linea_page.dart';
import 'package:flutter_kaypi/pages/model/linea.dart';
import 'package:flutter_kaypi/provider/lineas_api.dart';
import 'package:flutter_kaypi/pages/puntosEstrategicos/formpuntos.dart';

const Color colorPage13 = Color.fromARGB(255, 239, 234, 225);
const Color colorCabecera13 = Color(0xFF387990);

// ignore: must_be_immutable
class LineasPuntos extends StatefulWidget {
  var puntos;
  LineasPuntos({Key? key, required this.puntos}) : super(key: key);

  @override
  _LineasPuntosState createState() => _LineasPuntosState();
}

class _LineasPuntosState extends State<LineasPuntos> {
  late Future<List<Linea>> futureLineas;
  List<Linea> lines = [];
  List<Linea> filteredLines = [];

  @override
  void initState() {
    super.initState();
    futureLineas = lineasApi.cargarData();
    futureLineas.then((data) {
      setState(() {
        lines = filteredLines = data
            .where((f) => widget.puntos.lineas.contains(f.nombre))
            .toList();
        _sortLines();
      });
    });
  }

  void _sortLines() {
    filteredLines.sort((a, b) {
      final regex = RegExp(r'^Línea (\d+|\D)$');
      final matchA = regex.firstMatch(a.nombre);
      final matchB = regex.firstMatch(b.nombre);

      if (matchA != null && matchB != null) {
        final partA = matchA.group(1)!;
        final partB = matchB.group(1)!;

        final isNumA = int.tryParse(partA);
        final isNumB = int.tryParse(partB);

        if (isNumA != null && isNumB != null) {
          return isNumA.compareTo(isNumB);
        } else if (isNumA == null && isNumB == null) {
          return partA.compareTo(partB);
        } else {
          return isNumA == null ? -1 : 1;
        }
      }
      return a.nombre.compareTo(b.nombre);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: colorCabecera13, // Color de cabecera
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        title: Text(widget.puntos.nombre, style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: colorPage13, // Color de fondo
      body: _lista(context),
    );
  }

  Widget _lista(context) => FutureBuilder<List<Linea>>(
    future: futureLineas,
    initialData: [],
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return Center(child: CircularProgressIndicator());
        default:
          if (snapshot.hasError) {
            return Center(child: Text('Error'));
          }

          if (!snapshot.hasData || filteredLines.isEmpty) {
            return Center(child: Text('No hay data'));
          }

          return _buildLineas(filteredLines, context);
      }
    },
  );

  Widget _buildLineas(List<Linea> lineas, context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: lineas.length,
      itemBuilder: (context, index) {
        final linea = lineas[index];
        return ListTile(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LineaPage(
              linea: linea,
              p: widget.puntos,
            ),
          )),
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/img/KaypiLogoNegro.png'),
            backgroundColor: Colors.transparent,
          ),
          title: Text(
            linea.nombre,
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0)),
          ),
          subtitle: Text(linea.categoria),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 30.0,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        );
      },
    );
  }
}
