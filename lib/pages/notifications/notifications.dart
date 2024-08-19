import 'package:flutter/material.dart';
import 'package:flutter_kaypi/dbHelper/mongodb.dart';
import 'package:flutter_kaypi/service/notification_services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

const Color colorPage12 = Color.fromARGB(255, 239, 234, 225);
const Color colorCabecera12 = Color(0xFF387990);

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true; // Variable para manejar el estado de carga
  String errorMessage = ''; // Variable para manejar mensajes de error

  Future<void> fetchNotifications() async {
    try {
      // Accede a la colección y obtén todos los datos de las notificaciones
      print('Intentando obtener notificaciones...');
      var result = await MongoDatabase.notificacionCollection.find().toList();
      print('Notificaciones obtenidas: ${result.length}');
      print('Datos de las notificaciones: $result');

      setState(() {
        notifications = result;
        isLoading =
            false; // Desactivar estado de carga cuando los datos se obtienen correctamente
      });

      // Si hay nuevas notificaciones que no se han mostrado, muestra una notificación local
      for (var notification in result) {
        String id = notification['_id'].toString();

        // Si la notificación no ha sido enviada, muestra la notificación y actualiza el estado
        if (!notification['isSent']) {
          mostrarNotificacion(
            id,
            notification['nombreLinea'],
            notification['descripcion'],
          );

          // Marca la notificación como enviada
          await MongoDatabase.notificacionCollection.updateOne(
            {'_id': notification['_id']},
            {
              r'$set': {'isSent': true}
            },
          );
        }
      }
    } catch (e) {
      // Manejo de errores
      print(
          'Error fetching notifications: $e'); // Añadir mensaje de error en la consola
      setState(() {
        isLoading = false; // Desactivar estado de carga en caso de error
        errorMessage = 'Error fetching notifications: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initNotifications(); // Inicializar notificaciones
    fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          title: Text(
            "Notificaciones",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: colorCabecera12, // Color de cabecera
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
        backgroundColor: colorPage12, // Color de fondo
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    notifications[index]['isSent']
                                        ? Icons.check
                                        : Icons
                                            .pending, // Icono de verificación si la notificación ha sido enviada
                                    color: notifications[index]['isSent']
                                        ? Colors.green
                                        : Colors
                                            .red, // Color verde si la notificación ha sido enviada, rojo si no
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    notifications[index]['nombreLinea'],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                notifications[index]['descripcion'],
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
