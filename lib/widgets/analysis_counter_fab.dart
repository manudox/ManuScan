import 'package:flutter/material.dart';
import '../services/usage_service.dart';

class AnalysisCounterFab extends StatefulWidget {
  const AnalysisCounterFab({super.key});

  @override
  State<AnalysisCounterFab> createState() => _AnalysisCounterFabState();
}

class _AnalysisCounterFabState extends State<AnalysisCounterFab> {
  int _restantes = 5;

  @override
  void initState() {
    super.initState();
    _recargar();
  }

  Future<void> _recargar() async {
    final restantes = await UsageService.getRestantes();
    if (!mounted) return;
    setState(() {
      _restantes = restantes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: _recargar,
      backgroundColor: const Color(0xFF00B4FF),
      foregroundColor: const Color(0xFF08111F),
      icon: const Icon(Icons.bolt),
      label: Text(
        'Te quedan $_restantes análisis',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}