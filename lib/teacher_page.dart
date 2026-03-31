import 'package:flutter/material.dart';
import 'package:flutter_application_1/http_logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_application_1/main.dart';
import 'dart:convert';

class TeacherPage extends StatefulWidget {
  final String role;

  const TeacherPage({super.key, required this.role});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage>
    with TickerProviderStateMixin {
  // ── Colores ────────────────────────────────────────────────────────────────
  static const Color _primary = Color(0xFF0D3B2E);
  static const Color _accent = Color(0xFF00C896);
  static const Color _accentSoft = Color(0xFFE8FAF5);
  static const Color _bg = Color(0xFFF6F8F7);
  static const Color _textDark = Color(0xFF0D1F1A);
  static const Color _textMuted = Color(0xFF7A9189);
  static const Color _card = Colors.white;

  // ── Estado ─────────────────────────────────────────────────────────────────
  List _alumnos = [];
  bool _cargando = true;
  bool _hayError = false;
  int _selectedTab = 0;

  // ── Animaciones ────────────────────────────────────────────────────────────
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;

  // ── URL API (sin cambios) ──────────────────────────────────────────────────
  static String get _url => '${dotenv.env['API_URL']}/api/students';

  Future<void> _cargarAlumnos() async {
    setState(() {
      _cargando = true;
      _hayError = false;
    });
    try {
      final response = await http.get(Uri.parse(_url));
      if (response.statusCode == 200) {
        setState(() {
          _alumnos = jsonDecode(response.body);
          _cargando = false;
        });
      } else {
        setState(() {
          _cargando = false;
          _hayError = true;
        });
      }
    } catch (_) {
      setState(() {
        _cargando = false;
        _hayError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _cargarAlumnos();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeOutBack,
    );
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _fabController.forward();
    });
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  // ── Cerrar sesión ──────────────────────────────────────────────────────────
 void _cerrarSesion() {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (_) => _LogoutDialog(
      onConfirm: () {
        Navigator.of(context).pop(); // cierra diálogo

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      },
    ),
  );
}

  // ── Modal: Crear Clase ─────────────────────────────────────────────────────
  void _abrirCrearClase() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => _CrearClaseModal(alumnos: _alumnos),
    );
  }

  // ── Modal: Generar Horario ─────────────────────────────────────────────────
  void _abrirGenerarHorario() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => const _GenerarHorarioModal(),
    );
  }

  // ── BUILD ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────────
          _Header(
            role: widget.role,
            totalAlumnos: _alumnos.length,
            cargando: _cargando,
            onLogout: _cerrarSesion,
          ),

          // ── Tabs ──────────────────────────────────────────────────────────
          _TabBar(
            selected: _selectedTab,
            onTap: (i) => setState(() => _selectedTab = i),
          ),

          // ── Acciones rápidas (solo en tab 0) ──────────────────────────────
          if (_selectedTab == 0) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.add_circle_outline_rounded,
                      label: 'Crear Clase',
                      color: _accent,
                      onTap: _abrirCrearClase,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.calendar_month_rounded,
                      label: 'Generar Horario',
                      color: const Color(0xFF6C63FF),
                      onTap: _abrirGenerarHorario,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // ── Lista / estados ───────────────────────────────────────────────
          if (_selectedTab == 0)
            Expanded(child: _AlumnosList(
              alumnos: _alumnos,
              cargando: _cargando,
              hayError: _hayError,
              onRetry: _cargarAlumnos,
            )),

          if (_selectedTab == 1)
            const Expanded(child: _AsistenciaTab()),

          if (_selectedTab == 2)
            const Expanded(child: _HorariosPlaceholder()),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final String role;
  final int totalAlumnos;
  final bool cargando;
  final VoidCallback onLogout;

  const _Header({
    required this.role,
    required this.totalAlumnos,
    required this.cargando,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D3B2E),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00C896).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.cast_for_education_rounded,
                      color: Color(0xFF00C896),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Panel del Maestro',
                        style: TextStyle(
                          color: Color(0xFF7ABAA8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        role,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Botón cerrar sesión
                  GestureDetector(
                    onTap: onLogout,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.red.withOpacity(0.25)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.logout_rounded,
                              color: Color(0xFFFF7070), size: 15),
                          SizedBox(width: 6),
                          Text(
                            'Salir',
                            style: TextStyle(
                              color: Color(0xFFFF7070),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              // Stats row
              Row(
                children: [
                  _StatPill(
                    icon: Icons.people_rounded,
                    label: cargando
                        ? 'Cargando...'
                        : '$totalAlumnos alumnos',
                    color: const Color(0xFF00C896),
                  ),
                  const SizedBox(width: 10),
                  _StatPill(
                    icon: Icons.calendar_today_rounded,
                    label: _diaActual(),
                    color: const Color(0xFF6C63FF),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _diaActual() {
    final dias = [
      'Domingo', 'Lunes', 'Martes', 'Miércoles',
      'Jueves', 'Viernes', 'Sábado'
    ];
    final meses = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    final now = DateTime.now();
    return '${dias[now.weekday % 7]} ${now.day} ${meses[now.month - 1]}';
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatPill(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB BAR
// ─────────────────────────────────────────────────────────────────────────────
class _TabBar extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;

  const _TabBar({required this.selected, required this.onTap});

  static const _tabs = [
    ('Alumnos', Icons.people_alt_rounded),
    ('Asistencia', Icons.checklist_rounded),
    ('Horarios', Icons.schedule_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final isSelected = selected == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF0D3B2E)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _tabs[i].$2,
                      size: 15,
                      color: isSelected
                          ? const Color(0xFF00C896)
                          : const Color(0xFF7A9189),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _tabs[i].$1,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF7A9189),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTÓN DE ACCIÓN
// ─────────────────────────────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.75)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.28),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LISTA DE ALUMNOS
// ─────────────────────────────────────────────────────────────────────────────
class _AlumnosList extends StatelessWidget {
  final List alumnos;
  final bool cargando;
  final bool hayError;
  final VoidCallback onRetry;

  const _AlumnosList({
    required this.alumnos,
    required this.cargando,
    required this.hayError,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF00C896),
              strokeWidth: 2.5,
            ),
            SizedBox(height: 14),
            Text('Cargando alumnos...',
                style: TextStyle(color: Color(0xFF7A9189), fontSize: 13)),
          ],
        ),
      );
    }

    if (hayError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wifi_off_rounded,
                  size: 40, color: Color(0xFFE57373)),
            ),
            const SizedBox(height: 16),
            const Text('Sin conexión al servidor',
                style: TextStyle(
                    color: Color(0xFF7A9189),
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D3B2E),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded,
                        color: Color(0xFF00C896), size: 16),
                    SizedBox(width: 8),
                    Text('Reintentar',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (alumnos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined,
                size: 52, color: Color(0xFFB0C4BB)),
            SizedBox(height: 12),
            Text('No hay alumnos registrados',
                style: TextStyle(
                    color: Color(0xFF7A9189),
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Mis Alumnos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0D1F1A),
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              Text(
                '${alumnos.length} registros',
                style: const TextStyle(
                    color: Color(0xFF7A9189), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: alumnos.length,
              itemBuilder: (ctx, i) =>
                  _AlumnoCard(alumno: alumnos[i], index: i),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TARJETA DE ALUMNO (rediseñada)
// ─────────────────────────────────────────────────────────────────────────────
class _AlumnoCard extends StatelessWidget {
  final dynamic alumno;
  final int index;

  const _AlumnoCard({required this.alumno, required this.index});

  static const _colores = [
    Color(0xFF00C896),
    Color(0xFF6C63FF),
    Color(0xFFFF7043),
    Color(0xFF26A69A),
    Color(0xFFEF5350),
    Color(0xFF42A5F5),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _colores[index % _colores.length];
    final nombre = alumno['nombre'] ?? 'Sin nombre';
    final apellido = alumno['apellido'] ?? '';
    final matricula =
        alumno['matricula'] ?? alumno['numeroAlumno'] ?? '—';
    final grado = alumno['grado'] ?? alumno['grupo'] ?? '—';
    final inicial =
        nombre.isNotEmpty ? nombre[0].toUpperCase() : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      inicial,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$nombre $apellido'.trim(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF0D1F1A),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          _Chip(
                              icon: Icons.badge_outlined,
                              label: matricula.toString(),
                              color: color),
                          const SizedBox(width: 8),
                          _Chip(
                              icon: Icons.class_outlined,
                              label: grado.toString(),
                              color: color),
                        ],
                      ),
                    ],
                  ),
                ),
                // Flecha
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.chevron_right_rounded,
                      color: color, size: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Chip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PLACEHOLDERS: CLASES Y HORARIOS
// ─────────────────────────────────────────────────────────────────────────────
class _AsistenciaTab extends StatefulWidget {
  const _AsistenciaTab({super.key});
  @override
  State<_AsistenciaTab> createState() => _AsistenciaTabState();
}

class _AsistenciaTabState extends State<_AsistenciaTab> {
  List<dynamic> _alumnos = [];
  Map<String, String> _asistencias = {}; // id -> status
  bool _cargando = true;
  bool _guardando = false;
  String _groupId = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final resS = await http.get(Uri.parse('${dotenv.env['API_URL']}/api/students'));
      final resG = await http.get(Uri.parse('${dotenv.env['API_URL']}/api/groups'));
      
      if (resS.statusCode == 200 && resG.statusCode == 200) {
        final List students = jsonDecode(resS.body);
        final List groups = jsonDecode(resG.body);
        
        setState(() {
          _alumnos = students;
          _groupId = groups.isNotEmpty ? groups[0]['_id'] : '123456789012345678901234';
          for (var s in students) {
            _asistencias[s['_id']] = 'present'; // por defecto
          }
          _cargando = false;
        });
      }
    } catch (_) {
      setState(() => _cargando = false);
    }
  }

  Future<void> _guardarAsistencia() async {
    setState(() => _guardando = true);
    try {
      final date = DateTime.now().toIso8601String();
      for (var s in _alumnos) {
        await http.post(
          Uri.parse('${dotenv.env['API_URL']}/api/attendance'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'date': date,
            'groupId': _groupId,
            'studentId': s['_id'],
            'status': _asistencias[s['_id']],
          })
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Asistencia guardada con éxito'), backgroundColor: Color(0xFF00C896)));
      }
    } catch (_) {}
    setState(() => _guardando = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) return const Center(child: CircularProgressIndicator());
    if (_alumnos.isEmpty) return const Center(child: Text("No hay alumnos registrados", style: TextStyle(color: Color(0xFF7A9189))));

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: _alumnos.length,
            itemBuilder: (context, i) {
              final a = _alumnos[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${a['nombre']} ${a['apellido']}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF0D1F1A))),
                          Text(a['matricula'] ?? 'Sin matrícula', style: const TextStyle(color: Color(0xFF7A9189), fontSize: 12)),
                        ],
                      ),
                    ),
                    _BotonEstado(icon: Icons.check, color: const Color(0xFF00C896), isSelected: _asistencias[a['_id']] == 'present', onTap: () => setState(() => _asistencias[a['_id']] = 'present')),
                    const SizedBox(width: 8),
                    _BotonEstado(icon: Icons.access_time_filled, color: const Color(0xFFF59E0B), isSelected: _asistencias[a['_id']] == 'late', onTap: () => setState(() => _asistencias[a['_id']] = 'late')),
                    const SizedBox(width: 8),
                    _BotonEstado(icon: Icons.close, color: const Color(0xFFE53935), isSelected: _asistencias[a['_id']] == 'absent', onTap: () => setState(() => _asistencias[a['_id']] = 'absent')),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]),
          child: GestureDetector(
            onTap: _guardando ? null : _guardarAsistencia,
            child: Container(
              width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(color: _guardando ? const Color(0xFF00C896).withOpacity(0.5) : const Color(0xFF00C896), borderRadius: BorderRadius.circular(16)),
              child: Center(child: _guardando ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Guardar Asistencia', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15))),
            ),
          ),
        ),
      ],
    );
  }
}

