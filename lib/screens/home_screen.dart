import 'package:flutter/material.dart';
import '../services/market_service.dart';
import '../widgets/analysis_counter_fab.dart';
import 'history_screen.dart';
import 'mineral_identifier_screen.dart';
import 'support_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _abrirIdentificadorMineral() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MineralIdentifierScreen(),
      ),
    );
  }

  void _abrirHistorial() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HistoryScreen(),
      ),
    );
  }

  void _abrirSupport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SupportScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const AnalysisCounterFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF081A33),
              Color(0xFF0D2747),
              Color(0xFF11345D),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 330,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/mine_bg.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          color: const Color(0xFF10284A),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 330,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withAlpha(90),
                          const Color(0xFF0B2342).withAlpha(170),
                          const Color(0xFF0D2E57).withAlpha(220),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _logoBox('assets/images/unap.png', Icons.school),
                              _logoBox('assets/images/minas.png', Icons.engineering),
                            ],
                          ),
                          const SizedBox(height: 36),
                          const Text(
                            'Bienvenido Minero',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 31,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Color(0xFF5FD3FF),
                                  blurRadius: 18,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Explora, identifica y analiza minerales con una experiencia moderna, académica y futurista.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.5,
                              color: Colors.white70,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Transform.translate(
                offset: const Offset(0, -28),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _GlassFeatureBox(
                        icon: Icons.terrain,
                        title: 'Identificador de roca',
                        subtitle: 'Función en desarrollo, pronto disponible',
                        glowColor: const Color(0xFFFF6B6B),
                        isLocked: true,
                        badgeText: 'EN MANTENIMIENTO',
                      ),
                      const SizedBox(height: 14),
                      _GlassFeatureBox(
                        icon: Icons.diamond_outlined,
                        title: 'Identificador de mineral',
                        subtitle:
                            'Reconoce minerales por imagen y consulta sus propiedades',
                        glowColor: const Color(0xFF5FD3FF),
                        onTap: _abrirIdentificadorMineral,
                      ),
                      const SizedBox(height: 14),
_GlassFeatureBox(
  icon: Icons.history,
  title: 'Mis análisis',
  subtitle:
      'Consulta tus análisis guardados y revisa tus muestras anteriores',
  glowColor: const Color(0xFF6EE7FF),
  onTap: _abrirHistorial,
),
const SizedBox(height: 16),
_PanelCard(
  title: 'Mercado de minerales',
  icon: Icons.trending_up,
  child: Column(
    children: [
      FutureBuilder<Map<String, dynamic>>(
        future: MarketService.getPrices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const _MarketTile(
              mineral: 'Oro',
              price: 'No disponible',
              change: 'ERROR',
            );
          }

          final data = snapshot.data!;

          return _MarketTile(
            mineral: 'Oro',
            price: 'S/ ${data['oro_pen'].toStringAsFixed(2)} / g',
            change: 'LIVE',
          );
        },
      ),
      const SizedBox(height: 10),
      const _MarketTile(
        mineral: 'Cobre',
        price: 'Próximamente',
        change: '--',
      ),
      const SizedBox(height: 10),
      const _MarketTile(
        mineral: 'Plata',
        price: 'Próximamente',
        change: '--',
      ),
    ],
  ),
),
                      const SizedBox(height: 16),
                      const _PanelCard(
                        title: '¿Sabías que...?',
                        icon: Icons.lightbulb_outline,
                        child: Text(
                          'El Perú es uno de los principales productores de cobre, oro, plata y zinc del mundo, y la minería representa una parte clave de sus exportaciones.',
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const _PanelCard(
                        title: 'Sobre nosotros',
                        icon: Icons.school_outlined,
                        child: Text(
                          'ManuScan es una aplicación académica desarrollada para apoyar el aprendizaje en mineralogía y petrografía dentro de la Ingeniería de Minas.',
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SupportPanel(
                        onTap: _abrirSupport,
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoBox(String assetPath, IconData fallbackIcon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(28),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withAlpha(40),
        ),
      ),
      child: Image.asset(
        assetPath,
        height: 52,
        errorBuilder: (_, __, ___) {
          return SizedBox(
            height: 52,
            width: 52,
            child: Icon(
              fallbackIcon,
              color: Colors.white70,
            ),
          );
        },
      ),
    );
  }
}

class _GlassFeatureBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color glowColor;
  final VoidCallback? onTap;
  final bool isLocked;
  final String? badgeText;

  const _GlassFeatureBox({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.glowColor,
    this.onTap,
    this.isLocked = false,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isLocked ? 0.92 : 1,
      child: Material(
        color: const Color(0xFF132846),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: isLocked ? null : onTap,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: glowColor.withAlpha(isLocked ? 120 : 100),
                width: 1.3,
              ),
              boxShadow: [
                BoxShadow(
                  color: glowColor.withAlpha(isLocked ? 18 : 36),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ],
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF132846),
                  Color(0xFF0D1E36),
                ],
              ),
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: glowColor.withAlpha(28),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        icon,
                        color: glowColor,
                        size: 30,
                      ),
                    ),
                    if (isLocked)
                      const Positioned.fill(
                        child: Center(
                          child: Icon(
                            Icons.lock,
                            size: 18,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (badgeText != null) ...[
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFF6B6B),
                                Color(0xFFD64545),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            badgeText!,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isLocked ? Icons.lock_outline : Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.white54,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PanelCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _PanelCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF132846),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF29507A),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2200B4FF),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF5FD3FF)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _MarketTile extends StatelessWidget {
  final String mineral;
  final String price;
  final String change;

  const _MarketTile({
    required this.mineral,
    required this.price,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = change.startsWith('+');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F213B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF24476D)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF17304E),
            child: Text(
              mineral.substring(0, 1),
              style: const TextStyle(
                color: Color(0xFF5FD3FF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              mineral,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                change,
                style: TextStyle(
                  color: isPositive ? Colors.lightGreenAccent : Colors.redAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SupportPanel extends StatelessWidget {
  final VoidCallback onTap;

  const _SupportPanel({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4A148C),
            Color(0xFF6A1FA2),
            Color(0xFF8E24AA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x339C27B0),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(28),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.coffee_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Apoya ManuScan',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Ayuda a seguir mejorando la app con un pequeño aporte por Yape.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF6A1FA2),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.favorite_outline),
                  label: const Text('Ver apoyo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}