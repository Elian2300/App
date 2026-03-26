import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class AlumnoPage extends StatefulWidget {
  final String role;

  const AlumnoPage({super.key, required this.role});

  @override
  State<AlumnoPage> createState() => _AlumnoPageState();
}

class _AlumnoPageState extends State<AlumnoPage> {
  // ── Colores ────────────────────────────────────────────────────────────────
  static const Color _primary   = Color(0xFF1A3C6E);
  static const Color _accent    = Color(0xFF4F8EF7);
  static const Color _bg        = Color(0xFFF5F7FA);
  static const Color _textDark  = Color(0xFF0D1F3C);
  static const Color _textMuted = Color(0xFF8A9BB8);

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
              switchOutCurve: Curves.easeIn,
              child: _selectedTab == 0
                  ? _PanelTab(
                      key: const ValueKey(0),
                      onTabChange: (i) =>
                          setState(() => _selectedTab = i),
                    )
                  : _selectedTab == 1
                      ? const _MateriasTab(key: ValueKey(1))
                      : const _PerfilTab(key: ValueKey(2)),
            ),
          ),
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
  final VoidCallback onLogout;

  const _Header({required this.role, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A3C6E),
        borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(30)),
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
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F8EF7).withOpacity(0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.school_rounded,
                        color: Color(0xFF4F8EF7), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Panel Alumno',
                          style: TextStyle(
                              color: Color(0xFF7FA4D0),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.4)),
                      Text(role,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3)),
                    ],
                  ),
                  const Spacer(),
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
                  _StatPill(Icons.menu_book_rounded, '8 Materias',
                      const Color(0xFFF59E0B)),
                  const SizedBox(width: 10),
                  _StatPill(Icons.star_rounded, 'Promedio 9.2',
                      const Color(0xFF4F8EF7)),
                  const SizedBox(width: 10),
                  _StatPill(Icons.assignment_rounded, '3 Pendientes',
                      const Color(0xFF10B981)),
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
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
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

  const _CustomTabBar(
      {required this.selected, required this.onTap});

  static const _tabs = [
    ('Inicio', Icons.home_rounded),
    ('Materias', Icons.menu_book_rounded),
    ('Perfil', Icons.person_rounded),
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
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 6),
                decoration: BoxDecoration(
                  color: sel
                      ? const Color(0xFF1A3C6E)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_tabs[i].$2,
                        size: 15,
                        color: sel
                            ? const Color(0xFF4F8EF7)
                            : const Color(0xFF8A9BB8)),
                    const SizedBox(width: 5),
                    Text(_tabs[i].$1,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: sel
                                ? Colors.white
                                : const Color(0xFF8A9BB8))),
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
// TAB 0 — PANEL PRINCIPAL
// ─────────────────────────────────────────────────────────────────────────────
class _PanelTab extends StatelessWidget {
  final ValueChanged<int> onTabChange;

