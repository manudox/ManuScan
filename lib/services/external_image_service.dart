import 'dart:convert';

import 'package:http/http.dart' as http;

class ExternalImageService {
  static const List<String> _idiomas = ['es', 'en'];

  static Future<String?> buscarImagenPorNombre(String nombre) async {
    for (final idioma in _idiomas) {
      final url = Uri.parse(
        'https://$idioma.wikipedia.org/api/rest_v1/page/summary/${Uri.encodeComponent(nombre)}',
      );

      try {
        final response = await http.get(url);

        if (response.statusCode != 200) {
          continue;
        }

        final data = jsonDecode(response.body);

        if (data is Map<String, dynamic>) {
          final thumbnail = data['thumbnail'];
          if (thumbnail is Map<String, dynamic>) {
            final source = thumbnail['source'];
            if (source is String && source.isNotEmpty) {
              return source;
            }
          }

          final originalImage = data['originalimage'];
          if (originalImage is Map<String, dynamic>) {
            final source = originalImage['source'];
            if (source is String && source.isNotEmpty) {
              return source;
            }
          }
        }
      } catch (_) {}
    }

    return null;
  }
}