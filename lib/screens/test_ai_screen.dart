import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class TestAiScreen extends StatefulWidget {
  const TestAiScreen({super.key});

  @override
  State<TestAiScreen> createState() => _TestAiScreenState();
}

class _TestAiScreenState extends State<TestAiScreen> {
  Interpreter? _interpreter;
  List<String> _labels = [];
  File? _imageFile;
  String _result = "Selecciona una imagen para analizar";
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/models/manuscan_mineral_model.tflite',
    );

    final labelsData = await rootBundle.loadString('assets/models/labels.txt');
    _labels = labelsData.split('\n').where((e) => e.trim().isNotEmpty).toList();

    debugPrint("IA cargada correctamente");
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    setState(() {
      _imageFile = File(picked.path);
      _loading = true;
      _result = "Analizando imagen...";
    });

    await _runModel(File(picked.path));
  }

  Future<void> _runModel(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final originalImage = img.decodeImage(bytes);

    if (originalImage == null || _interpreter == null) {
      setState(() {
        _result = "No se pudo analizar la imagen";
        _loading = false;
      });
      return;
    }

    final resizedImage = img.copyResize(originalImage, width: 224, height: 224);

    final input = List.generate(
      1,
      (_) => List.generate(
        224,
        (y) => List.generate(
          224,
          (x) {
            final pixel = resizedImage.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          },
        ),
      ),
    );

    final output = List.generate(
      1,
      (_) => List.filled(_labels.length, 0.0),
    );

    _interpreter!.run(input, output);

    final scores = output[0];

    int bestIndex = 0;
    double bestScore = scores[0];

    for (int i = 1; i < scores.length; i++) {
      if (scores[i] > bestScore) {
        bestScore = scores[i];
        bestIndex = i;
      }
    }

    final predictions = <Map<String, dynamic>>[];

for (int i = 0; i < scores.length; i++) {
  predictions.add({
    "label": _labels[i],
    "score": scores[i],
  });
}

predictions.sort((a, b) => b["score"].compareTo(a["score"]));

final top1 = predictions[0];
final top2 = predictions.length > 1 ? predictions[1] : null;
final top3 = predictions.length > 2 ? predictions[2] : null;

String resultText = "Mineral predominante: ${top1["label"]}\n";
resultText += "Confianza: ${(top1["score"] * 100).toStringAsFixed(2)}%\n\n";
resultText += "Alternativas:\n";

if (top2 != null) {
  resultText += "1. ${top2["label"]} - ${(top2["score"] * 100).toStringAsFixed(2)}%\n";
}

if (top3 != null) {
  resultText += "2. ${top3["label"]} - ${(top3["score"] * 100).toStringAsFixed(2)}%\n";
}

setState(() {
  _result = resultText;
  _loading = false;
});
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Prueba IA ManuScan"),
        backgroundColor: Colors.green.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  _imageFile!,
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    "Sin imagen",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loading ? null : _pickImage,
              icon: const Icon(Icons.image),
              label: const Text("Seleccionar imagen"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _result,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}