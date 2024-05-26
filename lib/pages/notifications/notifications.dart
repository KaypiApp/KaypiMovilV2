import 'package:flutter/material.dart';
import 'package:flutter_kaypi/dbHelper/mongodb.dart';
import 'package:flutter_kaypi/service/notification_services.dart'; // Importa el archivo de servicios de notificación

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<Map<String, dynamic>> notifications = [];
  List<String> shownNotificationIds = [];

  Future<void> fetchNotifications() async {
    try {
      // Accede a la colección y obtén los datos
      var result = await MongoDatabase.notificacionCollection.find().toList();

      setState(() {
        notifications = result;
      });

      // Si hay nuevas notificaciones que no se han mostrado, muestra una notificación local
      for (var notification in result) {
        String id = notification['_id'].toString();
        if (!shownNotificationIds.contains(id)) {
          mostrarNotificacion(
            id,
            notification['nombreLinea'],
            notification['descripcion'],
          );
          shownNotificationIds.add(id);
        }
      }
    } catch (e) {
      // Manejo de errores
      print('Error fetching notifications: $e');
      // Puedes manejar el error según sea necesario
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Notificaciones'),
        ),
        body: notifications.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
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
                          Text(
                            notifications[index]['nombreLinea'],
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
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
