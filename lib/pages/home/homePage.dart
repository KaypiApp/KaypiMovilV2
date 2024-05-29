import 'package:flutter/material.dart';
import 'package:flutter_kaypi/service/notification_services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:flutter_kaypi/pages/Routes/routesPage.dart';
import 'package:flutter_kaypi/pages/Routes/ruta.dart';

// Define los nuevos colores
//const Color primaryColor = Color(0xFFF2E6CF);
//const Color secondaryColor = Color(0xFF9CD2D3);
//const Color accentColor1 = Color(0xFF114C5F);

const Color primaryColor = Color(0xFFF2E6CF);
const Color secondaryColor = Color(0xFF9CD2D3);
const Color accentColor1 = Color(0xFF0E5C77);
const Color accentColor2 = Color.fromARGB(255, 13, 63, 80);

const Color colorboton1 = Color(0xFFF87465);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String id;
  late String nombreLinea;
  late String descripcion;

  @override
  void initState() {
    super.initState();
    // Aquí puedes inicializar tus variables id, nombreLinea y descripcion
    id = '1';
    nombreLinea = 'Línea de Prueba';
    descripcion = 'Descripción de la notificación de prueba';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () => ZoomDrawer.of(context)!.toggle(),
          child: Icon(
            Icons.menu,
            color: const Color.fromARGB(255, 0, 0, 0),
            size: 28,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              /*Colors.white,
              Colors.blue.shade400,
              Colors.blue.shade900,*/
              primaryColor,
              secondaryColor,
              accentColor1,
              accentColor2,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        height: double.infinity,
        width: double.infinity,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    //'assets/img/KaypiLogo.png',
                    'assets/img/Kaypi3D.png',
                    height: 220,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50, bottom: 40),
                ),
                Text(
                  '¿Qué Línea Tomar? ¿Dónde Bajar?',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                ),
                Text(
                  'Disfruta y siente la comodidad de elegir',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                ),
                Text(
                  'Cómo llegar a tu destino',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 100.0,
                ),
                ElevatedButton(
                  onPressed: () => ZoomDrawer.of(context)!.toggle(),
                  child: const Text(
                    'INICIAR',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: colorboton1, backgroundColor: Colors.transparent, // Color del texto
                    side: BorderSide(color: colorboton1), // Borde del color definido
                    fixedSize: Size(200, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
