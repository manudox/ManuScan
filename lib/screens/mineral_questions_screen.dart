import 'package:flutter/material.dart';

import '../data/minerals_data.dart';
import '../models/mineral.dart';
import 'mineral_detail_screen.dart';

class MineralQuestionsScreen extends StatefulWidget {
  final String imagePath;

  const MineralQuestionsScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<MineralQuestionsScreen> createState() => _MineralQuestionsScreenState();
}

class _MineralQuestionsScreenState extends State<MineralQuestionsScreen> {
  String? _color;
  String? _brillo;
  String? _zona;
  final TextEditingController _observacionesController =
      TextEditingController();

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  Mineral _elegirMineral() {
    final minerales = mineralesData
        .where((m) => m.tipo.toLowerCase() == 'mineral')
        .toList();

    final observacion = _observacionesController.text.toLowerCase();

    if ((_brillo == 'Metálico' && _color == 'Amarillo') ||
        observacion.contains('dorado') ||
        observacion.contains('oro de los tontos')) {
      return minerales.firstWhere((m) => m.nombre == 'Pirita');
    }

    if (_color == 'Blanco' ||
        _color == 'Transparente' ||
        observacion.contains('cristal')) {
      return minerales.firstWhere((m) => m.nombre == 'Cuarzo');
    }

    if (_color == 'Crema' || _brillo == 'Nacarado') {
      return minerales.firstWhere((m) => m.nombre == 'Calcita');
    }

    if (_zona == 'Zona seca o sedimentaria' ||
        observacion.contains('polvo') ||
        observacion.contains('blando')) {
      return minerales.firstWhere((m) => m.nombre == 'Yeso');
    }

    return minerales.first;
  }

  void _continuar() {
    if (_color == null || _brillo == null || _zona == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa al menos las preguntas principales'),
        ),
      );
      return;
    }

    final mineral = _elegirMineral();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MineralDetailScreen(
          mineral: mineral,
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
                    'Estas preguntas ayudan a mejorar la identificación preliminar del mineral. Si no estás completamente seguro, elige la opción más parecida y agrega una observación al final.',
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
              'Observa el color general de la muestra. Ejemplo: amarillo, blanco, transparente o crema.',
            ),
            DropdownButtonFormField<String>(
              initialValue: _color,
              dropdownColor: const Color(0xFF101A2B),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Amarillo', child: Text('Amarillo')),
                DropdownMenuItem(value: 'Blanco', child: Text('Blanco')),
                DropdownMenuItem(
                  value: 'Transparente',
                  child: Text('Transparente'),
                ),
                DropdownMenuItem(value: 'Crema', child: Text('Crema')),
                DropdownMenuItem(value: 'Gris', child: Text('Gris')),
              ],
              onChanged: (value) {
                setState(() {
                  _color = value;
                });
              },
            ),
            const SizedBox(height: 14),
            _titulo('Tipo de brillo'),
            _ayuda(
              'Metálico si parece metal. Vítreo si parece vidrio. Nacarado si tiene brillo suave como perla.',
            ),
            DropdownButtonFormField<String>(
              initialValue: _brillo,
              dropdownColor: const Color(0xFF101A2B),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Metálico', child: Text('Metálico')),
                DropdownMenuItem(value: 'Vítreo', child: Text('Vítreo')),
                DropdownMenuItem(value: 'Nacarado', child: Text('Nacarado')),
                DropdownMenuItem(value: 'Sedoso', child: Text('Sedoso')),
              ],
              onChanged: (value) {
                setState(() {
                  _brillo = value;
                });
              },
            ),
            const SizedBox(height: 14),
            _titulo('Zona donde tomaste la muestra'),
            _ayuda(
              'Selecciona el lugar más parecido donde encontraste la muestra.',
            ),
            DropdownButtonFormField<String>(
              initialValue: _zona,
              dropdownColor: const Color(0xFF101A2B),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Zona minera o veta',
                  child: Text('Zona minera o veta'),
                ),
                DropdownMenuItem(
                  value: 'Quebrada o superficie rocosa',
                  child: Text('Quebrada o superficie rocosa'),
                ),
                DropdownMenuItem(
                  value: 'Zona seca o sedimentaria',
                  child: Text('Zona seca o sedimentaria'),
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
              'Escribe algo que hayas notado. Ejemplo: “parece cristal”, “brilla como metal”, “lo encontré en Puno”, “se ve blando”, “tiene partes doradas”.',
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