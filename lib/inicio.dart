import 'package:flutter/material.dart';
import 'main.dart';

class InicioPage extends StatefulWidget {

  final String role;

  const InicioPage({super.key, required this.role});

  @override
  State<InicioPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<InicioPage> {
  // ── Colores ────────────────────────────────────────────────────────────────
  static const Color _primary    = Color(0xFF1A1A2E);
  static const Color _accent     = Color(0xFFE94560);
  static const Color _bg         = Color(0xFFF8F9FC);
  static const Color _textDark   = Color(0xFF1A1A2E);
  static const Color _textMuted  = Color(0xFF8A93A8);

  int _selectedTab = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          _Header(role: widget.role, onLogout: _cerrarSesion),

          // ── Tab Bar ─────────────────────────────────────────────────────
          _CustomTabBar(
            selected: _selectedTab,
            onTap: (i) => setState(() => _selectedTab = i),
          ),

          // ── Contenido ───────────────────────────────────────────────────
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              switchInCurve: Curves.easeOut,
              child: [
                const _InicioTab(key: ValueKey(0)),
                const _MaestrosTab(key: ValueKey(1)),
                const _AlumnosTab(key: ValueKey(2)),
                const _AulasTab(key: ValueKey(3)),
                const _HorariosTab(key: ValueKey(4)),
              ][_selectedTab],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HEADER — muestra widget.role
// ─────────────────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final String role;
  final VoidCallback onLogout;

  const _Header({required this.role, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF0F3460)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE94560).withOpacity(0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.admin_panel_settings_rounded,
                        color: Color(0xFFE94560), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Panel Administrador',
                        style: TextStyle(
                          color: Color(0xFF8A9BB8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.4,
                        ),
                      ),
                      // ← role original sin mover
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
                              color: Color(0xFFFF7070), size: 14),
                          SizedBox(width: 6),
                          Text('Salir',
                              style: TextStyle(
                                  color: Color(0xFFFF7070),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _StatPill(Icons.person_rounded, '24 Maestros',
                      const Color(0xFF4FC3F7)),
                  const SizedBox(width: 10),
                  _StatPill(Icons.people_rounded, '320 Alumnos',
                      const Color(0xFF81C784)),
                  const SizedBox(width: 10),
                  _StatPill(Icons.meeting_room_rounded, '12 Aulas',
                      const Color(0xFFFFB74D)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _StatPill(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB BAR
// ─────────────────────────────────────────────────────────────────────────────
class _CustomTabBar extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  const _CustomTabBar({required this.selected, required this.onTap});

  static const _tabs = [
    ('Inicio',   Icons.home_rounded),
    ('Maestros', Icons.person_rounded),
    ('Alumnos',  Icons.people_rounded),
    ('Aulas',    Icons.meeting_room_rounded),
    ('Horarios', Icons.schedule_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      margin: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final sel = selected == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: sel ? const Color(0xFF1A1A2E) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_tabs[i].$2,
                        size: 16,
                        color: sel
                            ? const Color(0xFFE94560)
                            : const Color(0xFF8A93A8)),
                    const SizedBox(height: 2),
                    Text(_tabs[i].$1,
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: sel
                                ? Colors.white
                                : const Color(0xFF8A93A8))),
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
// TAB 0 — INICIO
// ─────────────────────────────────────────────────────────────────────────────
class _InicioTab extends StatelessWidget {
  const _InicioTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE94560), Color(0xFFB71C1C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Buen día, Coordinador',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                      SizedBox(height: 6),
                      Text('Tienes 3 horarios\npendientes de validar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              height: 1.3)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.warning_amber_rounded,
                      color: Colors.white, size: 32),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const _SectionLabel('Acciones rápidas'),
          const SizedBox(height: 14),

          // ── Botones originales intactos, solo rediseñados ────────────────
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.1,
            children: [
              _AccionCard(
                icon: Icons.manage_accounts_rounded,
                title: 'Gestionar usuarios',   // ← original
                subtitle: 'Administrar cuentas',
                colorA: const Color(0xFF4FC3F7),
                colorB: const Color(0xFF0288D1),
                onPressed: () {},              // ← onPressed original
              ),
              _AccionCard(
                icon: Icons.add_circle_rounded,
                title: 'Crear clases',          // ← original
                subtitle: 'Nueva clase',
                colorA: const Color(0xFF81C784),
                colorB: const Color(0xFF388E3C),
                onPressed: () {},              // ← onPressed original
              ),
              _AccionCard(
                icon: Icons.meeting_room_rounded,
                title: 'Asignar aulas',         // ← original
                subtitle: 'Gestionar espacios',
                colorA: const Color(0xFFFFB74D),
                colorB: const Color(0xFFF57C00),
                onPressed: () {},              // ← onPressed original
              ),
              _AccionCard(
                icon: Icons.fact_check_rounded,
                title: 'Ver asistencia',        // ← original
                subtitle: 'Revisar registros',
                colorA: const Color(0xFFE94560),
                colorB: const Color(0xFFB71C1C),
                onPressed: () {},              // ← onPressed original
              ),
            ],
          ),

          const SizedBox(height: 24),
          const _SectionLabel('Actividad reciente'),
          const SizedBox(height: 12),

          _ActividadItem(
            icon: Icons.person_add_rounded,
            color: const Color(0xFF4FC3F7),
            titulo: 'Nuevo maestro registrado',
            subtitulo: 'Prof. García — Matemáticas',
            tiempo: 'Hace 2h',
          ),
          _ActividadItem(
            icon: Icons.meeting_room_rounded,
            color: const Color(0xFFFFB74D),
            titulo: 'Aula 204 asignada',
            subtitulo: 'Ciencias — 3°A',
            tiempo: 'Hace 4h',
          ),
          _ActividadItem(
            icon: Icons.schedule_rounded,
            color: const Color(0xFF81C784),
            titulo: 'Horario actualizado',
            subtitulo: 'Turno Matutino — Lunes',
            tiempo: 'Ayer',
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF8A93A8),
            letterSpacing: 1.2));
  }
}

class _AccionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color colorA;
  final Color colorB;
  final VoidCallback onPressed; // ← onPressed original

  const _AccionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colorA,
    required this.colorB,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: colorA.withOpacity(0.15),
                blurRadius: 14,
                offset: const Offset(0, 5))
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -16,
              right: -16,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorA.withOpacity(0.07)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [colorA, colorB],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: [
                        BoxShadow(
                            color: colorA.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 22),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: Color(0xFF1A1A2E))),
                      Text(subtitle,
                          style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF8A93A8),
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActividadItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String titulo;
  final String subtitulo;
  final String tiempo;

  const _ActividadItem({
    required this.icon,
    required this.color,
    required this.titulo,
    required this.subtitulo,
    required this.tiempo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Color(0xFF1A1A2E))),
                Text(subtitulo,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF8A93A8))),
              ],
            ),
          ),
          Text(tiempo,
              style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF8A93A8),
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 1 — MAESTROS
// ─────────────────────────────────────────────────────────────────────────────
class _MaestrosTab extends StatelessWidget {
  const _MaestrosTab({super.key});

