class Mineral {
  final String nombre;
  final String tipo;
  final String formula;
  final String dureza;
  final String brillo;
  final String color;
  final String descripcion;
  final String usos;
  final String dondeSeEncuentra;

  final String? imagenAsset;
  final String? imagenUrl;
  final String? descripcionExtra;
  final String? fuenteInfo;
  final String? fuenteImagen;
  final String? nombreBusqueda;

  const Mineral({
    required this.nombre,
    required this.tipo,
    required this.formula,
    required this.dureza,
    required this.brillo,
    required this.color,
    required this.descripcion,
    required this.usos,
    required this.dondeSeEncuentra,
    this.imagenAsset,
    this.imagenUrl,
    this.descripcionExtra,
    this.fuenteInfo,
    this.fuenteImagen,
    this.nombreBusqueda,
  });

  Mineral copyWith({
    String? nombre,
    String? tipo,
    String? formula,
    String? dureza,
    String? brillo,
    String? color,
    String? descripcion,
    String? usos,
    String? dondeSeEncuentra,
    String? imagenAsset,
    String? imagenUrl,
    String? descripcionExtra,
    String? fuenteInfo,
    String? fuenteImagen,
    String? nombreBusqueda,
  }) {
    return Mineral(
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      formula: formula ?? this.formula,
      dureza: dureza ?? this.dureza,
      brillo: brillo ?? this.brillo,
      color: color ?? this.color,
      descripcion: descripcion ?? this.descripcion,
      usos: usos ?? this.usos,
      dondeSeEncuentra: dondeSeEncuentra ?? this.dondeSeEncuentra,
      imagenAsset: imagenAsset ?? this.imagenAsset,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      descripcionExtra: descripcionExtra ?? this.descripcionExtra,
      fuenteInfo: fuenteInfo ?? this.fuenteInfo,
      fuenteImagen: fuenteImagen ?? this.fuenteImagen,
      nombreBusqueda: nombreBusqueda ?? this.nombreBusqueda,
    );
  }
}