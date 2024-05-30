import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_kaypi/provider/lineas_api.dart';
import 'package:flutter_kaypi/pages/lineasInfo/linea_page.dart';
import 'package:flutter_kaypi/pages/model/linea.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

const Color colorPage5 = Color.fromARGB(255, 239, 234, 225);
const Color colorCabecera5 = Color(0xFF387990);

class FormLineas extends StatefulWidget {
  const FormLineas({Key? key}) : super(key: key);

  @override
  _FormLineasState createState() => _FormLineasState();
}

class _FormLineasState extends State<FormLineas> {
  late Future<List<Linea>> futureLineas;
  List<Linea> lines = [];
  List<Linea> filteredLines = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    futureLineas = lineasApi.cargarData();
    futureLineas.then((data) {
      setState(() {
        lines = filteredLines = data;
        _sortLines();
      });
    });
  }

  void _filterLines(String value) {
    setState(() {
      filteredLines = lines
          .where((line) =>
          line.nombre.toLowerCase().contains(value.toLowerCase()))
          .toList();
      _sortLines();
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
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: colorPage5,
    extendBodyBehindAppBar: true,
    appBar: AppBar(
      backgroundColor: colorCabecera5,
      elevation: 0,
      title: !isSearching
          ? Text(
        'Líneas de Transporte',
        style: TextStyle(color: Colors.white),
      )
          : TextField(
        onChanged: (value) {
          _filterLines(value);
        },
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Colors.white),
          hintText: "Ejemplo: 120",
          hintStyle: TextStyle(
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
      actions: <Widget>[
        isSearching
            ? IconButton(
          icon: Icon(Icons.cancel),
          color: Colors.white,
          onPressed: () {
            setState(() {
              this.isSearching = false;
              filteredLines = lines;
              _sortLines();
            });
          },
        )
            : IconButton(
          icon: Icon(Icons.search),
          color: Colors.white,
          onPressed: () {
            setState(() {
              this.isSearching = true;
            });
          },
        )
      ],
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
      child: filteredLines.isNotEmpty
          ? ListView.builder(
        itemCount: filteredLines.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    LineaPage(linea: filteredLines[index]),
              ),
            ),
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 8),
                child: Text(
                  filteredLines[index].nombre,
                  style: TextStyle(
                      fontSize: 18, color: Colors.black),
                ),
              ),
            ),
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );

  List<String> items = [];
  List<String> listaCat = [];
  List<Linea> listaFinal = [];
  String dropdownvalue = "Todo";

  Widget _lista(context) => FutureBuilder<List<Linea>>(
    future: futureLineas,
    initialData: [],
    builder: (context, snapshot) {
      final lineas = snapshot.data;
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ));
        default:
          if (snapshot.hasError) {
            return Center(child: Text('Error'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No hay data'));
          }
          listaCat = getCategories(lineas!);
          items = listaCat;
          listaFinal = getLinesFromCat(dropdownvalue, lineas);
          _sortLines();
          return RefreshIndicator(
            child: ListView(children: [
              ListTile(
                tileColor: Colors.white,
                title: Text(
                  "Categorías",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                trailing: DropdownButton(
                  value: dropdownvalue,
                  iconSize: 35,
                  underline: Container(color: Colors.black, height: 1.5),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                        value: items, child: Text(items));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                      listaFinal =
                          getLinesFromCat(dropdownvalue, lineas);
                      _sortLines();
                    });
                  },
                ),
              ),
              Divider(
                height: 5.0,
                color: Colors.black,
              ),
              _buildLineas(listaFinal, context),
            ]),
            onRefresh: _pullRefresh,
          );
      }
    },
  );

  List<Linea> getLinesFromCat(String cat, List<Linea> lineas) {
    if (cat == "Todo") {
      return lineas;
    }
    return lineas.where((linea) => linea.categoria == cat).toList();
  }

  List<String> getCategories(List<Linea> lineas) {
    Set<String> categories = {"Todo"};
    for (var linea in lineas) {
      categories.add(linea.categoria);
    }
    return categories.toList();
  }

  Widget _buildLineas(List<Linea> lineas, context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: lineas.length,
      itemBuilder: (context, index) {
        final linea = lineas[index];
        return ListTile(
          tileColor: Colors.white,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LineaPage(linea: linea),
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: _getRandomColor(),
            child: Text(
              _getInitial(linea.nombre),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          title: Text(
            linea.nombre,
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          subtitle: Text(linea.categoria),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 30.0,
            color: Colors.black,
          ),
        );
      },
    );
  }

  String _getInitial(String nombre) {
    if (nombre.startsWith("Línea ")) {
      String lineName = nombre.substring(6);
      int? number = int.tryParse(lineName);
      if (number != null) {
        return '$number';
      } else {
        return lineName.substring(0, 1).toUpperCase();
      }
    } else {
      return nombre.substring(0, 1).toUpperCase();
    }
  }

  String _getTitle(String nombre) {
    return nombre.startsWith("Línea ") ? nombre.substring(6) : nombre;
  }

  Color _getRandomColor() {
    List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.yellow,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.brown,
    ];

    Random random = Random();
    return colors[random.nextInt(colors.length)];
  }

  Future<void> _pullRefresh() async {
    futureLineas = lineasApi.cargarData();
    futureLineas.then((data) {
      setState(() {
        lines = filteredLines = data;
        _sortLines();
      });
    });
  }
}