  static const _maestros = [
    _PersonaData('Carlos García',  'Matemáticas', 'carlos@escuela.edu.mx', '3°A, 2°B', Color(0xFF4FC3F7)),
    _PersonaData('Ana Ramírez',    'Español',     'ana@escuela.edu.mx',    '1°A, 1°B', Color(0xFF81C784)),
    _PersonaData('Roberto López',  'Ciencias',    'roberto@escuela.edu.mx','2°A, 3°B', Color(0xFFFFB74D)),
    _PersonaData('María Torres',   'Historia',    'maria@escuela.edu.mx',  '1°C, 2°C', Color(0xFFE94560)),
    _PersonaData('John Smith',     'Inglés',      'john@escuela.edu.mx',   '3°A, 3°B', Color(0xFF9575CD)),
    _PersonaData('Luis Morales',   'Ed. Física',  'luis@escuela.edu.mx',   'Todos',    Color(0xFF4DB6AC)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              const Text('Maestros',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E))),
              const Spacer(),
              _AddButton(label: 'Agregar', onTap: () {}),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
          child: Row(
            children: [
              Text('${_maestros.length} docentes registrados',
                  style: const TextStyle(
                      color: Color(0xFF8A93A8), fontSize: 12)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            physics: const BouncingScrollPhysics(),
            itemCount: _maestros.length,
            itemBuilder: (_, i) =>
                _MaestroCard(data: _maestros[i]),
          ),
        ),
      ],
    );
  }
}

