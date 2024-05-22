import 'package:flutter/material.dart';
import 'package:flutter_kaypi/pages/info/info.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:flutter_kaypi/pages/ayuda/ayudaKaypi.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(

            extendBodyBehindAppBar: false,
            appBar: AppBar(
              title: Text("Información y Ayuda",
                  style: TextStyle(
                    color: Colors.white,
                  )),
              backgroundColor: Colors.blue.shade900,
              elevation: 0,
              leading: InkWell(
                onTap: () => ZoomDrawer.of(context)!.toggle(),
                child: Icon(Icons.menu, color: Colors.white, size: 28,),
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.all(8),
              children:<Widget> [
                Container(),
                SizedBox(
                  width: 200,
                ),

                SizedBox(
                  width: 200,
                ),
                ListTile(
                  tileColor: Colors.white,
                  leading:
                  Icon(
                    Icons.help,
                    size: 30.0,
                    color: Colors.blue.shade900,
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AyudaKaypi(),
                  )),
                  title: Text(
                    "Ayuda",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 30.0,
                    color: Colors.blue.shade900,
                  ),
                ),
                ListTile(
                  tileColor: Colors.white,
                  leading:
                  Icon(
                    Icons.info,
                    size: 30.0,
                    color: Colors.blue.shade900,
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => InfoApp(),
                  )),
                  title: Text(
                    "Acerca de",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 30.0,
                    color: Colors.blue.shade900,
                  ),
                )
              ],
            )
        ));
  }
}

