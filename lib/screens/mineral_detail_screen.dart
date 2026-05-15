import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/mineral.dart';
import '../models/saved_analysis.dart';
import '../services/external_image_service.dart';
import '../services/external_info_service.dart';

class MineralDetailScreen extends StatefulWidget {
  final Mineral mineral;
  final String? imagePath;
  final bool mostrarGuardar;

  const MineralDetailScreen({
    super.key,
    required this.mineral,
    this.imagePath,
    this.mostrarGuardar = false,
  });

  @override
  State<MineralDetailScreen> createState() => _MineralDetailScreenState();
}

class _MineralDetailScreenState extends State<MineralDetailScreen> {
  String? _imagenExterna;
  String? _descripcionExterna;
  String? _fuenteInfo;
  bool _cargandoImagen = true;

  String get _terminoBusqueda =>
      widget.mineral.nombreBusqueda?.trim().isNotEmpty == true
          ? widget.mineral.nombreBusqueda!.trim()
          : widget.mineral.nombre;

  @override
  void initState() {
    super.initState();
    _cargarImagenExterna();
    _cargarInfoExterna();
  }

  Future<void> _cargarImagenExterna() async {
    final url =
        await ExternalImageService.buscarImagenPorNombre(_terminoBusqueda);

    if (!mounted) return;

    setState(() {
      _imagenExterna = url;
      _cargandoImagen = false;
    });
  }

  Future<void> _cargarInfoExterna() async {
    if (widget.mineral.descripcionExtra != null &&
        widget.mineral.descripcionExtra!.trim().isNotEmpty) {
      return;
    }

    final result =
        await ExternalInfoService.buscarDescripcionPorNombre(_terminoBusqueda);

    if (!mounted) return;

    setState(() {
      _descripcionExterna = result.descripcion;
      _fuenteInfo = result.fuente;
    });
  }

  Widget _dato(String titulo, String valor, IconData icono) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF101A2B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1E3354)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: const Color(0xFF00B4FF)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 15.5,
                    height: 1.35,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagenReferencial() {
    if (_cargandoImagen) {
      return Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF101A2B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF1E3354)),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 1. Si encontró imagen web, usar esa primero
    if (_imagenExterna != null && _imagenExterna!.isNotEmpty) {
      return _networkImage(_imagenExterna!);
    }

    // 2. Si no, usar URL fija del mineral si existe
    if (widget.mineral.imagenUrl != null &&
        widget.mineral.imagenUrl!.isNotEmpty) {
      return _networkImage(widget.mineral.imagenUrl!);
    }

    // 3. Si no, usar asset local
    if (widget.mineral.imagenAsset != null &&
        widget.mineral.imagenAsset!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          widget.mineral.imagenAsset!,
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholderImagen(),
        ),
      );
    }

    // 4. Si nada existe
    return _placeholderImagen();
  }

  Widget _networkImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        url,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          if (widget.mineral.imagenAsset != null &&
              widget.mineral.imagenAsset!.isNotEmpty) {
            return Image.asset(
              widget.mineral.imagenAsset!,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholderImagen(),
            );
          }
          return _placeholderImagen();
        },
      ),
    );
  }

  Widget _placeholderImagen() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF101A2B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E3354)),
      ),
      child: const Center(
        child: Text(
          'No se encontró imagen referencial',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  Future<void> _guardarAnalisis(BuildContext context) async {
    if (widget.imagePath == null) return;

    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('saved_analyses') ?? [];

    final analysis = SavedAnalysis(
      nombre: widget.mineral.nombre,
      tipo: widget.mineral.tipo,
      fecha: DateTime.now().toString().substring(0, 16),
      imagePath: widget.imagePath!,
      descripcion: widget.mineral.descripcion,
      formula: widget.mineral.formula,
      dureza: widget.mineral.dureza,
      brillo: widget.mineral.brillo,
      color: widget.mineral.color,
      usos: widget.mineral.usos,
      dondeSeEncuentra: widget.mineral.dondeSeEncuentra,
    );

    data.add(analysis.toJson());
    await prefs.setStringList('saved_analyses', data);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Análisis guardado correctamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final esRoca = widget.mineral.tipo.toLowerCase().contains('roca');

    final descripcionComplementaria = widget.mineral.descripcionExtra != null &&
            widget.mineral.descripcionExtra!.trim().isNotEmpty
        ? widget.mineral.descripcionExtra
        : _descripcionExterna;

    final fuenteComplementaria = widget.mineral.fuenteInfo ?? _fuenteInfo;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mineral.nombre),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.imagePath != null) ...[
              const Text(
                'Muestra analizada',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(widget.imagePath!),
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 18),
            ],
            const Text(
              'Imagen referencial',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            _imagenReferencial(),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0B1D3A),
                    Color(0xFF10284E),
                    Color(0xFF00B4FF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Icon(
                    esRoca ? Icons.landscape : Icons.diamond_outlined,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.mineral.nombre,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(widget.mineral.tipo),
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _dato('Fórmula / Composición', widget.mineral.formula, Icons.science),
            _dato('Dureza', widget.mineral.dureza, Icons.hardware),
            _dato('Brillo', widget.mineral.brillo, Icons.wb_sunny_outlined),
            _dato('Color', widget.mineral.color, Icons.palette_outlined),
            _dato(
              'Descripción',
              widget.mineral.descripcion,
              Icons.description_outlined,
            ),
            if (descripcionComplementaria != null &&
                descripcionComplementaria.trim().isNotEmpty)
              _dato(
                'Información complementaria',
                descripcionComplementaria,
                Icons.auto_awesome_outlined,
              ),
            _dato('Usos', widget.mineral.usos, Icons.build_circle_outlined),
            _dato(
              'Dónde se encuentra',
              widget.mineral.dondeSeEncuentra,
              Icons.place_outlined,
            ),
            if (fuenteComplementaria != null || _imagenExterna != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF101A2B),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF1E3354)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fuentes complementarias',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Búsqueda usada: $_terminoBusqueda',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    if (fuenteComplementaria != null)
                      Text(
                        'Info: $fuenteComplementaria',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    if (_imagenExterna != null)
                      const Text(
                        'Imagen: Wikipedia',
                        style: TextStyle(color: Colors.white70),
                      ),
                  ],
                ),
              ),
            ],
            if (widget.mostrarGuardar) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _guardarAnalisis(context),
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Guardar análisis'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}