class _PersonaData {
  final String nombre;
  final String materia;
  final String correo;
  final String grupos;
  final Color color;
  const _PersonaData(
      this.nombre, this.materia, this.correo, this.grupos, this.color);
}

class _MaestroCard extends StatelessWidget {
  final _PersonaData data;
  const _MaestroCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final inicial = data.nombre[0].toUpperCase();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3))
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
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: data.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(inicial,
                        style: TextStyle(
                            color: data.color,
                            fontWeight: FontWeight.w900,
                            fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.nombre,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: Color(0xFF1A1A2E))),
                      const SizedBox(height: 3),
                      Text(data.materia,
                          style: const TextStyle(
                              color: Color(0xFF8A93A8),
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _MiniChip(Icons.class_outlined,
                              data.grupos, data.color),
                          const SizedBox(width: 8),
                          _MiniChip(Icons.email_outlined,
                              data.correo, data.color),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    _IconBtn(Icons.edit_rounded,
                        const Color(0xFF4FC3F7), () {}),
                    const SizedBox(height: 6),
                    _IconBtn(Icons.delete_rounded,
                        const Color(0xFFE94560), () {}),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 2 — ALUMNOS
// ─────────────────────────────────────────────────────────────────────────────
class _AlumnosTab extends StatelessWidget {
  const _AlumnosTab({super.key});

  static const _alumnos = [
    _PersonaData('Ana Pérez',    '3°A', 'Matrícula: ALU-001', '9.5', Color(0xFF4FC3F7)),
    _PersonaData('Luis Méndez', '3°A', 'Matrícula: ALU-002', '8.8', Color(0xFF81C784)),
    _PersonaData('Sofía Castro','2°B', 'Matrícula: ALU-003', '9.2', Color(0xFFFFB74D)),
    _PersonaData('Diego Ruiz',  '1°C', 'Matrícula: ALU-004', '7.5', Color(0xFFE94560)),
    _PersonaData('Valeria Soto','2°A', 'Matrícula: ALU-005', '9.8', Color(0xFF9575CD)),
    _PersonaData('Carlos Vega', '3°B', 'Matrícula: ALU-006', '8.0', Color(0xFF4DB6AC)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              const Text('Alumnos',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E))),
              const Spacer(),
              _AddButton(label: 'Agregar', onTap: () {}),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
          child: Text('${_alumnos.length} alumnos registrados',
              style: const TextStyle(
                  color: Color(0xFF8A93A8), fontSize: 12)),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            physics: const BouncingScrollPhysics(),
            itemCount: _alumnos.length,
            itemBuilder: (_, i) =>
                _AlumnoCard(data: _alumnos[i]),
          ),
        ),
      ],
    );
  }
}

class _AlumnoCard extends StatelessWidget {
  final _PersonaData data;
  const _AlumnoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final inicial = data.nombre[0].toUpperCase();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3))
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
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: data.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(inicial,
                        style: TextStyle(
                            color: data.color,
                            fontWeight: FontWeight.w900,
                            fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.nombre,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: Color(0xFF1A1A2E))),
                      const SizedBox(height: 3),
                      Text(data.correo,
                          style: const TextStyle(
                              color: Color(0xFF8A93A8),
                              fontSize: 12)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _MiniChip(Icons.class_outlined,
                              data.materia, data.color),
                          const SizedBox(width: 8),
                          _MiniChip(Icons.grade_rounded,
                              data.grupos, data.color),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    _IconBtn(Icons.edit_rounded,
                        const Color(0xFF4FC3F7), () {}),
                    const SizedBox(height: 6),
                    _IconBtn(Icons.delete_rounded,
                        const Color(0xFFE94560), () {}),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 3 — AULAS
// ─────────────────────────────────────────────────────────────────────────────
class _AulasTab extends StatefulWidget {
  const _AulasTab({super.key});

  @override
  State<_AulasTab> createState() => _AulasTabState();
}

class _AulasTabState extends State<_AulasTab> {
  final _aulas = [
    _AulaData('Salón 101',    'Planta Baja', 35,  'Matemáticas',  true),
    _AulaData('Salón 102',    'Planta Baja', 30,  'Español',      false),
    _AulaData('Salón 201',    'Primer Piso', 40,  'Ciencias',     true),
    _AulaData('Salón 202',    'Primer Piso', 35,  'Historia',     false),
    _AulaData('Lab. Cómputo', 'Planta Baja', 25,  'Computación',  true),
    _AulaData('Gimnasio',     'Exterior',    100, 'Ed. Física',   true),
  ];

  void _abrirCrearAula() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => _CrearAulaModal(
        onGuardar: (aula) => setState(() => _aulas.add(aula)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              const Text('Aulas',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E))),
              const Spacer(),
              _AddButton(
                  label: 'Crear aula', onTap: _abrirCrearAula),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
          child: Text('${_aulas.length} aulas registradas',
              style: const TextStyle(
                  color: Color(0xFF8A93A8), fontSize: 12)),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            physics: const BouncingScrollPhysics(),
            itemCount: _aulas.length,
            itemBuilder: (_, i) => _AulaCard(data: _aulas[i]),
          ),
        ),
      ],
    );
  }
}