class _BotonEstado extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  const _BotonEstado({required this.icon, required this.color, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: isSelected ? color : color.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: isSelected ? Colors.white : color),
      ),
    );
  }
}

class _HorariosPlaceholder extends StatelessWidget {
  const _HorariosPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.schedule_rounded,
                size: 44, color: Color(0xFF6C63FF)),
          ),
          const SizedBox(height: 16),
          const Text('No hay horarios generados',
              style: TextStyle(
                  color: Color(0xFF7A9189),
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text('Presiona "Generar Horario" para comenzar',
              style: TextStyle(color: Color(0xFFB0C4BB), fontSize: 12)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MODAL: CERRAR SESIÓN
// ─────────────────────────────────────────────────────────────────────────────
class _LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const _LogoutDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout_rounded,
                  color: Color(0xFFE53935), size: 32),
            ),
            const SizedBox(height: 20),
            const Text(
              '¿Cerrar sesión?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0D1F1A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Se cerrará tu sesión actual y tendrás que volver a iniciar sesión.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFF7A9189), fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F8F7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text('Cancelar',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF7A9189),
                                fontSize: 14)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text('Salir',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 14)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MODAL: CREAR CLASE
// ─────────────────────────────────────────────────────────────────────────────
class _CrearClaseModal extends StatefulWidget {
  final List alumnos;

  const _CrearClaseModal({required this.alumnos});

  @override
  State<_CrearClaseModal> createState() => _CrearClaseModalState();
}

class _CrearClaseModalState extends State<_CrearClaseModal> {
  final _nombreCtrl = TextEditingController();
  final _materiaCtrl = TextEditingController();
  final _aulaCtrl = TextEditingController();
  String? _gradoSeleccionado;
  bool _guardando = false;

  static const _grados = ['1°A', '1°B', '2°A', '2°B', '3°A', '3°B'];

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _materiaCtrl.dispose();
    _aulaCtrl.dispose();
    super.dispose();
  }

  void _guardar() async {
    if (_nombreCtrl.text.isEmpty || _materiaCtrl.text.isEmpty) return;
    setState(() => _guardando = true);
    try {
      await http.post(
        Uri.parse('${dotenv.env['API_URL']}/api/groups'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'groupCode': _gradoSeleccionado ?? 'N/A',
          'classroom': _aulaCtrl.text,
          'period': 'Actual',
        }),
      );
    } catch (_) {}
    setState(() => _guardando = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E8E4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            // Encabezado
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C896).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add_circle_outline_rounded,
                      color: Color(0xFF00C896), size: 22),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nueva Clase',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0D1F1A))),
                    Text('Completa los datos de la clase',
                        style: TextStyle(
                            fontSize: 12, color: Color(0xFF7A9189))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Campos
            _ModalField(
                controller: _nombreCtrl,
                label: 'Nombre de la clase',
                hint: 'ej. Matemáticas Avanzadas',
                icon: Icons.school_outlined),
            const SizedBox(height: 14),
            _ModalField(
                controller: _materiaCtrl,
                label: 'Materia',
                hint: 'ej. Álgebra',
                icon: Icons.menu_book_outlined),
            const SizedBox(height: 14),
            _ModalField(
                controller: _aulaCtrl,
                label: 'Aula',
                hint: 'ej. Salón 204',
                icon: Icons.room_outlined),
            const SizedBox(height: 14),
            // Dropdown grado
            const Text('Grado / Grupo',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7A9189))),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0E8E4)),
                borderRadius: BorderRadius.circular(14),
                color: const Color(0xFFF9FBFA),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _gradoSeleccionado,
                  hint: const Text('Selecciona grado',
                      style: TextStyle(
                          color: Color(0xFFB0C4BB), fontSize: 13)),
                  isExpanded: true,
                  items: _grados
                      .map((g) => DropdownMenuItem(
                          value: g,
                          child: Text(g,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0D1F1A)))))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _gradoSeleccionado = v),
                ),
              ),
            ),
            const SizedBox(height: 28),
            // Botón guardar
            GestureDetector(
              onTap: _guardando ? null : _guardar,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _guardando
                      ? const Color(0xFF00C896).withOpacity(0.5)
                      : const Color(0xFF00C896),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color:
                          const Color(0xFF00C896).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: _guardando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text(
                          'Crear Clase',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MODAL: GENERAR HORARIO
// ─────────────────────────────────────────────────────────────────────────────
class _GenerarHorarioModal extends StatefulWidget {
  const _GenerarHorarioModal();

  @override
  State<_GenerarHorarioModal> createState() => _GenerarHorarioModalState();
}

class _GenerarHorarioModalState extends State<_GenerarHorarioModal> {
  final _nombreCtrl = TextEditingController();
  final _inicioCtrl = TextEditingController();
  final _finCtrl = TextEditingController();
  final Set<String> _diasSeleccionados = {};
  bool _guardando = false;

  static const _dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _inicioCtrl.dispose();
    _finCtrl.dispose();
    super.dispose();
  }

  void _guardar() async {
    if (_nombreCtrl.text.isEmpty || _diasSeleccionados.isEmpty) return;
    setState(() => _guardando = true);
    try {
      await http.post(
        Uri.parse('${dotenv.env['API_URL']}/api/schedules'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'classroom': _nombreCtrl.text,
          'startTime': _inicioCtrl.text,
          'endTime': _finCtrl.text,
          'dayOfWeek': 1,
        }),
      );
    } catch (_) {}
    setState(() => _guardando = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E8E4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.calendar_month_rounded,
                      color: Color(0xFF6C63FF), size: 22),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Generar Horario',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0D1F1A))),
                    Text('Define el horario de la clase',
                        style: TextStyle(
                            fontSize: 12, color: Color(0xFF7A9189))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            _ModalField(
                controller: _nombreCtrl,
                label: 'Clase o materia',
                hint: 'ej. Matemáticas 1°A',
                icon: Icons.menu_book_outlined),
            const SizedBox(height: 14),
            // Hora inicio / fin
            Row(
              children: [
                Expanded(
                  child: _ModalField(
                      controller: _inicioCtrl,
                      label: 'Hora inicio',
                      hint: '08:00',
                      icon: Icons.access_time_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ModalField(
                      controller: _finCtrl,
                      label: 'Hora fin',
                      hint: '09:30',
                      icon: Icons.access_time_filled_rounded),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Días
            const Text('Días',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7A9189))),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _dias.map((dia) {
                final selected = _diasSeleccionados.contains(dia);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (selected) {
                      _diasSeleccionados.remove(dia);
                    } else {
                      _diasSeleccionados.add(dia);
                    }
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF6C63FF)
                          : const Color(0xFFF6F8F7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF6C63FF)
                            : const Color(0xFFE0E8E4),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        dia,
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : const Color(0xFF7A9189),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: _guardando ? null : _guardar,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _guardando
                      ? const Color(0xFF6C63FF).withOpacity(0.5)
                      : const Color(0xFF6C63FF),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: _guardando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text(
                          'Generar Horario',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CAMPO DE TEXTO REUTILIZABLE PARA MODALES
// ─────────────────────────────────────────────────────────────────────────────
class _ModalField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;

  const _ModalField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7A9189))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0D1F1A)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
                color: Color(0xFFB0C4BB), fontSize: 13),
            prefixIcon: Icon(icon, size: 18, color: const Color(0xFF7A9189)),
            filled: true,
            fillColor: const Color(0xFFF9FBFA),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE0E8E4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE0E8E4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                  color: Color(0xFF00C896), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}