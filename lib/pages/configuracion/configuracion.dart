import 'package:flutter/material.dart';
import 'package:flutter_kaypi/pages/info/info.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:flutter_kaypi/pages/ayuda/ayudaKaypi.dart';

const Color colorPage = Color(0xFFf2e6cf);
const Color colorCabecera1 = Color(0xFF387990);

class Configuracion extends StatefulWidget {
  const Configuracion({Key? key}) : super(key: key);

  @override
  _ConfiguracionState createState() => _ConfiguracionState();
}

class _ConfiguracionState extends State<Configuracion> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          title: Text(
            "Información y Ayuda",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: colorCabecera1,
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
        body: Container(
          color: colorPage, 
          padding: const EdgeInsets.all(8), 
          child: ListView(
            children: <Widget>[
              SizedBox(height: 25),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20), 
                child: Card(
                  color: Color.fromARGB(255, 255, 255, 255), 
                  child: ListTile(
                    tileColor: Colors.transparent, 
                    leading: Icon(
                      Icons.help,
                      size: 30.0,
                      color: Colors.black,
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AyudaKaypi(),
                      ),
                    ),
                    title: Text(
                      "Ayuda",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 30.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20), 
                child: Card(
                  color: Color.fromARGB(255, 255, 255, 255), 
                  child: ListTile(
                    tileColor: Colors.transparent, 
                    leading: Icon(
                      Icons.info,
                      size: 30.0,
                      color: Colors.black,
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => InfoApp(),
                      ),
                    ),
                    title: Text(
                      "Acerca de",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 30.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
