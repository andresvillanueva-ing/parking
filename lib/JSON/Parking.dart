import 'dart:convert';

Parking parkingFromMap(String str) => Parking.fromMap(json.decode(str));

String parkingToMap(Parking data) => json.encode(data.toMap());

class Parking {
  int? id;
  int? userId;
  String placa;
  String propietario;
  String modelo;
  String color;
  String? imagen; // base64 string

  Parking({
    this.id,
    this.userId,
    required this.placa,
    required this.propietario,
    required this.modelo,
    required this.color,
    required this.imagen,
  });

  factory Parking.fromMap(Map<String, dynamic> json) => Parking(
    id: json["id"],
    userId: json["userId"],
    placa: json["placa"],
    propietario: json["propietario"],
    modelo: json["modelo"],
    color: json["color"],
    imagen: json["imagen"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "userId": userId,
    "placa": placa,
    "propietario": propietario,
    "modelo": modelo,
    "color": color,
    "imagen": imagen,
  };

}

