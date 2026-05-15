import 'dart:convert';

import 'package:http/http.dart' as http;

class ExternalInfoResult {
  final String? descripcion;
  final String? fuente;

  const ExternalInfoResult({
    this.descripcion,
    this.fuente,
  });
}

class ExternalInfoService {
  static Future<ExternalInfoResult> buscarDescripcionPorNombre(
    String nombre,
  ) async {
    final es = await _buscarEnWikipedia(nombre, 'es');
    if (_esDescripcionValida(es.descripcion)) {
      return es;
    }

    return const ExternalInfoResult();
  }

  static Future<ExternalInfoResult> _buscarEnWikipedia(
    String nombre,
    String idioma,
  ) async {
    final url = Uri.parse(
      'https://$idioma.wikipedia.org/api/rest_v1/page/summary/${Uri.encodeComponent(nombre)}',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        return const ExternalInfoResult();
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final extract = data['extract'];

      if (extract is String && extract.trim().isNotEmpty) {
        return ExternalInfoResult(
          descripcion: extract.trim(),
          fuente: 'Wikipedia ($idioma)',
        );
      }
    } catch (_) {}

    return const ExternalInfoResult();
  }

  static bool _esDescripcionValida(String? texto) {
    if (texto == null) return false;
    final limpio = texto.trim();
    if (limpio.isEmpty) return false;
    if (limpio.split(' ').length < 12) return false;
    return true;
  }
}