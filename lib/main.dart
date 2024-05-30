import 'package:flutter/material.dart';
import 'package:flutter_kaypi/dbHelper/mongodb.dart';
//import 'package:flutter_kaypi/pages/Routes/routesPage.dart';
import 'package:flutter_kaypi/zoom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kaypi/service/notification_services.dart';
import 'package:flutter_kaypi/pages/notifications/notifications.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await MongoDatabase.connect();
    print("Conexión exitosa a MongoDB Atlas");
  } catch (e) {
    print("Error al conectar a MongoDB Atlas: $e");
  }

  // Inicializa las notificaciones locales
  await initNotifications();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaypi',
      theme: ThemeData.light(),
      home: MenuZoom(),
      debugShowCheckedModeBanner: false,
    );
  }
}


/*Para la build de una apk 
flutter build apk --release --no-sound-null-safety
Para la ejecucion del proyecto
flutter run --no-sound-null-safety
*/