class _AulaData {
  final String nombre;
  final String ubicacion;
  final int capacidad;
  final String materia;
  final bool disponible;
  _AulaData(this.nombre, this.ubicacion, this.capacidad,
      this.materia, this.disponible);
}

class _AulaCard extends StatelessWidget {
  final _AulaData data;
  const _AulaCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final color = data.disponible
        ? const Color(0xFF81C784)
        : const Color(0xFFE94560);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB74D).withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.meeting_room_rounded,
                  color: Color(0xFFFFB74D), size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.nombre,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: Color(0xFF1A1A2E))),
                  const SizedBox(height: 3),
                  Text(
                      '${data.ubicacion} · Cap. ${data.capacidad}',
                      style: const TextStyle(
                          color: Color(0xFF8A93A8), fontSize: 12)),
                  const SizedBox(height: 6),
                  _MiniChip(Icons.menu_book_rounded,
                      data.materia, const Color(0xFFFFB74D)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                      data.disponible ? 'Disponible' : 'Ocupada',
                      style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 6),
                _IconBtn(Icons.edit_rounded,
                    const Color(0xFF4FC3F7), () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 4 — HORARIOS
// ─────────────────────────────────────────────────────────────────────────────
class _HorariosTab extends StatefulWidget {
  const _HorariosTab({super.key});

  @override
  State<_HorariosTab> createState() => _HorariosTabState();
}

class _HorariosTabState extends State<_HorariosTab> {
  final _horarios = [
    _HorarioData('Prof. García',  'Matemáticas', 'Salón 101', 'Lun / Mié / Vie', '08:00 – 09:30', Color(0xFF4FC3F7)),
    _HorarioData('Prof. Ramírez', 'Español',     'Salón 102', 'Mar / Jue',       '07:00 – 08:30', Color(0xFF81C784)),
    _HorarioData('Prof. López',   'Ciencias',    'Salón 201', 'Lun / Jue',       '10:00 – 11:30', Color(0xFFFFB74D)),
    _HorarioData('Prof. Torres',  'Historia',    'Salón 202', 'Mar / Vie',       '11:00 – 12:30', Color(0xFF9575CD)),
  ];

  void _abrirCrearHorario() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => const _CrearHorarioModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              const Text('Horarios',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E))),
              const Spacer(),
              _AddButton(
                  label: 'Crear horario',
                  onTap: _abrirCrearHorario),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
          child: Text('${_horarios.length} horarios asignados',
              style: const TextStyle(
                  color: Color(0xFF8A93A8), fontSize: 12)),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            physics: const BouncingScrollPhysics(),
            itemCount: _horarios.length,
            itemBuilder: (_, i) =>
                _HorarioCard(data: _horarios[i]),
          ),
        ),
      ],
    );
  }
}

class _HorarioData {
  final String profesor;
  final String materia;
  final String aula;
  final String dias;
  final String horario;
  final Color color;
  const _HorarioData(this.profesor, this.materia, this.aula,
      this.dias, this.horario, this.color);
}

