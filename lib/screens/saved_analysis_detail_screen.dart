import 'dart:io';

import 'package:flutter/material.dart';

import '../models/saved_analysis.dart';

class SavedAnalysisDetailScreen extends StatelessWidget {
  final SavedAnalysis analysis;

  const SavedAnalysisDetailScreen({
    super.key,
    required this.analysis,
  });

  Widget _dato(String titulo, String valor, IconData icono) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD6E4FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: const Color(0xFF1565C0), size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5F6368),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  valor.trim().isEmpty ? 'No disponible' : valor,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.4,
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool tieneImagen =
        analysis.imagePath.trim().isNotEmpty &&
        File(analysis.imagePath).existsSync();

    return Scaffold(
      backgroundColor: const Color(0xFF03152E),
      appBar: AppBar(
        title: Text(analysis.nombre),
        backgroundColor: const Color(0xFF07213D),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tieneImagen)
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.file(
                  File(analysis.imagePath),
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D223E),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFF1E3A5F)),
                ),
                child: const Center(
                  child: Text(
                    'No se encontró la imagen guardada',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
              ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1E63B5),
                    Color(0xFF4EA3F1),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  Text(
                    analysis.nombre,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      analysis.tipo,
                      style: const TextStyle(
                        color: Color(0xFF0C3B73),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _dato('Fecha', analysis.fecha, Icons.calendar_today_outlined),
            _dato('Fórmula / Composición', analysis.formula, Icons.science_outlined),
            _dato('Dureza', analysis.dureza, Icons.hardware_outlined),
            _dato('Brillo', analysis.brillo, Icons.wb_sunny_outlined),
            _dato('Color', analysis.color, Icons.palette_outlined),
            _dato('Descripción', analysis.descripcion, Icons.description_outlined),
            _dato('Usos', analysis.usos, Icons.build_circle_outlined),
            _dato('Dónde se encuentra', analysis.dondeSeEncuentra, Icons.place_outlined),
          ],
        ),
      ),
    );
  }
}