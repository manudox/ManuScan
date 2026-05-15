import 'dart:io';

import 'package:flutter/material.dart';

import '../data/minerals_data.dart';
import '../models/ai_analysis_result.dart';
import '../models/mineral.dart';
import '../services/gemini_service.dart';
import '../services/usage_service.dart';
import '../services/vision_service.dart';
import 'mineral_detail_screen.dart';

class IntelligentAnalysisScreen extends StatefulWidget {
  final String imagePath;

  const IntelligentAnalysisScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<IntelligentAnalysisScreen> createState() =>
      _IntelligentAnalysisScreenState();
}

class _IntelligentAnalysisScreenState extends State<IntelligentAnalysisScreen> {
  String? _color;
  String? _brillo;
  String? _textura;
  String? _zona;
  final TextEditingController _observacionesController =
      TextEditingController();

  bool _cargando = false;
  AIAnalysisResult? _resultado;
  String? _errorBonito;

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  Mineral? _buscarEnBase(String nombre) {
    final textoOriginal = nombre.toLowerCase().trim();
    final texto = textoOriginal
        .replaceAll('nativo', '')
        .replaceAll('natural', '')
        .replaceAll('mineral', '')
        .replaceAll('roca', '')
        .trim();

    for (final item in mineralesData) {
      final nombreLocal = item.nombre.toLowerCase().trim();

      if (texto.contains(nombreLocal) || nombreLocal.contains(texto)) {
        return item;
      }

      if (item.nombreBusqueda != null &&
          item.nombreBusqueda!.trim().isNotEmpty) {
        final busqueda = item.nombreBusqueda!.toLowerCase().trim();

        if (texto.contains(busqueda) || busqueda.contains(texto)) {
          return item;
        }
      }
    }

    return null;
  }

  Future<void> _analizar() async {
  if (_color == null || _brillo == null || _textura == null || _zona == null) {
    _mostrarErrorBonito('Completa las preguntas principales antes de analizar.');
    return;
  }
if (_zona == null) {
  _mostrarErrorBonito(
    'Selecciona la ubicación donde encontraste la muestra.',
  );
  return;
}
  final puede = await UsageService.puedeUsar();
  if (!puede) {
    _mostrarErrorBonito('Ya usaste tus análisis de hoy.');
    return;
  }

  setState(() {
    _cargando = true;
    _errorBonito = null;
    _resultado = null;
  });

  try {
    AIAnalysisResult result;

    try {
      print('🚀 Intentando GEMINI...');
      result = await GeminiService.analizarImagenConContexto(
        imagePath: widget.imagePath,
        color: _color!,
        brillo: _brillo!,
        textura: _textura!,
        zona: _zona!,
        observaciones: _observacionesController.text.trim(),
      );
      print('✅ GEMINI OK');
    } catch (e) {
      print('❌ GEMINI FALLÓ → usando análisis local');

      // 🔥 fallback LOCAL (rápido, sin internet)
      result = AIAnalysisResult(
        tipo: 'mineral',
        resultadoPrincipal: _color == 'Amarillo'
            ? 'Posible oro o pirita'
            : _color == 'Blanco'
                ? 'Cuarzo o calcita'
                : 'Mineral no identificado',
        alternativas: ['Reintentar análisis', 'Tomar otra foto'],
        confianza: 55,
        explicacion:
            'Resultado estimado localmente por color, brillo y textura.',
      );

      // 🔁 intentar Vision SIN BLOQUEAR
      VisionService.analizarImagenConContexto(
        imagePath: widget.imagePath,
        color: _color!,
        brillo: _brillo!,
        textura: _textura!,
        zona: _zona!,
        observaciones: _observacionesController.text.trim(),
      ).then((visionResult) {
        print('🔁 Vision respondió después');

        if (mounted) {
          setState(() {
            _resultado = visionResult;
          });
        }
      }).catchError((err) {
        print('❌ Vision también falló (no pasa nada)');
      });
    }

    await UsageService.consumirUso();

    if (!mounted) return;
    setState(() {
      _resultado = result;
    });
  } catch (e) {
    if (!mounted) return;
    _mostrarErrorBonito(e.toString());
  } finally {
    if (!mounted) return;
    setState(() {
      _cargando = false;
    });
  }
}

  void _mostrarErrorBonito(String mensaje) {
    String limpio = mensaje;

    if (limpio.contains('Future not completed') ||
        limpio.contains('tardó demasiado')) {
      limpio =
          'La IA se demoró demasiado en responder. Intenta otra vez en unos segundos.';
    }

    if (limpio.contains('La solicitud enviada a la IA no fue válida')) {
      limpio =
          'La IA no pudo procesar esta imagen con esos datos en este intento. Vuelve a intentarlo o cambia un poco las observaciones.';
    }

    if (limpio.contains('La IA respondió en un formato inesperado')) {
      limpio =
          'La IA respondió de forma irregular. Intenta nuevamente y debería corregirse.';
    }

    if (limpio.contains('La IA está temporalmente saturada')) {
      limpio =
          'La IA está temporalmente ocupada. Espera unos segundos e inténtalo otra vez.';
    }

    if (limpio.contains('La clave de Gemini no es válida')) {
      limpio =
          'La clave de Gemini no es válida. Revisa la API key de Google AI Studio.';
    }

    if (limpio.contains('Vision API')) {
      limpio =
          'El análisis de respaldo no pudo completarse. Revisa la API key de Vision o vuelve a intentarlo.';
    }

    setState(() {
      _errorBonito = limpio;
    });
  }