  const _PanelTab({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner aviso
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A3C6E), Color(0xFF2D5FA8)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.notifications_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Examen de Matemáticas',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 13)),
                      SizedBox(height: 3),
                      Text('Mañana a las 08:00 hrs — Salón 204',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text('Accesos rápidos',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8A9BB8),
                  letterSpacing: 1.2)),
          const SizedBox(height: 14),

          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.05,
            children: [
              _GridCard(
                  icon: Icons.book_rounded,
                  title: 'Materias',
                  colorA: const Color(0xFFF59E0B),
                  colorB: const Color(0xFFFF6B35),
                  onTap: () => onTabChange(1)),
              _GridCard(
                  icon: Icons.assignment_rounded,
                  title: 'Tareas',
                  colorA: const Color(0xFF10B981),
                  colorB: const Color(0xFF06B6D4),
                  onTap: () {}),
              _GridCard(
                  icon: Icons.grade_rounded,
                  title: 'Calificaciones',
                  colorA: const Color(0xFF8B5CF6),
                  colorB: const Color(0xFFEC4899),
                  onTap: () {}),
              _GridCard(
                  icon: Icons.person_rounded,
                  title: 'Perfil',
                  colorA: const Color(0xFF4F8EF7),
                  colorB: const Color(0xFF1A3C6E),
                  onTap: () => onTabChange(2)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TARJETA GRID
// ─────────────────────────────────────────────────────────────────────────────
class _GridCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color colorA;
  final Color colorB;
  final VoidCallback onTap;

  const _GridCard(
      {required this.icon,
      required this.title,
      required this.colorA,
      required this.colorB,
      required this.onTap});

  @override
  State<_GridCard> createState() => _GridCardState();
}

class _GridCardState extends State<_GridCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 100),
        lowerBound: 0,
        upperBound: 0.03);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) =>
            Transform.scale(scale: 1.0 - _ctrl.value, child: child),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                  color: widget.colorA.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 6)),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -18,
                right: -18,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.colorA.withOpacity(0.07),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [widget.colorA, widget.colorB],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: widget.colorA.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: Icon(widget.icon,
                          color: Colors.white, size: 22),
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(widget.title,
                            style: const TextStyle(
                                color: Color(0xFF0D1F3C),
                                fontSize: 14,
                                fontWeight: FontWeight.w800)),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color:
                                widget.colorA.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(8),
                          ),
                          child: Icon(
                              Icons.arrow_forward_rounded,
                              color: widget.colorA,
                              size: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 1 — MATERIAS
// ─────────────────────────────────────────────────────────────────────────────
class _MateriasTab extends StatelessWidget {
  const _MateriasTab({super.key});

  static const _materias = [
    _MateriaData('Matemáticas', 'Prof. García',
        Icons.calculate_rounded, Color(0xFFF59E0B), '9.5',
        'Lun / Mié / Vie', '08:00 – 09:30'),
    _MateriaData('Español', 'Prof. Ramírez',
        Icons.menu_book_rounded, Color(0xFF10B981), '8.8',
        'Mar / Jue', '07:00 – 08:30'),
    _MateriaData('Ciencias', 'Prof. López',
        Icons.science_rounded, Color(0xFF4F8EF7), '9.0',
        'Lun / Jue', '10:00 – 11:30'),
    _MateriaData('Historia', 'Prof. Torres',
        Icons.history_edu_rounded, Color(0xFF8B5CF6), '8.5',
        'Mar / Vie', '11:00 – 12:30'),
    _MateriaData('Inglés', 'Prof. Smith',
        Icons.translate_rounded, Color(0xFFEC4899), '9.2',
        'Lun / Mié', '13:00 – 14:00'),
    _MateriaData('Educación Física', 'Prof. Morales',
        Icons.directions_run_rounded, Color(0xFF06B6D4), '10',
        'Vie', '14:00 – 15:00'),
    _MateriaData('Arte', 'Prof. Vega',
        Icons.palette_rounded, Color(0xFFFF6B35), '9.8',
        'Mié', '15:00 – 16:00'),
    _MateriaData('Computación', 'Prof. Núñez',
        Icons.computer_rounded, Color(0xFF1A3C6E), '9.0',
        'Jue', '16:00 – 17:00'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 2),
          child: Text('Mis Materias',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0D1F3C),
                  letterSpacing: -0.3)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
          child: Text('${_materias.length} materias inscritas',
              style: const TextStyle(
                  color: Color(0xFF8A9BB8), fontSize: 12)),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            physics: const BouncingScrollPhysics(),
            itemCount: _materias.length,
            itemBuilder: (_, i) =>
                _MateriaCard(data: _materias[i]),
          ),
        ),
      ],
    );
  }
}

class _MateriaData {
  final String nombre;
  final String profesor;
  final IconData icon;
  final Color color;
  final String calificacion;
  final String dias;
  final String horario;

  const _MateriaData(this.nombre, this.profesor, this.icon,
      this.color, this.calificacion, this.dias, this.horario);
}

class _MateriaCard extends StatelessWidget {
  final _MateriaData data;

