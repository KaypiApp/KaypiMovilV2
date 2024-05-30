import 'package:flutter/material.dart';
import 'package:flutter_kaypi/pages/Routes/ruta.dart';
import 'package:flutter_kaypi/pages/ayuda/ayudaKaypi.dart';

const Color colorPage3 = Color.fromARGB(255, 239, 234, 225);
const Color colorCabecera3 = Color(0xFF387990);
const Color colorTitulo =Color(0xFF0E5C77);



class CardInfo extends StatefulWidget {
  late CardItem _cardItem;

  CardInfo(CardItem cardItem) {
    _cardItem = cardItem;
  }

  @override
  State<StatefulWidget> createState() {
    return CardInfoState(_cardItem);
  }
}

class CardInfoState extends State<CardInfo> {
  late CardItem _cardItem;

  CardInfoState(CardItem cardItem) {
    _cardItem = cardItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorCabecera3, // Color de la cabecera
        elevation: 0,
        title: Text(
          _cardItem.titulo,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: colorPage3, // Color de fondo de la página
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        child: Column(
                          children: [
                            new Column(
                              children: [
                                SizedBox(height: 20),
                                Hero(
                                  tag: _cardItem,
                                  child: Image.asset(
                                    _cardItem.imagen,
                                    height: 100,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  _cardItem.titulo.toUpperCase(),
                                  style: TextStyle(
                                      color: colorTitulo,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                            new Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _cardItem.info,
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Funcionalidades",
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                new Column(
                                  children: List.generate(
                                    _cardItem.listaFuncionalidades.length,
                                    (index) {
                                      return Container(
                                        child: new Column(
                                          children: [
                                            Text(
                                              _cardItem.listaFuncionalidades[
                                                      index]
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.grey.shade800,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Hero(
                                              tag: _cardItem,
                                              child: Image.asset(
                                                _cardItem.listaImagenes[index],
                                                height: 280,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
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
}
