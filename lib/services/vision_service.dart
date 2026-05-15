import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/ai_analysis_result.dart';

class VisionService {
  static const String apiKey = 'AIzaSyBubeBkq5OETjqTaaVXPVAStH4b6GSy5xU';

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
      throw Exception('No se encontró la imagen para el respaldo.');
    }

    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);

    final uri = Uri.parse(
      'https://vision.googleapis.com/v1/images:annotate?key=$apiKey',
    );

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "requests": [
              {
                "image": {"content": base64Image},
                "features": [
                  {"type": "LABEL_DETECTION", "maxResults": 10}
                ]
              }
            ]
          }),
        )
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () {
            throw Exception('Vision tardó demasiado en responder.');
          },
        );

    if (response.statusCode != 200) {
      final body = response.body.toLowerCase();

      if (body.contains('api key not valid')) {
        throw Exception('La clave de Vision no es válida.');
      }

      if (body.contains('referer') || body.contains('ip referer')) {
        throw Exception('La clave de Vision tiene restricciones que bloquean la app.');
      }

      if (body.contains('cloud vision api has not been used') ||
          body.contains('is not enabled')) {
        throw Exception('Cloud Vision API no está habilitada en tu proyecto.');
      }

      throw Exception('Vision API no pudo analizar la imagen.');
    }

    final data = jsonDecode(response.body);
    final responses = data['responses'];

    if (responses is! List || responses.isEmpty) {
      throw Exception('Vision no devolvió respuestas.');
    }

    final first = responses.first;

    if (first['error'] != null) {
      final message = first['error']['message']?.toString() ?? '';
      throw Exception('Vision respondió con error: $message');
    }

    final etiquetas = <String>[];
    final labelAnnotations = first['labelAnnotations'];

    if (labelAnnotations is List) {
      for (final item in labelAnnotations) {
        final desc = item['description'];
        if (desc is String && desc.trim().isNotEmpty) {
          etiquetas.add(desc.toLowerCase().trim());
        }
      }
    }

    if (etiquetas.isEmpty) {
      throw Exception('Vision no encontró etiquetas útiles.');
    }

    return _inferirResultado(
      etiquetas: etiquetas,
      color: color,
      brillo: brillo,
      textura: textura,
      zona: zona,
      observaciones: observaciones,
    );
  }

  static AIAnalysisResult _inferirResultado({
    required List<String> etiquetas,
    required String color,
    required String brillo,
    required String textura,
    required String zona,
    required String observaciones,
  }) {
    final textoEtiquetas = etiquetas.join(' ').toLowerCase();
    final obs = observaciones.toLowerCase();

    int scoreOro = 0;
    int scorePirita = 0;
    int scoreCuarzo = 0;
    int scoreCalcita = 0;

    if (textoEtiquetas.contains('gold')) scoreOro += 40;
    if (textoEtiquetas.contains('metal')) {
      scoreOro += 12;
      scorePirita += 12;
    }
    if (textoEtiquetas.contains('yellow')) {
      scoreOro += 14;
      scorePirita += 14;
    }
    if (textoEtiquetas.contains('crystal')) scoreCuarzo += 25;
    if (textoEtiquetas.contains('quartz')) scoreCuarzo += 40;
    if (textoEtiquetas.contains('white')) {
      scoreCalcita += 15;
      scoreCuarzo += 10;
    }

    if (color == 'Amarillo') {
      scoreOro += 16;
      scorePirita += 16;
    }
    if (color == 'Transparente') scoreCuarzo += 18;
    if (color == 'Blanco') {
      scoreCalcita += 16;
      scoreCuarzo += 12;
    }

    if (brillo == 'Metálico') {
      scoreOro += 18;
      scorePirita += 18;
    }
    if (brillo == 'Vítreo') {
      scoreCuarzo += 18;
      scoreCalcita += 8;
    }

    if (textura == 'Cristalina') {
      scoreCuarzo += 18;
      scorePirita += 10;
    }

    if (zona == 'Río o aluvial') scoreOro += 14;
    if (zona == 'Zona minera') {
      scoreOro += 8;
      scorePirita += 8;
    }

    if (obs.contains('oro')) scoreOro += 24;
    if (obs.contains('pirita')) scorePirita += 20;
    if (obs.contains('cristal')) scoreCuarzo += 15;
    if (obs.contains('pesa mucho')) {
      scoreOro += 10;
      scorePirita += 8;
    }

    final resultados = <MapEntry<String, int>>[
      MapEntry('Oro', scoreOro),
      MapEntry('Pirita', scorePirita),
      MapEntry('Cuarzo', scoreCuarzo),
      MapEntry('Calcita', scoreCalcita),
    ]..sort((a, b) => b.value.compareTo(a.value));

    final principal = resultados.first;
    final alternativas = resultados.skip(1).take(2).map((e) => e.key).toList();

    return AIAnalysisResult(
      tipo: 'mineral',
      resultadoPrincipal: principal.key,
      alternativas: alternativas,
      confianza: principal.value.clamp(45, 85),
      explicacion:
          'Resultado estimado con análisis visual de respaldo y respuestas del usuario.',
    );
  }
}