  const _MateriaCard({required this.data});

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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {},
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
                  child: Icon(data.icon,
                      color: data.color, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(data.nombre,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: Color(0xFF0D1F3C))),
                      const SizedBox(height: 3),
                      Text(data.profesor,
                          style: const TextStyle(
                              color: Color(0xFF8A9BB8),
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _InfoChip(
                              Icons.schedule_rounded,
                              data.horario,
                              data.color),
                          const SizedBox(width: 8),
                          _InfoChip(
                              Icons.calendar_today_rounded,
                              data.dias,
                              data.color),
                        ],
                      ),
                    ],
                  ),
                ),
                // Calificación
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: data.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(data.calificacion,
                      style: TextStyle(
                          color: data.color,
                          fontWeight: FontWeight.w900,
                          fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip(this.icon, this.label, this.color);

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

// ─────────────────────────────────────────────────────────────────────────────
// TAB 2 — PERFIL
// ─────────────────────────────────────────────────────────────────────────────
class _PerfilTab extends StatelessWidget {
  const _PerfilTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        children: [
          // Avatar card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF1A3C6E),
                            Color(0xFF4F8EF7)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFF4F8EF7)
                                  .withOpacity(0.3),
                              blurRadius: 14,
                              offset: const Offset(0, 6))
                        ],
                      ),
                      child: const Center(
                        child: Text('A',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w900)),
                      ),
                    ),
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.check_rounded,
                          color: Colors.white, size: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Alumno Ejemplo',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0D1F3C),
                        letterSpacing: -0.4)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F8EF7)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('3°A • Turno Matutino',
                      style: TextStyle(
                          color: Color(0xFF4F8EF7),
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 20),
                Row(
                  children: const [
                    _PerfilStat(
                        '9.2', 'Promedio', Color(0xFF4F8EF7)),
                    _PerfilStat(
                        '8', 'Materias', Color(0xFFF59E0B)),
                    _PerfilStat(
                        '95%', 'Asistencia', Color(0xFF10B981)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _SectionCard(
            title: 'Datos Personales',
            icon: Icons.person_outline_rounded,
            color: const Color(0xFF4F8EF7),
            children: const [
              _DataRow(Icons.badge_outlined, 'Matrícula',
                  'ALU-2024-001'),
              _DataRow(Icons.cake_outlined, 'Fecha de nacimiento',
                  '12 / Mar / 2010'),
              _DataRow(
                  Icons.wc_rounded, 'Género', 'Masculino'),
              _DataRow(Icons.location_on_outlined, 'Dirección',
                  'Calle Principal #42'),
            ],
          ),

          const SizedBox(height: 12),

          _SectionCard(
            title: 'Contacto',
            icon: Icons.contact_phone_outlined,
            color: const Color(0xFF10B981),
            children: const [
              _DataRow(Icons.phone_outlined, 'Teléfono',
                  '844-000-0000'),
              _DataRow(Icons.email_outlined, 'Correo',
                  'alumno@escuela.edu.mx'),
              _DataRow(Icons.people_outline_rounded, 'Tutor',
                  'Nombre del Tutor'),
              _DataRow(Icons.phone_in_talk_outlined, 'Tel. Tutor',
                  '844-111-1111'),
            ],
          ),

          const SizedBox(height: 12),

          _SectionCard(
            title: 'Información Escolar',
            icon: Icons.school_outlined,
            color: const Color(0xFF8B5CF6),
            children: const [
              _DataRow(
                  Icons.class_outlined, 'Grado y grupo', '3°A'),
              _DataRow(
                  Icons.wb_sunny_outlined, 'Turno', 'Matutino'),
              _DataRow(Icons.calendar_today_rounded,
                  'Ciclo escolar', '2024 – 2025'),
              _DataRow(Icons.domain_rounded, 'Plantel',
                  'Escuela Secundaria Técnica'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PerfilStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _PerfilStat(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: color,
                  letterSpacing: -0.5)),
          const SizedBox(height: 3),
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF8A9BB8),
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const _SectionCard(
      {required this.title,
      required this.icon,
      required this.color,
      required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                const SizedBox(width: 10),
                Text(title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0D1F3C))),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0F4FA)),
          ...children,
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DataRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF8A9BB8)),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF8A9BB8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  color: Color(0xFF0D1F3C),
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
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
                    color: Color(0xFF0D1F3C))),
            const SizedBox(height: 8),
            const Text(
                'Se cerrará tu sesión actual. Tendrás que volver a iniciar sesión.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF8A9BB8),
                    fontSize: 13,
                    height: 1.5)),
            const SizedBox(height: 26),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14),
                      decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FA),
                          borderRadius:
                              BorderRadius.circular(14)),
                      child: const Center(
                          child: Text('Cancelar',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF8A9BB8),
                                  fontSize: 14))),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14),
                      decoration: BoxDecoration(
                          color: const Color(0xFFE53935),
                          borderRadius:
                              BorderRadius.circular(14)),
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