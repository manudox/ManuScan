import 'package:shared_preferences/shared_preferences.dart';

class UsageService {
  static const int limiteDiario = 20;

  static const String _keyUsos = 'usos_hoy';
  static const String _keyDia = 'ultimo_dia_uso';

  static Future<void> _asegurarDiaActual() async {
    final prefs = await SharedPreferences.getInstance();
    final hoy = DateTime.now();
    final claveHoy = '${hoy.year}-${hoy.month}-${hoy.day}';
    final guardado = prefs.getString(_keyDia);

    if (guardado != claveHoy) {
      await prefs.setString(_keyDia, claveHoy);
      await prefs.setInt(_keyUsos, 0);
    }
  }

  static Future<int> getUsosHoy() async {
    await _asegurarDiaActual();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUsos) ?? 0;
  }

  static Future<int> getRestantes() async {
    final usados = await getUsosHoy();
    final restantes = limiteDiario - usados;
    return restantes < 0 ? 0 : restantes;
  }

  static Future<bool> puedeUsar() async {
    final usados = await getUsosHoy();
    return usados < limiteDiario;
  }

  static Future<void> consumirUso() async {
    await _asegurarDiaActual();
    final prefs = await SharedPreferences.getInstance();
    final usados = prefs.getInt(_keyUsos) ?? 0;
    await prefs.setInt(_keyUsos, usados + 1);
  }
}