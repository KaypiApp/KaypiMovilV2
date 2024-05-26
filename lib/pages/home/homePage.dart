import 'package:flutter/material.dart';
import 'package:flutter_kaypi/service/notification_services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:flutter_kaypi/pages/Routes/routesPage.dart';
import 'package:flutter_kaypi/pages/Routes/ruta.dart';

//referencia a la vista ventana_prueba en pages

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
            color: Colors.blue.shade900,
            size: 28,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.blue.shade400,
              Colors.blue.shade900,
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
                    'assets/img/KaypiLogo.png',
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
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    fixedSize: Size(200, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                SizedBox(height: 20), // Espacio entre botones
                ElevatedButton(
                  onPressed: () {
                    // Método para mostrar notificaciones
                    mostrarNotificacion(id, nombreLinea, descripcion);
                    print("Se mandó la notificación");
                  },
                  child: Text('Mostrar Notificaciones'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
