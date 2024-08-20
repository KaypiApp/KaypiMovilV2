import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const Color colorPage4 = Color.fromARGB(255, 239, 234, 225);
const Color colorCabecera4 = Color(0xFF387990);

class InfoApp extends StatefulWidget {
  const InfoApp({Key? key}) : super(key: key);

  @override
  _InfoAppState createState() => _InfoAppState();
}

class _InfoAppState extends State<InfoApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPage4, // Color de fondo de la página
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Acerca de ",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: colorCabecera4, // Color de la cabecera
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
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/img/KaypiNegro.png',
                              width: 170,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/img/uni.png',
                              width: 150,
                              height: 150,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              '\n',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Versión 2.0',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 0, 0, 0),
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          miCard(),
                          Developers(),
                          Divider(
                            height: 90.0,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Otras Aplicaciones',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 30.0),
                          OtherApp1(),
                          OtherApp2(),

                          Divider(
                            height: 30.0,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          Conditions(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Card miCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(10),
      elevation: 10,
      child: Container(
        width: double.infinity, // Ajuste el ancho del Card al ancho disponible
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              width: 60,
              height: 60,
              child: FadeInImage(
                placeholder: AssetImage('assets/img/loading.gif'),
                image: AssetImage('assets/img/descargacocha.png'),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
                child: Text(
                  "Contribuciones\n\nGobierno Municipal de Cochabamba",
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card Developers() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(10),
      elevation: 10,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 40,
              height: 40,
              child: FadeInImage(
                placeholder: AssetImage('assets/img/loading.gif'),
                image: AssetImage('assets/img/uni.png'),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(10),
                child: Text(
                  "Desarrollado por:\nUniversidad Privada Del Valle\n\n"
                      "Desarrolladores:""\n\nVersión 2.0:\nMishel Bravo\nLaura Nuñez"
                      "\n\nVersión 1.0:\nGabriel Sebastian Clavijo\nLuis Ángel Jallasa\nMirko Marca\nMiguel Angel Terrazas\nHeidi Ivanna Huanca\nAxel Eddy Martinez\nCristopher Joaquin Jimenez\nEric Emmanuel Galleguillos\nSergio Lara Rocabado\nJimena Gonzales\nAxel Matias Miranda\nCarolina Vivian Escobar\nPaulo David Crespo\nNoemi Sanchez\nEdward Rene Jimenez\nMichel Sanabria",
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card OtherApp1() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(10),
      elevation: 10,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 60,
              height: 60,
              child: FadeInImage(
                placeholder: AssetImage('assets/img/loading.gif'),
                image: AssetImage('assets/img/maypi.webp'),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(5, 10, 40, 0),
                child: Text(
                  "MaypiVac \n",
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            Center(
              child: MaterialButton(
                color: colorCabecera4,
                textColor: Colors.white,
                child: Icon(
                  Icons.download,
                  size: 24,
                ),
                padding: EdgeInsets.all(16),
                shape: CircleBorder(),
                onPressed: () {
                  launch(
                    "https://play.google.com/store/apps/details?id=com.sedes.maypivac",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card OtherApp2() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(10),
      elevation: 10,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 50,
                  height: 50,
                  child: FadeInImage(
                    placeholder: AssetImage('assets/img/loading.gif'),
                    image: AssetImage('assets/img/MiAmigaApp.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(5, 10, 40, 0),
                    child: Text("Mi Amiga (Slim) \n",
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 16.0,
                      ),),
                  ),
                ),
                Center(
                  child: MaterialButton(
                    color: colorCabecera4,
                    textColor: Colors.white,
                    child: Icon(
                      Icons.download,
                      size: 24,
                    ),
                    padding: EdgeInsets.all(16),
                    shape: CircleBorder(),
                    onPressed: () {
                      launch(
                        "https://play.google.com/store/apps/details?id=com.umaunivalle.miamiga_app",
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card Conditions() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(10),
      elevation: 10,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Términos y Condiciones - Politica de Privacidad\n",
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  color: colorCabecera4,
                  textColor: Colors.white,
                  child: Icon(
                    Icons.manage_search,
                    size: 24,
                  ),
                  padding: EdgeInsets.all(16),
                  shape: CircleBorder(),
                  onPressed: () {
                    launch(
                      "https://umaunivalle.wordpress.com/2024/08/20/terminos-y-condiciones-de-uso-de-kaypi/",
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
