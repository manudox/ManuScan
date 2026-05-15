import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/ai_analysis_result.dart';

class GeminiService {
  static const String apiKey = 'AIzaSyBe9HKMN78HR1PEK2rEZNsByH4x-MdqF_8';

  static Future<AIAnalysisResult> analizarImagenConContexto({
    required String imagePath,
    required String color,
    required String brillo,
    required String textura,
    required String zona,
    required String observaciones,
  }) async {
    final file = File(imagePath);

    if (!await file.exists()) {
      throw Exception('No se encontró la imagen seleccionada.');
    }

    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);
    final mimeType = _detectarMimeType(imagePath);

    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent',
    );

    final prompt = '''
Analiza esta imagen de una muestra geológica usando también el contexto del usuario.

Datos del usuario:
- Color predominante: $color
- Brillo: $brillo
- Textura: $textura
- Zona donde se encontró: $zona
- Observaciones: $observaciones

Instrucciones:
- Responde SOLO en español.
- Devuelve SOLO JSON válido.
- La confianza debe ser un número entero entre 40 y 95.
- La explicación debe tener entre 10 y 18 palabras.

Usa exactamente esta estructura:
{
  "tipo": "mineral",
  "resultado_principal": "nombre",
  "alternativas": ["opcion 1", "opcion 2"],
  "confianza": 75,
  "explicacion": "explicación breve en español"
}
''';

    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'x-goog-api-key': apiKey,
          },
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': prompt},
                  {
                    'inline_data': {
                      'mime_type': mimeType,
                      'data': base64Image,
                    }
                  }
                ]
              }
            ]
          }),
        )
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () {
            throw Exception('Gemini tardó demasiado en responder.');
          },
        );

    if (response.statusCode != 200) {
      throw Exception(_traducirErrorHttp(response.statusCode, response.body));
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final candidates = data['candidates'];

    if (candidates is! List || candidates.isEmpty) {
      throw Exception('Gemini no devolvió candidatos.');
    }

    final content = candidates.first['content'];
    final parts = content['parts'];

    if (parts is! List || parts.isEmpty) {
      throw Exception('Gemini respondió sin contenido útil.');
    }

    final rawText = parts.first['text']?.toString() ?? '';
    final parsed = _extraerJsonSeguro(rawText);
    final result = AIAnalysisResult.fromJson(parsed);

    return AIAnalysisResult(
      tipo: result.tipo.isEmpty ? 'mineral' : result.tipo,
      resultadoPrincipal: result.resultadoPrincipal,
      alternativas: result.alternativas,
      confianza: _normalizarConfianza(result.confianza),
      explicacion: result.explicacion.isEmpty
          ? 'Resultado estimado según imagen y respuestas del usuario.'
          : result.explicacion,
    );
  }

  static String _detectarMimeType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }

  static int _normalizarConfianza(int confianza) {
    if (confianza <= 0) return 70;
    if (confianza < 40) return 40;
    if (confianza > 95) return 95;
    return confianza;
  }

  static Map<String, dynamic> _extraerJsonSeguro(String rawText) {
    final cleanText = rawText
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    try {
      return jsonDecode(cleanText) as Map<String, dynamic>;
    } catch (_) {
      final inicio = cleanText.indexOf('{');
      final fin = cleanText.lastIndexOf('}');

      if (inicio != -1 && fin != -1 && fin > inicio) {
        final recortado = cleanText.substring(inicio, fin + 1);
        return jsonDecode(recortado) as Map<String, dynamic>;
      }
    }

    throw Exception('Gemini devolvió un formato inválido.');
  }

  static String _traducirErrorHttp(int code, String body) {
    final lower = body.toLowerCase();

    if (code == 400) {
      if (lower.contains('api_key_invalid')) {
        return 'La clave de Gemini no es válida.';
      }
      return 'Gemini recibió una solicitud inválida.';
    }

    if (code == 401 || code == 403) {
      return 'La clave de Gemini no tiene permisos.';
    }

    if (code == 429) {
      return 'Gemini está saturado por demasiadas solicitudes.';
    }

    if (code == 500 || code == 502 || code == 503) {
      return 'Gemini está temporalmente saturado.';
    }

    return 'Gemini no pudo completar el análisis.';
  }
}