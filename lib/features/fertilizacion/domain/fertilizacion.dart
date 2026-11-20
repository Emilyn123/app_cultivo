//import 'dart:convert';

class Fertilizacion {
  final String id;
  final String producto;
  final double cantidad;
  final String unidad;
  final DateTime fechaHora;
  final String? notas;

  Fertilizacion({
    required this.id,
    required this.producto,
    required this.cantidad,
    required this.unidad,
    required this.fechaHora,
    this.notas,
  });

  // Convierte el objeto a un Mapa para guardarlo en SharedPreferences
  Map<String, dynamic> toJson() => {
    'id': id,
    'producto': producto,
    'cantidad': cantidad,
    'unidad': unidad,
    'fechaHora': fechaHora.toIso8601String(),
    'notas': notas,
  };

  // Crea el objeto desde un Mapa leído de SharedPreferences
  factory Fertilizacion.fromJson(Map<String, dynamic> json) => Fertilizacion(
    id: json['id'],
    producto: json['producto'],
    cantidad: (json['cantidad'] as num).toDouble(),
    unidad: json['unidad'],
    fechaHora: DateTime.parse(json['fechaHora']),
    notas: json['notas'],
  );
}
