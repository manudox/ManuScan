import 'package:flutter/material.dart';

import '../data/minerals_data.dart';
import '../models/mineral.dart';
import 'mineral_detail_screen.dart';

class RockQuestionsScreen extends StatefulWidget {
  final String imagePath;

  const RockQuestionsScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<RockQuestionsScreen> createState() => _RockQuestionsScreenState();
}

class _RockQuestionsScreenState extends State<RockQuestionsScreen> {
  String? _color;
  String? _textura;
  String? _zona;
  final TextEditingController _observacionesController =
      TextEditingController();

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  Mineral _elegirRoca() {
    final rocas = mineralesData
        .where((m) => m.tipo.toLowerCase().contains('roca'))
        .toList();

    final observacion = _observacionesController.text.toLowerCase();

    if ((_color == 'Negro' || _color == 'Gris oscuro') &&
        (_textura == 'Fina' || observacion.contains('volc'))) {
      return rocas.firstWhere((m) => m.nombre == 'Basalto');
    }

    if ((_color == 'Gris' || _color == 'Rosado') &&
        (_textura == 'Granular' || observacion.contains('granos'))) {
      return rocas.firstWhere((m) => m.nombre == 'Granito');
    }

    return rocas.first;
  }

  void _continuar() {
    if (_color == null || _textura == null || _zona == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa al menos las preguntas principales'),
        ),
      );
      return;
    }

    final roca = _elegirRoca();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MineralDetailScreen(
          mineral: roca,
          imagePath: widget.imagePath,
          mostrarGuardar: true,
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Afinar análisis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF101A2B),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFF1E3354),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ayuda para mejorar el resultado',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Estas preguntas ayudan a mejorar la identificación preliminar de la roca. Si no estás seguro, elige la opción más parecida y agrega una observación al final.',
                    style: TextStyle(
                      fontSize: 14.5,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _titulo('Color predominante'),
            _ayuda(
              'Observa el color general de la roca. Ejemplo: gris, rosado, negro o gris oscuro.',
            ),
            DropdownButtonFormField<String>(
              initialValue: _color,
              dropdownColor: const Color(0xFF101A2B),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Gris', child: Text('Gris')),
                DropdownMenuItem(value: 'Rosado', child: Text('Rosado')),
                DropdownMenuItem(value: 'Negro', child: Text('Negro')),
                DropdownMenuItem(
                  value: 'Gris oscuro',
                  child: Text('Gris oscuro'),
                ),
                DropdownMenuItem(value: 'Blanco', child: Text('Blanco')),
              ],
              onChanged: (value) {
                setState(() {
                  _color = value;
                });
              },
            ),
            const SizedBox(height: 14),
            _titulo('Tipo de textura'),
            _ayuda(
              'Granular si ves granos o cristales. Fina si la roca se ve compacta y sin granos claros.',
            ),
            DropdownButtonFormField<String>(
              initialValue: _textura,
              dropdownColor: const Color(0xFF101A2B),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Granular', child: Text('Granular')),
                DropdownMenuItem(value: 'Fina', child: Text('Fina')),
                DropdownMenuItem(value: 'Compacta', child: Text('Compacta')),
                DropdownMenuItem(value: 'Porosa', child: Text('Porosa')),
              ],
              onChanged: (value) {
                setState(() {
                  _textura = value;
                });
              },
            ),
            const SizedBox(height: 14),
            _titulo('Zona donde tomaste la muestra'),
            _ayuda(
              'Selecciona el lugar más parecido donde encontraste la roca.',
            ),
            DropdownButtonFormField<String>(
              initialValue: _zona,
              dropdownColor: const Color(0xFF101A2B),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Zona volcánica',
                  child: Text('Zona volcánica'),
                ),
                DropdownMenuItem(
                  value: 'Quebrada o superficie rocosa',
                  child: Text('Quebrada o superficie rocosa'),
                ),
                DropdownMenuItem(
                  value: 'Zona montañosa',
                  child: Text('Zona montañosa'),
                ),
                DropdownMenuItem(
                  value: 'No estoy seguro',
                  child: Text('No estoy seguro'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _zona = value;
                });
              },
            ),
            const SizedBox(height: 14),
            _titulo('Observaciones adicionales'),
            _ayuda(
              'Escribe algo que hayas notado. Ejemplo: “tiene granos visibles”, “parece volcánica”, “es negra y compacta”, “la encontré en cerro rocoso”.',
            ),
            TextField(
              controller: _observacionesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Escribe aquí tus observaciones...',
                hintStyle: const TextStyle(color: Colors.white38),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _continuar,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Ver resultado afinado'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}