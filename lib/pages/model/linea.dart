class Linea {
  final String nombre;
  final String categoria;
  final List<String> telefonos;
  final List<String> pasajes;
  final List<String> horarios;
  final List<String> calles;
  final String imagen;
  final List<String> zonasCBBA;
  final List<Ruta> ruta;

  const Linea({
    required this.nombre,
    required this.categoria,
    required this.telefonos,
    required this.pasajes,
    required this.horarios,
    required this.calles,
    required this.imagen,
    required this.zonasCBBA,
    required this.ruta,
  });

  factory Linea.fromJson(Map<String, dynamic> json) {
    var list = json['Rutas'] as List;
    List<Ruta> rutasList = list.map((ruta) => Ruta.fromJson(ruta)).toList();
    return new Linea(
      nombre: json['Nombre'],
      categoria: json['Categoria'],
      telefonos: List<String>.from(json['Telefonos']),
      pasajes: List<String>.from(json['Pasajes']),
      horarios: List<String>.from(json['Horarios']),
      calles: List<String>.from(json['Calles']),
      imagen: json['Imagen'],
      zonasCBBA: List<String>.from(json['ZonasCBBA']),
      ruta: rutasList,
    );
  }
}

class Ruta {
  final String sentido;
  final String color;
  final List<Puntos> puntos;

  Ruta({
    required this.sentido,
    required this.color,
    required this.puntos,
  });

  factory Ruta.fromJson(Map<String, dynamic> json) {
    var list = json['Puntos'] as List;
    List<Puntos> puntosList = list.map((puntos) => Puntos.fromJson(puntos)).toList();
    return new Ruta(
      sentido: json['Sentido'].toString(),
      color: json['Color'].toString(),
      puntos: puntosList,
    );
  }
}

class Puntos {
  final double lat;
  final double lng;

  Puntos({
    required this.lat,
    required this.lng,
  });

  factory Puntos.fromJson(Map<String, dynamic> json) {
    return new Puntos(
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
    );
  }
}
