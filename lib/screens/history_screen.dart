import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/saved_analysis.dart';
import 'saved_analysis_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<SavedAnalysis> _analisis = [];

  @override
  void initState() {
    super.initState();
    _cargarAnalisis();
  }

  Future<void> _cargarAnalisis() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('saved_analyses') ?? [];

    setState(() {
      _analisis = data
          .map((e) => SavedAnalysis.fromJson(e))
          .toList()
          .reversed
          .toList();
    });
  }

  Future<void> _guardarListaActual() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _analisis.reversed.map((e) => e.toJson()).toList();
    await prefs.setStringList('saved_analyses', data);
  }

  Future<void> _eliminarAnalisis(int index) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar análisis'),
          content: const Text(
            '¿Seguro que deseas eliminar este análisis guardado?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    setState(() {
      _analisis.removeAt(index);
    });

    await _guardarListaActual();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Análisis eliminado')),
    );
  }

  Future<void> _eliminarTodo() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar todo'),
          content: const Text(
            '¿Seguro que deseas eliminar todos los análisis guardados?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar todo'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_analyses');

    setState(() {
      _analisis = [];
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Se eliminaron todos los análisis')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis análisis'),
        actions: [
          if (_analisis.isNotEmpty)
            IconButton(
              onPressed: _eliminarTodo,
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Eliminar todo',
            ),
        ],
      ),
      body: _analisis.isEmpty
          ? const Center(
              child: Text(
                'Aún no tienes análisis guardados',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _analisis.length,
              itemBuilder: (context, index) {
                final item = _analisis[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SavedAnalysisDetailScreen(analysis: item),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.file(
                              File(item.imagePath),
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) {
                                return Container(
                                  width: 72,
                                  height: 72,
                                  color: const Color(0xFFDCEBFF),
                                  child: const Icon(Icons.image_not_supported),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.nombre,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(item.tipo),
                                const SizedBox(height: 4),
                                Text(
                                  item.fecha,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.descripcion,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _eliminarAnalisis(index),
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                            ),
                            tooltip: 'Eliminar',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}