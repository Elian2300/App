import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeacherPage extends StatefulWidget {
  final String role;

  const TeacherPage({super.key, required this.role});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {

  // ── Colores ────────────────────────────────────────────────────────────────
  static const Color _primary    = Color(0xFF1B5E20);
  static const Color _primaryMid = Color(0xFF2E7D32);
  static const Color _bg         = Color(0xFFF1F8F1);
  static const Color _textMuted  = Color(0xFF6B7B6B);

  // ── Estado ─────────────────────────────────────────────────────────────────
  List   _alumnos  = [];
  bool   _cargando = true;
  bool   _hayError = false;

  // ── Cambia esta URL por la de tu endpoint real ─────────────────────────────
  static const String _url = 'http://10.0.2.2:3000/api/students';

  Future<void> _cargarAlumnos() async {
    setState(() { _cargando = true; _hayError = false; });
    try {
      final response = await http.get(Uri.parse(_url));
      if (response.statusCode == 200) {
        setState(() {
          _alumnos  = jsonDecode(response.body);
          _cargando = false;
        });
      } else {
        setState(() { _cargando = false; _hayError = true; });
      }
    } catch (_) {
      setState(() { _cargando = false; _hayError = true; });
    }
  }

  @override
  void initState() {
    super.initState();
    _cargarAlumnos();
  }

  // ── BUILD ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        slivers: [

          // ── AppBar ────────────────────────────────────────────────────────
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
                                Icons.cast_for_education_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Panel Maestro',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  widget.role,
                                  style: const TextStyle(
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.25)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.people_rounded,
                                  color: Colors.white, size: 15),
                              const SizedBox(width: 7),
                              Text(
                                _cargando
                                    ? 'Cargando...'
                                    : '${_alumnos.length} alumnos registrados',
                                style: const TextStyle(
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

          // ── Encabezado de sección ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
              child: Row(
                children: [
                  const Text(
                    'Mis Alumnos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A2E1A),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _cargarAlumnos,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _primaryMid.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.refresh_rounded,
                          color: _primaryMid, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Cargando ──────────────────────────────────────────────────────
          if (_cargando)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: _primaryMid),
                    SizedBox(height: 16),
                    Text('Cargando alumnos...',
                        style: TextStyle(color: _textMuted)),
                  ],
                ),
              ),
            )

          // ── Error ─────────────────────────────────────────────────────────
          else if (_hayError)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off_rounded,
                        size: 60, color: Color(0xFFB0BEC5)),
                    const SizedBox(height: 16),
                    const Text('Sin conexión al servidor',
                        style:
                            TextStyle(color: _textMuted, fontSize: 15)),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryMid,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _cargarAlumnos,
                      icon: const Icon(Icons.refresh_rounded,
                          color: Colors.white),
                      label: const Text('Reintentar',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            )

          // ── Sin alumnos ───────────────────────────────────────────────────
          else if (_alumnos.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.school_outlined,
                        size: 60, color: Color(0xFFB0BEC5)),
                    SizedBox(height: 12),
                    Text('No hay alumnos registrados',
                        style:
                            TextStyle(color: _textMuted, fontSize: 15)),
                  ],
                ),
              ),
            )

          // ── Lista de alumnos ──────────────────────────────────────────────
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) =>
                      _AlumnoCard(alumno: _alumnos[i], index: i),
                  childCount: _alumnos.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Tarjeta de alumno ────────────────────────────────────────────────────────

class _AlumnoCard extends StatelessWidget {
  final dynamic alumno;
  final int     index;

  const _AlumnoCard({required this.alumno, required this.index});

  static const _colores = [
    Color(0xFF1565C0), Color(0xFF6A1B9A), Color(0xFFE65100),
    Color(0xFF00695C), Color(0xFFC62828), Color(0xFF0277BD),
  ];

  @override
  Widget build(BuildContext context) {
    final color    = _colores[index % _colores.length];
    final nombre   = alumno['nombre']    ?? 'Sin nombre';
    final apellido = alumno['apellido']  ?? '';
    // Ajusta los campos según tu schema de MongoDB
    final matricula = alumno['matricula']    ??
                      alumno['numeroAlumno'] ?? '—';
    final grado     = alumno['grado'] ??
                      alumno['grupo'] ?? '—';
    final inicial   = nombre.isNotEmpty ? nombre[0].toUpperCase() : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.12),
          child: Text(
            inicial,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
        title: Text(
          '$nombre $apellido'.trim(),
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Color(0xFF1A2E1A),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            children: [
              _InfoChip(
                icon: Icons.badge_outlined,
                label: matricula.toString(),
                color: color,
              ),
              const SizedBox(width: 10),
              _InfoChip(
                icon: Icons.class_outlined,
                label: grado.toString(),
                color: color,
              ),
            ],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.chevron_right_rounded, color: color, size: 20),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String   label;
  final Color    color;

  const _InfoChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}