  Widget _titulo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _ayuda(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 13.5,
          color: Colors.white70,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _tarjetaError() {
    if (_errorBonito == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1116),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF7A2633)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFFF7A7A)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorBonito!,
              style: const TextStyle(
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _barraConfianza(int confianza) {
    final valor = (confianza.clamp(0, 100)) / 100.0;

    String nivel = 'Baja';
    if (confianza >= 75) {
      nivel = 'Alta';
    } else if (confianza >= 55) {
      nivel = 'Media';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Confianza: $confianza% ($nivel)'),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: valor,
            minHeight: 10,
            backgroundColor: Colors.white12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mineralLocal = _resultado == null
        ? null
        : _buscarEnBase(_resultado!.resultadoPrincipal);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Análisis inteligente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.file(
                File(widget.imagePath),
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 18),

            _titulo('Color predominante'),
            DropdownButtonFormField<String>(
              value: _color,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Amarillo', child: Text('Amarillo')),
                DropdownMenuItem(value: 'Blanco', child: Text('Blanco')),
                DropdownMenuItem(value: 'Negro', child: Text('Negro')),
                DropdownMenuItem(value: 'Gris', child: Text('Gris')),
                DropdownMenuItem(value: 'Verde', child: Text('Verde')),
                DropdownMenuItem(value: 'Azul', child: Text('Azul')),
                DropdownMenuItem(value: 'Marrón', child: Text('Marrón')),
                DropdownMenuItem(value: 'Rojo', child: Text('Rojo')),
                DropdownMenuItem(
                  value: 'Transparente',
                  child: Text('Transparente'),
                ),
              ],
              onChanged: (v) => setState(() => _color = v),
            ),

            const SizedBox(height: 14),
            _titulo('Brillo'),
            _ayuda('Ejemplo: metálico, vítreo, mate, nacarado, sedoso.'),
            DropdownButtonFormField<String>(
              value: _brillo,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Metálico', child: Text('Metálico')),
                DropdownMenuItem(value: 'Vítreo', child: Text('Vítreo')),
                DropdownMenuItem(value: 'Mate', child: Text('Mate')),
                DropdownMenuItem(value: 'Nacarado', child: Text('Nacarado')),
                DropdownMenuItem(value: 'Sedoso', child: Text('Sedoso')),
              ],
              onChanged: (v) => setState(() => _brillo = v),
            ),

            const SizedBox(height: 14),
            _titulo('Textura'),
            DropdownButtonFormField<String>(
              value: _textura,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Granular', child: Text('Granular')),
                DropdownMenuItem(value: 'Fina', child: Text('Fina')),
                DropdownMenuItem(value: 'Compacta', child: Text('Compacta')),
                DropdownMenuItem(value: 'Cristalina', child: Text('Cristalina')),
                DropdownMenuItem(value: 'Porosa', child: Text('Porosa')),
              ],
              onChanged: (v) => setState(() => _textura = v),
            ),

            const SizedBox(height: 14),
            _titulo('Zona donde se encontró'),
            DropdownButtonFormField<String>(
              value: _zona,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Zona minera',
                  child: Text('Zona minera'),
                ),
                DropdownMenuItem(
                  value: 'Quebrada o cerro',
                  child: Text('Quebrada o cerro'),
                ),
                DropdownMenuItem(
                  value: 'Río o aluvial',
                  child: Text('Río o aluvial'),
                ),
                DropdownMenuItem(
                  value: 'Zona volcánica',
                  child: Text('Zona volcánica'),
                ),
                DropdownMenuItem(
                  value: 'No estoy seguro',
                  child: Text('No estoy seguro'),
                ),
              ],
              onChanged: (v) => setState(() => _zona = v),
            ),

            const SizedBox(height: 14),
            _titulo('Observaciones'),
            _ayuda(
              'Ejemplo: pesa mucho, parece oro, tiene cristales, mancha rojo, se rompe fácil.',
            ),
            TextField(
              controller: _observacionesController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escribe aquí lo que notaste...',
              ),
            ),

            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _cargando ? null : _analizar,
                icon: _cargando
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(_cargando ? 'Analizando...' : 'Analizar con IA'),
              ),
            ),

            _tarjetaError(),

            if (_resultado != null) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF101A2B),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF1E3354)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resultado: ${_resultado!.resultadoPrincipal}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Tipo: ${_resultado!.tipo}'),
                    const SizedBox(height: 12),
                    _barraConfianza(_resultado!.confianza),
                    const SizedBox(height: 12),
                    Text(
                      'Alternativas: ${_resultado!.alternativas.isEmpty ? 'No disponibles' : _resultado!.alternativas.join(', ')}',
                    ),
                    const SizedBox(height: 10),
                    Text(_resultado!.explicacion),
                    if (mineralLocal != null) ...[
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MineralDetailScreen(
                                  mineral: mineralLocal,
                                  imagePath: widget.imagePath,
                                  mostrarGuardar: true,
                                ),
                              ),
                            );
                          },
                          child: const Text('Abrir ficha completa'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}