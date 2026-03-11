import 'package:flutter/material.dart';

class AlumnoPage extends StatelessWidget {
  final String role;

  const AlumnoPage({super.key, required this.role});

  // ── Configuración Estética ────────────────────────────────────────────────
  static const Color _primary    = Color(0xFF0D47A1); // Azul Profundo
  static const Color _primaryMid = Color(0xFF1976D2);
  static const Color _bg         = Color(0xFFF0F4F8);
  static const Color _accent     = Color(0xFF64B5F6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        slivers: [
          // ── Header con el mismo estilo del Maestro ────────────────────────
          SliverAppBar(
            expandedHeight: 175,
            pinned: true,
            backgroundColor: _primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_primary, _primaryMid],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.school_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Panel Alumno',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  'Beto Rodríguez', // Aquí puedes usar el user summary
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        // Chip de estado del alumno
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.25)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle_outline, color: Colors.white, size: 15),
                              SizedBox(width: 7),
                              Text(
                                'Estatus: Regular',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Cuerpo del Panel (Placeholder de Módulos) ─────────────────────
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome_motion_rounded, size: 80, color: _primary.withOpacity(0.2)),
                  const SizedBox(height: 20),
                  const Text(
                    '¡Bienvenido a tu Panel!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF102A43),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Aquí podrás revisar tus asistencias y calificaciones próximamente.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF627D98),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Botón decorativo
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    onPressed: () {},
                    child: const Text('Ver mi Horario', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}