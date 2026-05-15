import 'dart:convert';

class SavedAnalysis {
  final String nombre;
  final String tipo;
  final String fecha;
  final String imagePath;
  final String descripcion;
  final String formula;
  final String dureza;
  final String brillo;
  final String color;
  final String usos;
  final String dondeSeEncuentra;

  SavedAnalysis({
    required this.nombre,
    required this.tipo,
    required this.fecha,
    required this.imagePath,
    required this.descripcion,
    required this.formula,
    required this.dureza,
    required this.brillo,
    required this.color,
    required this.usos,
    required this.dondeSeEncuentra,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'tipo': tipo,
      'fecha': fecha,
      'imagePath': imagePath,
      'descripcion': descripcion,
      'formula': formula,
      'dureza': dureza,
      'brillo': brillo,
      'color': color,
      'usos': usos,
      'dondeSeEncuentra': dondeSeEncuentra,
    };
  }

  factory SavedAnalysis.fromMap(Map<String, dynamic> map) {
    return SavedAnalysis(
      nombre: map['nombre'] ?? '',
      tipo: map['tipo'] ?? '',
      fecha: map['fecha'] ?? '',
      imagePath: map['imagePath'] ?? '',
      descripcion: map['descripcion'] ?? '',
      formula: map['formula'] ?? '',
      dureza: map['dureza'] ?? '',
      brillo: map['brillo'] ?? '',
      color: map['color'] ?? '',
      usos: map['usos'] ?? '',
      dondeSeEncuentra: map['dondeSeEncuentra'] ?? '',
    );
  }

  String toJson() => jsonEncode(toMap());

  factory SavedAnalysis.fromJson(String source) =>
      SavedAnalysis.fromMap(jsonDecode(source));
}