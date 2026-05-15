class AIAnalysisResult {
  final String tipo;
  final String resultadoPrincipal;
  final List<String> alternativas;
  final int confianza;
  final String explicacion;

  const AIAnalysisResult({
    required this.tipo,
    required this.resultadoPrincipal,
    required this.alternativas,
    required this.confianza,
    required this.explicacion,
  });

  factory AIAnalysisResult.fromJson(Map<String, dynamic> json) {
    final confianzaRaw = json['confianza'];
    int confianza = 0;

    if (confianzaRaw is int) {
      confianza = confianzaRaw;
    } else if (confianzaRaw is double) {
      confianza = confianzaRaw.round();
    } else if (confianzaRaw is String) {
      confianza = int.tryParse(
            confianzaRaw.replaceAll('%', '').trim(),
          ) ??
          0;
    }

    if (confianza < 0) confianza = 0;
    if (confianza > 100) confianza = 100;

    final alternativasRaw = json['alternativas'];
    final alternativas = <String>[];

    if (alternativasRaw is List) {
      for (final item in alternativasRaw) {
        final texto = item.toString().trim();
        if (texto.isNotEmpty) {
          alternativas.add(texto);
        }
      }
    }

    return AIAnalysisResult(
      tipo: (json['tipo'] ?? 'desconocido').toString().trim(),
      resultadoPrincipal:
          (json['resultado_principal'] ?? 'Sin resultado').toString().trim(),
      alternativas: alternativas,
      confianza: confianza,
      explicacion:
          (json['explicacion'] ?? 'No se pudo generar explicación.')
              .toString()
              .trim(),
    );
  }
}