class _HorarioCard extends StatelessWidget {
  final _HorarioData data;
  const _HorarioCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: data.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.schedule_rounded,
                  color: data.color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.profesor,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: Color(0xFF1A1A2E))),
                  const SizedBox(height: 3),
                  Text('${data.materia} · ${data.aula}',
                      style: const TextStyle(
                          color: Color(0xFF8A93A8), fontSize: 12)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _MiniChip(Icons.calendar_today_rounded,
                          data.dias, data.color),
                      const SizedBox(width: 8),
                      _MiniChip(Icons.access_time_rounded,
                          data.horario, data.color),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                _IconBtn(Icons.edit_rounded,
                    const Color(0xFF4FC3F7), () {}),
                const SizedBox(height: 6),
                _IconBtn(Icons.delete_rounded,
                    const Color(0xFFE94560), () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MODAL: CREAR AULA
// ─────────────────────────────────────────────────────────────────────────────
class _CrearAulaModal extends StatefulWidget {
  final void Function(_AulaData) onGuardar;
  const _CrearAulaModal({required this.onGuardar});

  @override
  State<_CrearAulaModal> createState() => _CrearAulaModalState();
}

class _CrearAulaModalState extends State<_CrearAulaModal> {
  final _nombreCtrl    = TextEditingController();
  final _ubicacionCtrl = TextEditingController();
  final _capCtrl       = TextEditingController();
  final _materiaCtrl   = TextEditingController();
  bool _guardando = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _ubicacionCtrl.dispose();
    _capCtrl.dispose();
    _materiaCtrl.dispose();
    super.dispose();
  }

  void _guardar() async {
    if (_nombreCtrl.text.isEmpty) return;
    setState(() => _guardando = true);
    await Future.delayed(const Duration(milliseconds: 800));
    widget.onGuardar(_AulaData(
      _nombreCtrl.text,
      _ubicacionCtrl.text.isEmpty ? 'Sin ubicación' : _ubicacionCtrl.text,
      int.tryParse(_capCtrl.text) ?? 0,
      _materiaCtrl.text.isEmpty ? 'General' : _materiaCtrl.text,
      true,
    ));
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
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: const Color(0xFFE0E8F0),
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFB74D).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.add_home_rounded,
                      color: Color(0xFFFFB74D), size: 22),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nueva Aula',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A2E))),
                    Text('Registra un nuevo espacio',
                        style: TextStyle(
                            fontSize: 12, color: Color(0xFF8A93A8))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _ModalField(controller: _nombreCtrl,
                label: 'Nombre del aula',
                hint: 'ej. Salón 204',
                icon: Icons.meeting_room_outlined),
            const SizedBox(height: 12),
            _ModalField(controller: _ubicacionCtrl,
                label: 'Ubicación',
                hint: 'ej. Primer Piso',
                icon: Icons.location_on_outlined),
            const SizedBox(height: 12),
            _ModalField(controller: _capCtrl,
                label: 'Capacidad (alumnos)',
                hint: 'ej. 35',
                icon: Icons.people_outlined,
                tipo: TextInputType.number),
            const SizedBox(height: 12),
            _ModalField(controller: _materiaCtrl,
                label: 'Materia asignada',
                hint: 'ej. Matemáticas',
                icon: Icons.menu_book_outlined),
            const SizedBox(height: 24),
            _BotonGuardar(
              label: 'Crear Aula',
              color: const Color(0xFFFFB74D),
              guardando: _guardando,
              onTap: _guardar,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MODAL: CREAR HORARIO
// ─────────────────────────────────────────────────────────────────────────────
class _CrearHorarioModal extends StatefulWidget {
  const _CrearHorarioModal();

  @override
  State<_CrearHorarioModal> createState() => _CrearHorarioModalState();
}

class _CrearHorarioModalState extends State<_CrearHorarioModal> {
  final _profesorCtrl = TextEditingController();
  final _materiaCtrl  = TextEditingController();
  final _aulaCtrl     = TextEditingController();
  final _inicioCtrl   = TextEditingController();
  final _finCtrl      = TextEditingController();
  final Set<String> _dias = {};
  bool _guardando = false;

  static const _semana = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];

  @override
  void dispose() {
    _profesorCtrl.dispose();
    _materiaCtrl.dispose();
    _aulaCtrl.dispose();
    _inicioCtrl.dispose();
    _finCtrl.dispose();
    super.dispose();
  }

  void _guardar() async {
    if (_profesorCtrl.text.isEmpty) return;
    setState(() => _guardando = true);
    await Future.delayed(const Duration(milliseconds: 800));
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
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: const Color(0xFFE0E8F0),
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: const Color(0xFF81C784).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.calendar_month_rounded,
                      color: Color(0xFF81C784), size: 22),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Crear Horario',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A2E))),
                    Text('Asigna horario a un profesor',
                        style: TextStyle(
                            fontSize: 12, color: Color(0xFF8A93A8))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _ModalField(controller: _profesorCtrl,
                label: 'Profesor',
                hint: 'ej. Prof. García',
                icon: Icons.person_outlined),
            const SizedBox(height: 12),
            _ModalField(controller: _materiaCtrl,
                label: 'Materia',
                hint: 'ej. Matemáticas',
                icon: Icons.menu_book_outlined),
            const SizedBox(height: 12),
            _ModalField(controller: _aulaCtrl,
                label: 'Aula',
                hint: 'ej. Salón 101',
                icon: Icons.meeting_room_outlined),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ModalField(controller: _inicioCtrl,
                      label: 'Hora inicio',
                      hint: '08:00',
                      icon: Icons.access_time_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ModalField(controller: _finCtrl,
                      label: 'Hora fin',
                      hint: '09:30',
                      icon: Icons.access_time_filled_rounded),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text('Días',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8A93A8))),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _semana.map((d) {
                final sel = _dias.contains(d);
                return GestureDetector(
                  onTap: () => setState(() =>
                      sel ? _dias.remove(d) : _dias.add(d)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: sel
                          ? const Color(0xFF81C784)
                          : const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: sel
                              ? const Color(0xFF81C784)
                              : const Color(0xFFE0E8F0)),
                    ),
                    child: Center(
                      child: Text(d,
                          style: TextStyle(
                              color: sel
                                  ? Colors.white
                                  : const Color(0xFF8A93A8),
                              fontSize: 10,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            _BotonGuardar(
              label: 'Crear Horario',
              color: const Color(0xFF81C784),
              guardando: _guardando,
              onTap: _guardar,
            ),
          ],
        ),
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
            borderRadius: BorderRadius.circular(28)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  shape: BoxShape.circle),
              child: const Icon(Icons.logout_rounded,
                  color: Color(0xFFE53935), size: 32),
            ),
            const SizedBox(height: 18),
            const Text('¿Cerrar sesión?',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E))),
            const SizedBox(height: 8),
            const Text(
                'Se cerrará tu sesión de coordinador.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF8A93A8),
                    fontSize: 13,
                    height: 1.5)),
            const SizedBox(height: 26),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(14)),
                      child: const Center(
                          child: Text('Cancelar',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF8A93A8),
                                  fontSize: 14))),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                          color: const Color(0xFFE53935),
                          borderRadius: BorderRadius.circular(14)),
                      child: const Center(
                          child: Text('Salir',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 14))),
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
// WIDGETS REUTILIZABLES
// ─────────────────────────────────────────────────────────────────────────────
class _AddButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _AddButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.add_rounded,
                color: Color(0xFFE94560), size: 16),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _IconBtn(this.icon, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30, height: 30,
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(9)),
        child: Icon(icon, color: color, size: 14),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MiniChip(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 3),
        Text(label,
            style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _ModalField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType tipo;

  const _ModalField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.tipo = TextInputType.text,
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
                color: Color(0xFF8A93A8))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: tipo,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
                color: Color(0xFFB0BEC5), fontSize: 13),
            prefixIcon:
                Icon(icon, size: 18, color: const Color(0xFF8A93A8)),
            filled: true,
            fillColor: const Color(0xFFF8F9FC),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 13),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: Color(0xFFE0E8F0))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: Color(0xFFE0E8F0))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                    color: Color(0xFFE94560), width: 1.5)),
          ),
        ),
      ],
    );
  }
}

class _BotonGuardar extends StatelessWidget {
  final String label;
  final Color color;
  final bool guardando;
  final VoidCallback onTap;

  const _BotonGuardar({
    required this.label,
    required this.color,
    required this.guardando,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: guardando ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: guardando ? color.withOpacity(0.5) : color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 5))
          ],
        ),
        child: Center(
          child: guardando
              ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15)),
        ),
      ),
    );
  }
}