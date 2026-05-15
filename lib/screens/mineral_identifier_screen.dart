import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/usage_service.dart';
import 'intelligent_analysis_screen.dart';

class MineralIdentifierScreen extends StatefulWidget {
  const MineralIdentifierScreen({super.key});

  @override
  State<MineralIdentifierScreen> createState() =>
      _MineralIdentifierScreenState();
}

class _MineralIdentifierScreenState extends State<MineralIdentifierScreen> {
  XFile? _image;
  int _usosRestantes = 5;

  @override
  void initState() {
    super.initState();
    _refrescarContador();
  }

  Future<void> _refrescarContador() async {
    final restantes = await UsageService.getRestantes();
    if (!mounted) return;
    setState(() {
      _usosRestantes = restantes;
    });
  }

  Future<void> _tomarFoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  Future<void> _irAAnalisis() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero toma una foto')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => IntelligentAnalysisScreen(
          imagePath: _image!.path,
        ),
      ),
    ).then((_) => _refrescarContador());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identificador de Mineral'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF101A2B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF1E3354)),
              ),
              child: Text(
                'Te quedan $_usosRestantes análisis hoy',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _image == null
                ? Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF101A2B),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF1E3354)),
                    ),
                    child: const Center(
                      child: Text(
                        'No hay imagen',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.file(
                      File(_image!.path),
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _tomarFoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Tomar foto'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _irAAnalisis,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Continuar al análisis inteligente'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}