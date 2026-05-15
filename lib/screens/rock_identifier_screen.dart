import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'rock_questions_screen.dart';

class RockIdentifierScreen extends StatefulWidget {
  const RockIdentifierScreen({super.key});

  @override
  State<RockIdentifierScreen> createState() => _RockIdentifierScreenState();
}

class _RockIdentifierScreenState extends State<RockIdentifierScreen> {
  XFile? _image;

  Future<void> _tomarFoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  void _analizarRoca() {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero toma una foto')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RockQuestionsScreen(
          imagePath: _image!.path,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identificador de Roca'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const SizedBox(height: 10),
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
                onPressed: _analizarRoca,
                icon: const Icon(Icons.search),
                label: const Text('Analizar roca'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}