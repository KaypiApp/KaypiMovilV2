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
                          miCard2(),
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
                          miCard3(),
                          miCardDesign(),
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

  Card miCard2() {
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

  Card miCard3() {
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
              width: 30,
              height: 30,
              child: FadeInImage(
                placeholder: AssetImage('assets/img/loading.gif'),
                image: AssetImage('assets/img/tramitecochabamba.png'),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.fromLTRB(5, 10, 40, 0),
                child: Text(
                  "Trámites Cochabamba\n\n",
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            Center(
              child: MaterialButton(
                color: Colors.blueAccent,
                textColor: Colors.white,
                child: Icon(
                  Icons.download,
                  size: 24,
                ),
                padding: EdgeInsets.all(16),
                shape: CircleBorder(),
                onPressed: () {
                  launch(
                    "https://play.google.com/store/apps/details?id=bo.tramitesco.chabamba&hl=es&gl=US",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///instanciacion de la clase micardDesign
  Card miCardDesign() {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 30,
                  height: 30,
                  child: FadeInImage(
                    placeholder: AssetImage('assets/img/loading.gif'),
                    image: AssetImage('assets/img/ciudadanoac.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.fromLTRB(5, 10, 40, 0),
                    child: Text("Ciudadano Activo\n\n",
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 16.0,
                      ),),
                  ),
                ),
                Center(
                  child: MaterialButton(
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: Icon(
                      Icons.download,
                      size: 24,
                    ),
                    padding: EdgeInsets.all(16),
                    shape: CircleBorder(),
                    onPressed: () {
                      launch(
                        "https://play.google.com/store/apps/details?id=com.gamc.ciudadanoactivo&hl=es_BO&gl=US",
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

}
