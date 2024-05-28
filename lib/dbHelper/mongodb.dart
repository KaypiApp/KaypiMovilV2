import 'dart:developer';

import 'package:flutter_kaypi/dbHelper/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static var db, notificacionCollection;
  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    notificacionCollection = db.collection(NOTIFICACION_COLLECTION);
  }
}
