import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/http_logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
                _InicioTab(key: const ValueKey(0), onNavigate: (i) => setState(() => _selectedTab = i)),
                const _MaestrosTab(key: ValueKey(1)),
                const _AlumnosTab(key: ValueKey(2)),
                const _AulasTab(key: ValueKey(3)),
                const _HorariosTab(key: ValueKey(4)),
                const _UsuariosTab(key: ValueKey(5)),
                const _MateriasTab(key: ValueKey(6)),
                const _InscripcionesTab(key: ValueKey(7)),
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
class _Header extends StatefulWidget {
  final String role;
  final VoidCallback onLogout;

  const _Header({required this.role, required this.onLogout});

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  int _maestrosCount = 0;
  int _alumnosCount = 0;
  int _aulasCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCounts();
  }

  Future<void> _fetchCounts() async {
    try {
      final futures = await Future.wait([
        http.get(Uri.parse('${dotenv.env['API_URL']}/api/teachers')),
        http.get(Uri.parse('${dotenv.env['API_URL']}/api/students')),
        http.get(Uri.parse('${dotenv.env['API_URL']}/api/groups')),
      ]);
      
      if (mounted) {
        setState(() {
          if (futures[0].statusCode == 200) _maestrosCount = jsonDecode(futures[0].body).length;
          if (futures[1].statusCode == 200) _alumnosCount = jsonDecode(futures[1].body).length;
          if (futures[2].statusCode == 200) _aulasCount = jsonDecode(futures[2].body).length;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
                      Text(
                        widget.role,
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
                  GestureDetector(
                    onTap: widget.onLogout,
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
                  _StatPill(Icons.person_rounded, _isLoading ? '...' : '$_maestrosCount Maestros',
                      const Color(0xFF4FC3F7)),
                  const SizedBox(width: 10),
                  _StatPill(Icons.people_rounded, _isLoading ? '...' : '$_alumnosCount Alumnos',
                      const Color(0xFF81C784)),
                  const SizedBox(width: 10),
                  _StatPill(Icons.meeting_room_rounded, _isLoading ? '...' : '$_aulasCount Aulas',
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
    ('Usuarios', Icons.admin_panel_settings_rounded),
    ('Materias', Icons.menu_book_rounded),
    ('Inscrip.', Icons.assignment_ind_rounded),
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final sel = selected == i;
            return GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                width: 76,
                margin: const EdgeInsets.symmetric(horizontal: 2),
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
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: sel
                                ? Colors.white
                                : const Color(0xFF8A93A8))),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 0 — INICIO
// ─────────────────────────────────────────────────────────────────────────────
class _InicioTab extends StatelessWidget {
  final ValueChanged<int> onNavigate;
  const _InicioTab({super.key, required this.onNavigate});

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
            childAspectRatio: 1.0,
            children: [
              _AccionCard(
                icon: Icons.manage_accounts_rounded,
                title: 'Gestionar usuarios',   // ← original
                subtitle: 'Administrar cuentas',
                colorA: const Color(0xFF4FC3F7),
                colorB: const Color(0xFF0288D1),
                onPressed: () => onNavigate(5),              // ← navigate to Usuarios
              ),
              _AccionCard(
                icon: Icons.add_circle_rounded,
                title: 'Crear clases',          // ← original
                subtitle: 'Nueva clase',
                colorA: const Color(0xFF81C784),
                colorB: const Color(0xFF388E3C),
                onPressed: () => onNavigate(6),              // ← navigate to Materias
              ),
              _AccionCard(
                icon: Icons.meeting_room_rounded,
                title: 'Asignar aulas',         // ← original
                subtitle: 'Gestionar espacios',
                colorA: const Color(0xFFFFB74D),
                colorB: const Color(0xFFF57C00),
                onPressed: () => onNavigate(7),              // ← navigate to Inscripciones
              ),
              _AccionCard(
                icon: Icons.fact_check_rounded,
                title: 'Ver horarios',        // ← changed
                subtitle: 'Revisar maestros',
                colorA: const Color(0xFFE94560),
                colorB: const Color(0xFFB71C1C),
                onPressed: () => onNavigate(4),              // ← navigate to Horarios
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
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [colorA, colorB],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: colorA.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: Color(0xFF1A1A2E))),
                      const SizedBox(height: 2),
                      Text(subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
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
class _MaestrosTab extends StatefulWidget {
  const _MaestrosTab({super.key});

  @override
  State<_MaestrosTab> createState() => _MaestrosTabState();
}

class _MaestrosTabState extends State<_MaestrosTab> {
  List<_PersonaData> _maestros = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMaestros();
  }

  Future<void> _fetchMaestros() async {
    try {
      final res = await http.get(Uri.parse('${dotenv.env['API_URL']}/api/teachers'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        setState(() {
          _maestros = data.map((json) {
            return _PersonaData(
              json['_id'] ?? '',
              "${json['nombre']} ${json['apellido']}",
              json['especialidad'] ?? 'Sin asignar',
              json['email'] ?? 'N/A',
              'Todos',
              const Color(0xFF4FC3F7),
            );
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _eliminarMaestro(String id) async {
    try {
      await http.delete(Uri.parse('${dotenv.env['API_URL']}/api/teachers/$id'));
      _fetchMaestros();
    } catch (_) {}
  }

  void _abrirCrearMaestro() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => _CrearMaestroModal(
        onGuardar: () => _fetchMaestros(),
      ),
    );
  }

  void _abrirEditarMaestro(_PersonaData maestro) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => _CrearMaestroModal(
        personaActual: maestro,
        onGuardar: () => _fetchMaestros(),
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
              const Text('Maestros',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E))),
              const Spacer(),
              _AddButton(label: 'Agregar', onTap: _abrirCrearMaestro),
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
          child: _isLoading 
            ? const Center(child: CircularProgressIndicator()) 
            : _maestros.isEmpty 
              ? const Center(child: Text("No hay maestros", style: TextStyle(color: Color(0xFF8A93A8))))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _maestros.length,
                  itemBuilder: (_, i) => _MaestroCard(
                    data: _maestros[i],
                    onEdit: () => _abrirEditarMaestro(_maestros[i]),
                    onDelete: () => _eliminarMaestro(_maestros[i].id),
                  ),
                ),
        ),
      ],
    );
  }
}

class _PersonaData {
  final String id;
  final String nombre;
  final String materia;
  final String correo;
  final String grupos;
  final Color color;
  const _PersonaData(
      this.id, this.nombre, this.materia, this.correo, this.grupos, this.color);
}

class _MaestroCard extends StatelessWidget {
  final _PersonaData data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _MaestroCard({required this.data, required this.onEdit, required this.onDelete});

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
                        const Color(0xFF4FC3F7), onEdit),
                    const SizedBox(height: 6),
                    _IconBtn(Icons.delete_rounded,
                        const Color(0xFFE94560), onDelete),
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
class _AlumnosTab extends StatefulWidget {
  const _AlumnosTab({super.key});

  @override
  State<_AlumnosTab> createState() => _AlumnosTabState();
}

class _AlumnosTabState extends State<_AlumnosTab> {
  List<_PersonaData> _alumnos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAlumnos();
  }

  Future<void> _fetchAlumnos() async {
    try {
      final res = await http.get(Uri.parse('${dotenv.env['API_URL']}/api/students'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        setState(() {
          _alumnos = data.map((json) {
            return _PersonaData(
              json['_id'] ?? '',
              "${json['nombre']} ${json['apellido']}",
              "Cuatrimestre ${json['cuatrimestre'] ?? 1}",
              "Matrícula: ${json['matricula']}",
              "9.0", // mock calificacion
              const Color(0xFF81C784),
            );
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _eliminarAlumno(String id) async {
    try {
      await http.delete(Uri.parse('${dotenv.env['API_URL']}/api/students/$id'));
      _fetchAlumnos();
    } catch (_) {}
  }

  void _abrirCrearAlumno() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => _CrearAlumnoModal(
        onGuardar: () => _fetchAlumnos(),
      ),
    );
  }

  void _abrirEditarAlumno(_PersonaData alumno) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => _CrearAlumnoModal(
        personaActual: alumno,
        onGuardar: () => _fetchAlumnos(),
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
              const Text('Alumnos',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E))),
              const Spacer(),
              _AddButton(label: 'Agregar', onTap: _abrirCrearAlumno),
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
          child: _isLoading 
            ? const Center(child: CircularProgressIndicator()) 
            : _alumnos.isEmpty 
              ? const Center(child: Text("No hay alumnos registrados", style: TextStyle(color: Color(0xFF8A93A8))))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _alumnos.length,
                  itemBuilder: (_, i) => _AlumnoCard(
                    data: _alumnos[i],
                    onEdit: () => _abrirEditarAlumno(_alumnos[i]),
                    onDelete: () => _eliminarAlumno(_alumnos[i].id),
                  ),
                ),
        ),
      ],
    );
  }
}

class _AlumnoCard extends StatelessWidget {
  final _PersonaData data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _AlumnoCard({required this.data, required this.onEdit, required this.onDelete});

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
                        const Color(0xFF4FC3F7), onEdit),
                    const SizedBox(height: 6),
                    _IconBtn(Icons.delete_rounded,
                        const Color(0xFFE94560), onDelete),
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
  List<_AulaData> _aulas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAulas();
  }

  Future<void> _fetchAulas() async {
    try {
      final res = await http.get(Uri.parse('${dotenv.env['API_URL']}/api/groups'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        setState(() {
          _aulas = data.map((json) {
            return _AulaData(
              json['_id'] ?? '',
              json['classroom'] ?? 'Sin Aula',
              "Periodo ${json['period'] ?? 'N/A'}",
              json['capacity'] ?? 30,
              json['groupCode'] ?? 'General',
              json['isActive'] ?? true,
            );
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _eliminarAula(String id) async {
    try {
      await http.delete(Uri.parse('${dotenv.env['API_URL']}/api/groups/$id'));
      _fetchAulas();
    } catch (_) {}
  }

  void _abrirCrearAula() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => _CrearAulaModal(
        onGuardar: (aula) => _fetchAulas(),
      ),
    );
  }

  void _abrirEditarAula(_AulaData aula) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => _CrearAulaModal(
        aulaActual: aula,
        onGuardar: (updated) => _fetchAulas(),
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
          child: _isLoading 
            ? const Center(child: CircularProgressIndicator()) 
            : _aulas.isEmpty 
              ? const Center(child: Text("No hay aulas registradas", style: TextStyle(color: Color(0xFF8A93A8))))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _aulas.length,
                  itemBuilder: (_, i) => _AulaCard(
                    data: _aulas[i],
                    onEdit: () => _abrirEditarAula(_aulas[i]),
                    onDelete: () => _eliminarAula(_aulas[i].id),
                  ),
                ),
        ),
      ],
    );
  }
}

class _AulaData {
  final String id;
  final String nombre;
  final String ubicacion;
  final int capacidad;
  final String materia;
  final bool disponible;
  _AulaData(this.id, this.nombre, this.ubicacion, this.capacidad,
      this.materia, this.disponible);
}

class _AulaCard extends StatelessWidget {
  final _AulaData data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _AulaCard({required this.data, required this.onEdit, required this.onDelete});

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
                    const Color(0xFF4FC3F7), onEdit),
                const SizedBox(height: 6),
                _IconBtn(Icons.delete_rounded,
                    const Color(0xFFE94560), onDelete),
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
  List<_HorarioData> _horarios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHorarios();
  }

  Future<void> _fetchHorarios() async {
    try {
      final res = await http.get(Uri.parse('${dotenv.env['API_URL']}/api/schedules'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        setState(() {
          _horarios = data.map((json) {
            String diaStr = "Día ${json['dayOfWeek'] ?? 1}";
            return _HorarioData(
              json['_id'] ?? '',
              'Profesor', // Mock teacher
              'Materia',  // Mock subject
              json['classroom'] ?? 'Aula',
              diaStr,
              "${json['startTime']} - ${json['endTime']}",
              const Color(0xFF4FC3F7),
            );
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _eliminarHorario(String id) async {
    try {
      await http.delete(Uri.parse('${dotenv.env['API_URL']}/api/schedules/$id'));
      _fetchHorarios();
    } catch (_) {}
  }

  void _abrirCrearHorario() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => _CrearHorarioModal(
        onGuardar: () => _fetchHorarios(),
      ),
    );
  }

  void _abrirEditarHorario(_HorarioData horario) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => _CrearHorarioModal(
        horarioActual: horario,
        onGuardar: () => _fetchHorarios(),
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
          child: _isLoading 
            ? const Center(child: CircularProgressIndicator()) 
            : _horarios.isEmpty 
              ? const Center(child: Text("No hay horarios asignados", style: TextStyle(color: Color(0xFF8A93A8))))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _horarios.length,
                  itemBuilder: (_, i) => _HorarioCard(
                    data: _horarios[i],
                    onEdit: () => _abrirEditarHorario(_horarios[i]),
                    onDelete: () => _eliminarHorario(_horarios[i].id),
                  ),
                ),
        ),
      ],
    );
  }
}

class _HorarioData {
  final String id;
  final String profesor;
  final String materia;
  final String aula;
  final String dias;
  final String horario;
  final Color color;
  const _HorarioData(this.id, this.profesor, this.materia, this.aula,
      this.dias, this.horario, this.color);
}

class _HorarioCard extends StatelessWidget {
  final _HorarioData data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _HorarioCard({required this.data, required this.onEdit, required this.onDelete});

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
                    const Color(0xFF4FC3F7), onEdit),
                const SizedBox(height: 6),
                _IconBtn(Icons.delete_rounded,
                    const Color(0xFFE94560), onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MODAL: CREAR ESTUDIANTE Y MAESTRO
// ─────────────────────────────────────────────────────────────────────────────
class _CrearMaestroModal extends StatefulWidget {
  final _PersonaData? personaActual;
  final VoidCallback onGuardar;
  const _CrearMaestroModal({this.personaActual, required this.onGuardar});

  @override
  State<_CrearMaestroModal> createState() => _CrearMaestroModalState();
}

class _CrearMaestroModalState extends State<_CrearMaestroModal> {
  final _nombreCtrl = TextEditingController();
  final _apellidoCtrl = TextEditingController();
  final _numCtrl = TextEditingController();
  final _espCtrl = TextEditingController();
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    if (widget.personaActual != null) {
      final parts = widget.personaActual!.nombre.split(' ');
      _nombreCtrl.text = parts.isNotEmpty ? parts[0] : '';
      _apellidoCtrl.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      _espCtrl.text = widget.personaActual!.materia;
    }
  }

  void _guardar() async {
    if (_nombreCtrl.text.isEmpty || _apellidoCtrl.text.isEmpty) return;
    setState(() => _guardando = true);
    try {
      final isEdit = widget.personaActual != null;
      final url = isEdit
          ? '${dotenv.env['API_URL']}/api/teachers/${widget.personaActual!.id}'
          : '${dotenv.env['API_URL']}/api/teachers';
      final request = isEdit ? http.put : http.post;

      await request(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': _nombreCtrl.text,
          'apellido': _apellidoCtrl.text,
          'numeroEmpleado': _numCtrl.text.isEmpty ? 'N/A' : _numCtrl.text,
          'especialidad': _espCtrl.text.isEmpty ? 'General' : _espCtrl.text,
        }),
      );
    } catch (_) {}
    widget.onGuardar();
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
                decoration: BoxDecoration(color: const Color(0xFFE0E8F0), borderRadius: BorderRadius.circular(4)),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFF4FC3F7).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.person_add_rounded, color: Color(0xFF4FC3F7), size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.personaActual == null ? 'Nuevo Maestro' : 'Editar Maestro', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
                    Text(widget.personaActual == null ? 'Registra un nuevo docente' : 'Modifica los datos del docente', style: const TextStyle(fontSize: 12, color: Color(0xFF8A93A8))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _ModalField(controller: _nombreCtrl, label: 'Nombre', hint: 'Ej. Juan', icon: Icons.person_outline),
            const SizedBox(height: 12),
            _ModalField(controller: _apellidoCtrl, label: 'Apellidos', hint: 'Ej. Pérez', icon: Icons.person_outline),
            const SizedBox(height: 12),
            _ModalField(controller: _numCtrl, label: 'Num. Empleado', hint: 'Ej. M-1020', icon: Icons.badge_outlined),
            const SizedBox(height: 12),
            _ModalField(controller: _espCtrl, label: 'Especialidad', hint: 'Ej. Matemáticas', icon: Icons.school_outlined),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _guardando ? null : _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A2E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _guardando
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(widget.personaActual == null ? 'Guardar Maestro' : 'Actualizar Maestro', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CrearAlumnoModal extends StatefulWidget {
  final _PersonaData? personaActual;
  final VoidCallback onGuardar;
  const _CrearAlumnoModal({this.personaActual, required this.onGuardar});

  @override
  State<_CrearAlumnoModal> createState() => _CrearAlumnoModalState();
}

class _CrearAlumnoModalState extends State<_CrearAlumnoModal> {
  final _nombreCtrl = TextEditingController();
  final _apellidoCtrl = TextEditingController();
  final _matriculaCtrl = TextEditingController();
  final _carreraCtrl = TextEditingController();
  final _cuatrimestreCtrl = TextEditingController();
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    if (widget.personaActual != null) {
      final parts = widget.personaActual!.nombre.split(' ');
      _nombreCtrl.text = parts.isNotEmpty ? parts[0] : '';
      _apellidoCtrl.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      
      final cuatriStr = widget.personaActual!.materia.replaceAll(RegExp(r'[^0-9]'), '');
      _cuatrimestreCtrl.text = cuatriStr;
    }
  }

  void _guardar() async {
    if (_nombreCtrl.text.isEmpty || _apellidoCtrl.text.isEmpty) return;
    setState(() => _guardando = true);
    try {
      final isEdit = widget.personaActual != null;
      final url = isEdit
          ? '${dotenv.env['API_URL']}/api/students/${widget.personaActual!.id}'
          : '${dotenv.env['API_URL']}/api/students';
      final request = isEdit ? http.put : http.post;

      await request(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': _nombreCtrl.text,
          'apellido': _apellidoCtrl.text,
          'matricula': _matriculaCtrl.text.isEmpty ? 'N/A' : _matriculaCtrl.text,
          'carrera': _carreraCtrl.text.isEmpty ? 'General' : _carreraCtrl.text,
          'cuatrimestre': int.tryParse(_cuatrimestreCtrl.text) ?? 1,
        }),
      );
    } catch (_) {}
    widget.onGuardar();
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
                decoration: BoxDecoration(color: const Color(0xFFE0E8F0), borderRadius: BorderRadius.circular(4)),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFF81C784).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.school_rounded, color: Color(0xFF81C784), size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.personaActual == null ? 'Nuevo Alumno' : 'Editar Alumno', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
                    Text(widget.personaActual == null ? 'Registra un estudiante' : 'Modifica los datos del estudiante', style: const TextStyle(fontSize: 12, color: Color(0xFF8A93A8))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _ModalField(controller: _nombreCtrl, label: 'Nombre', hint: 'Ej. María', icon: Icons.person_outline)),
                const SizedBox(width: 12),
                Expanded(child: _ModalField(controller: _apellidoCtrl, label: 'Apellido', hint: 'Ej. López', icon: Icons.person_outline)),
              ],
            ),
            const SizedBox(height: 12),
            _ModalField(controller: _matriculaCtrl, label: 'Matrícula', hint: 'Ej. 19100123', icon: Icons.badge_outlined),
            const SizedBox(height: 12),
            _ModalField(controller: _carreraCtrl, label: 'Carrera', hint: 'Ej. Ingeniería', icon: Icons.book_outlined),
            const SizedBox(height: 12),
            _ModalField(controller: _cuatrimestreCtrl, label: 'Cuatrimestre', hint: 'Ej. 3', icon: Icons.format_list_numbered_outlined),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _guardando ? null : _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A2E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _guardando
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(widget.personaActual == null ? 'Guardar Alumno' : 'Actualizar Alumno', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              ),
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
  final _AulaData? aulaActual;
  final void Function(_AulaData) onGuardar;
  const _CrearAulaModal({this.aulaActual, required this.onGuardar});

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
  void initState() {
    super.initState();
    if (widget.aulaActual != null) {
      _nombreCtrl.text = widget.aulaActual!.nombre;
      _ubicacionCtrl.text = widget.aulaActual!.ubicacion.replaceFirst('Periodo ', '');
      _capCtrl.text = widget.aulaActual!.capacidad.toString();
      _materiaCtrl.text = widget.aulaActual!.materia;
    }
  }

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
    try {
      final isEdit = widget.aulaActual != null;
      final url = isEdit
          ? '${dotenv.env['API_URL']}/api/groups/${widget.aulaActual!.id}'
          : '${dotenv.env['API_URL']}/api/groups';
      final request = isEdit ? http.put : http.post;

      await request(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'classroom': _nombreCtrl.text,
          'capacity': int.tryParse(_capCtrl.text) ?? 30,
          'groupCode': _materiaCtrl.text.isEmpty ? 'General' : _materiaCtrl.text,
          'period': _ubicacionCtrl.text.isEmpty ? 'Actual' : _ubicacionCtrl.text,
        }),
      );
    } catch (_) {}
    widget.onGuardar(_AulaData('', '', '', 0, '', true));
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.aulaActual == null ? 'Nueva Aula' : 'Editar Aula',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A2E))),
                    Text(widget.aulaActual == null ? 'Registra un nuevo espacio' : 'Modifica los datos del aula',
                        style: const TextStyle(
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
              label: widget.aulaActual == null ? 'Crear Aula' : 'Actualizar Aula',
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
  final _HorarioData? horarioActual;
  final VoidCallback onGuardar;
  const _CrearHorarioModal({this.horarioActual, required this.onGuardar});

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
  void initState() {
    super.initState();
    if (widget.horarioActual != null) {
      _profesorCtrl.text = widget.horarioActual!.profesor;
      _materiaCtrl.text = widget.horarioActual!.materia;
      _aulaCtrl.text = widget.horarioActual!.aula;
      final horas = widget.horarioActual!.horario.split(' - ');
      if (horas.length == 2) {
        _inicioCtrl.text = horas[0];
        _finCtrl.text = horas[1];
      } else {
        _inicioCtrl.text = widget.horarioActual!.horario;
      }
      _dias.add(_semana[0]); // Simple fallback to Monday
    }
  }

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
    if (_aulaCtrl.text.isEmpty || _inicioCtrl.text.isEmpty || _finCtrl.text.isEmpty) return;
    setState(() => _guardando = true);
    try {
      final isEdit = widget.horarioActual != null;
      final url = isEdit
          ? '${dotenv.env['API_URL']}/api/schedules/${widget.horarioActual!.id}'
          : '${dotenv.env['API_URL']}/api/schedules';
      final request = isEdit ? http.put : http.post;

      int dayOfWeek = 1;
      if (_dias.isNotEmpty) {
        dayOfWeek = _semana.indexOf(_dias.first) + 1;
      }

      await request(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'classroom': _aulaCtrl.text,
          'dayOfWeek': dayOfWeek,
          'startTime': _inicioCtrl.text,
          'endTime': _finCtrl.text,
        }),
      );
    } catch (_) {}
    widget.onGuardar();
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.horarioActual == null ? 'Crear Horario' : 'Editar Horario',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A2E))),
                    const Text('Asigna horario a un profesor',
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

// ─────────────────────────────────────────────────────────────────────────────
// TAB 5 — USUARIOS
// ─────────────────────────────────────────────────────────────────────────────
class _UsuarioData {
  final String id;
  final String email;
  final String role;
  final bool isActive;
  _UsuarioData(this.id, this.email, this.role, this.isActive);
}

class _UsuariosTab extends StatefulWidget {
  const _UsuariosTab({super.key});

  @override
  State<_UsuariosTab> createState() => _UsuariosTabState();
}

class _UsuariosTabState extends State<_UsuariosTab> {
  List<_UsuarioData> _usuarios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsuarios();
  }

  Future<void> _fetchUsuarios() async {
    try {
      final res = await http.get(Uri.parse('${dotenv.env['API_URL']}/api/users'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        setState(() {
          _usuarios = data.map((json) => _UsuarioData(
                json['_id'] ?? '',
                json['email'] ?? 'Sin Email',
                json['role'] ?? 'Sin Rol',
                json['isActive'] ?? true,
              )).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _eliminarUsuario(String id) async {
    try {
      await http.delete(Uri.parse('${dotenv.env['API_URL']}/api/users/$id'));
      _fetchUsuarios();
    } catch (_) {}
  }

  void _abrirCrearUsuario() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => _CrearUsuarioModal(
        onGuardar: () => _fetchUsuarios(),
      ),
    );
  }

  void _abrirEditarUsuario(_UsuarioData usuario) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => _CrearUsuarioModal(
        usuarioActual: usuario,
        onGuardar: () => _fetchUsuarios(),
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
              const Text('Usuarios',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
              const Spacer(),
              _AddButton(label: 'Crear usuario', onTap: _abrirCrearUsuario),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
          child: Text('${_usuarios.length} cuentas registradas',
              style: const TextStyle(color: Color(0xFF8A93A8), fontSize: 12)),
        ),
        Expanded(
          child: _isLoading 
            ? const Center(child: CircularProgressIndicator()) 
            : _usuarios.isEmpty 
              ? const Center(child: Text("No hay usuarios registrados", style: TextStyle(color: Color(0xFF8A93A8))))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _usuarios.length,
                  itemBuilder: (_, i) => _UsuarioCard(
                    data: _usuarios[i],
                    onEdit: () => _abrirEditarUsuario(_usuarios[i]),
                    onDelete: () => _eliminarUsuario(_usuarios[i].id),
                  ),
                ),
        ),
      ],
    );
  }
}

class _UsuarioCard extends StatelessWidget {
  final _UsuarioData data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _UsuarioCard({required this.data, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    Color getRoleColor(String r) {
      if (r == 'admin') return const Color(0xFFE94560);
      if (r == 'teacher') return const Color(0xFF4FC3F7);
      if (r == 'student') return const Color(0xFF81C784);
      return const Color(0xFF8A93A8);
    }
    
    final color = getRoleColor(data.role);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.person_pin, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.email,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF1A1A2E))),
                  const SizedBox(height: 3),
                  _MiniChip(Icons.admin_panel_settings_outlined, data.role.toUpperCase(), color),
                ],
              ),
            ),
            Column(
              children: [
                _IconBtn(Icons.edit_rounded, const Color(0xFF4FC3F7), onEdit),
                const SizedBox(height: 6),
                _IconBtn(Icons.delete_rounded, const Color(0xFFE94560), onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CrearUsuarioModal extends StatefulWidget {
  final _UsuarioData? usuarioActual;
  final VoidCallback onGuardar;
  const _CrearUsuarioModal({this.usuarioActual, required this.onGuardar});

  @override
  State<_CrearUsuarioModal> createState() => _CrearUsuarioModalState();
}

class _CrearUsuarioModalState extends State<_CrearUsuarioModal> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    if (widget.usuarioActual != null) {
      _emailCtrl.text = widget.usuarioActual!.email;
      _roleCtrl.text = widget.usuarioActual!.role;
    }
  }

  void _guardar() async {
    if (_emailCtrl.text.isEmpty || _roleCtrl.text.isEmpty) return;
    if (widget.usuarioActual == null && _passCtrl.text.isEmpty) return; // Pass requires for new
    setState(() => _guardando = true);
    try {
      final isEdit = widget.usuarioActual != null;
      final url = isEdit
          ? '${dotenv.env['API_URL']}/api/users/${widget.usuarioActual!.id}'
          : '${dotenv.env['API_URL']}/api/users';
      final request = isEdit ? http.put : http.post;

      final body = {
        'email': _emailCtrl.text,
        'role': _roleCtrl.text.toLowerCase(),
      };
      if (_passCtrl.text.isNotEmpty) {
        body['password'] = _passCtrl.text;
      }

      await request(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
    } catch (_) {}
    widget.onGuardar();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: const Color(0xFFE0E8F0), borderRadius: BorderRadius.circular(4)))),
            Row(
              children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF1A1A2E).withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.admin_panel_settings_rounded, color: Color(0xFF1A1A2E), size: 22)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.usuarioActual == null ? 'Nuevo Usuario' : 'Editar Usuario', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
                    Text('Administrar credenciales y roles', style: const TextStyle(fontSize: 12, color: Color(0xFF8A93A8))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _ModalField(controller: _emailCtrl, label: 'Email', hint: 'ej. juan@ubmv.edu', icon: Icons.email_outlined),
            const SizedBox(height: 12),
            _ModalField(controller: _roleCtrl, label: 'Rol', hint: 'admin | teacher | student', icon: Icons.admin_panel_settings_outlined),
            const SizedBox(height: 12),
            _ModalField(controller: _passCtrl, label: widget.usuarioActual == null ? 'Contraseña' : 'Nueva Contraseña (Opcional)', hint: '********', icon: Icons.lock_outline),
            const SizedBox(height: 24),
            _BotonGuardar(label: widget.usuarioActual == null ? 'Crear Usuario' : 'Actualizar Usuario', color: const Color(0xFF1A1A2E), guardando: _guardando, onTap: _guardar),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 6 — MATERIAS
// ─────────────────────────────────────────────────────────────────────────────
class _MateriaData {
  final String id;
  final String nombre;
  final String codigo;
  final String carrera;
  final int creditos;
  final int cuatrimestre;
  final bool isActive;
  _MateriaData(this.id, this.nombre, this.codigo, this.carrera, this.creditos, this.cuatrimestre, this.isActive);
}

class _MateriasTab extends StatefulWidget {
  const _MateriasTab({super.key});
  @override
  State<_MateriasTab> createState() => _MateriasTabState();
}

class _MateriasTabState extends State<_MateriasTab> {
  List<_MateriaData> _materias = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMaterias();
  }

  Future<void> _fetchMaterias() async {
    try {
      final res = await http.get(Uri.parse('${dotenv.env['API_URL']}/api/subjects'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        setState(() {
          _materias = data.map((json) => _MateriaData(
            json['_id'] ?? '',
            json['nombre'] ?? 'Sin Nombre',
            json['codigo'] ?? 'N/A',
            json['carrera'] ?? 'Sin Carrera',
            json['creditos'] ?? 0,
            json['cuatrimestre'] ?? 1,
            json['isActive'] ?? true,
          )).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _eliminarMateria(String id) async {
    try {
      await http.delete(Uri.parse('${dotenv.env['API_URL']}/api/subjects/$id'));
      _fetchMaterias();
    } catch (_) {}
  }

  void _abrirCrearMateria() {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, barrierColor: Colors.black.withOpacity(0.45), builder: (_) => _CrearMateriaModal(onGuardar: () => _fetchMaterias()));
  }

  void _abrirEditarMateria(_MateriaData materia) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, barrierColor: Colors.black.withOpacity(0.45), builder: (_) => _CrearMateriaModal(materiaActual: materia, onGuardar: () => _fetchMaterias()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              const Text('Materias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
              const Spacer(),
              _AddButton(label: 'Crear materia', onTap: _abrirCrearMateria),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
          child: Text('${_materias.length} materias registradas', style: const TextStyle(color: Color(0xFF8A93A8), fontSize: 12)),
        ),
        Expanded(
          child: _isLoading 
            ? const Center(child: CircularProgressIndicator()) 
            : _materias.isEmpty 
              ? const Center(child: Text("No hay materias registradas", style: TextStyle(color: Color(0xFF8A93A8))))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _materias.length,
                  itemBuilder: (_, i) => _MateriaCard(
                    data: _materias[i],
                    onEdit: () => _abrirEditarMateria(_materias[i]),
                    onDelete: () => _eliminarMateria(_materias[i].id),
                  ),
                ),
        ),
      ],
    );
  }
}

class _MateriaCard extends StatelessWidget {
  final _MateriaData data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _MateriaCard({required this.data, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))]),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(color: const Color(0xFF4FC3F7).withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.menu_book_rounded, color: Color(0xFF4FC3F7), size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.nombre, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF1A1A2E))),
                  const SizedBox(height: 3),
                  Text('${data.carrera} · Cuatrimestre ${data.cuatrimestre}', style: const TextStyle(color: Color(0xFF8A93A8), fontSize: 12)),
                  const SizedBox(height: 6),
                  _MiniChip(Icons.tag, data.codigo, const Color(0xFF4FC3F7)),
                ],
              ),
            ),
            Column(
              children: [
                _IconBtn(Icons.edit_rounded, const Color(0xFF4FC3F7), onEdit),
                const SizedBox(height: 6),
                _IconBtn(Icons.delete_rounded, const Color(0xFFE94560), onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CrearMateriaModal extends StatefulWidget {
  final _MateriaData? materiaActual;
  final VoidCallback onGuardar;
  const _CrearMateriaModal({this.materiaActual, required this.onGuardar});
  @override
  State<_CrearMateriaModal> createState() => _CrearMateriaModalState();
}

class _CrearMateriaModalState extends State<_CrearMateriaModal> {
  final _nombreCtrl = TextEditingController();
  final _codigoCtrl = TextEditingController();
  final _carreraCtrl = TextEditingController();
  final _creditosCtrl = TextEditingController();
  final _cuatrimestreCtrl = TextEditingController();
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    if (widget.materiaActual != null) {
      _nombreCtrl.text = widget.materiaActual!.nombre;
      _codigoCtrl.text = widget.materiaActual!.codigo;
      _carreraCtrl.text = widget.materiaActual!.carrera;
      _creditosCtrl.text = widget.materiaActual!.creditos.toString();
      _cuatrimestreCtrl.text = widget.materiaActual!.cuatrimestre.toString();
    }
  }

  void _guardar() async {
    if (_nombreCtrl.text.isEmpty || _codigoCtrl.text.isEmpty) return;
    setState(() => _guardando = true);
    try {
      final isEdit = widget.materiaActual != null;
      final url = isEdit ? '${dotenv.env['API_URL']}/api/subjects/${widget.materiaActual!.id}' : '${dotenv.env['API_URL']}/api/subjects';
      final request = isEdit ? http.put : http.post;

      await request(Uri.parse(url), headers: {'Content-Type': 'application/json'}, body: jsonEncode({
        'nombre': _nombreCtrl.text,
        'codigo': _codigoCtrl.text,
        'carrera': _carreraCtrl.text,
        'creditos': int.tryParse(_creditosCtrl.text) ?? 0,
        'cuatrimestre': int.tryParse(_cuatrimestreCtrl.text) ?? 1,
      }));
    } catch (_) {}
    widget.onGuardar();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: const Color(0xFFE0E8F0), borderRadius: BorderRadius.circular(4)))),
            Row(
              children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF4FC3F7).withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.menu_book_rounded, color: Color(0xFF4FC3F7), size: 22)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.materiaActual == null ? 'Nueva Materia' : 'Editar Materia', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
                    Text('Administrar catálogo de materias', style: const TextStyle(fontSize: 12, color: Color(0xFF8A93A8))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _ModalField(controller: _nombreCtrl, label: 'Nombre', hint: 'ej. Matemáticas I', icon: Icons.text_fields),
            const SizedBox(height: 12),
            _ModalField(controller: _codigoCtrl, label: 'Código', hint: 'ej. MAT-101', icon: Icons.qr_code),
            const SizedBox(height: 12),
            _ModalField(controller: _carreraCtrl, label: 'Carrera', hint: 'ej. Ingeniería', icon: Icons.school),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _ModalField(controller: _cuatrimestreCtrl, label: 'Cuatrimestre', hint: '1', icon: Icons.calendar_today, tipo: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: _ModalField(controller: _creditosCtrl, label: 'Créditos', hint: '5', icon: Icons.star_border, tipo: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 24),
            _BotonGuardar(label: widget.materiaActual == null ? 'Crear Materia' : 'Actualizar Materia', color: const Color(0xFF4FC3F7), guardando: _guardando, onTap: _guardar),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 7 — INSCRIPCIONES
// ─────────────────────────────────────────────────────────────────────────────
class _InscripcionData {
  final String id;
  final String studentId;
  final String groupId;
  final String studentName;
  final String groupName;
  final String status;
  _InscripcionData(this.id, this.studentId, this.groupId, this.studentName, this.groupName, this.status);
}

class _InscripcionesTab extends StatefulWidget {
  const _InscripcionesTab({super.key});
  @override
  State<_InscripcionesTab> createState() => _InscripcionesTabState();
}

class _InscripcionesTabState extends State<_InscripcionesTab> {
  List<_InscripcionData> _inscripciones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInscripciones();
  }

  Future<void> _fetchInscripciones() async {
    try {
      final res = await http.get(Uri.parse('${dotenv.env['API_URL']}/api/enrollments'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        setState(() {
          _inscripciones = data.map((json) => _InscripcionData(
            json['_id'] ?? '',
            json['studentId']?['_id'] ?? '',
            json['groupId']?['_id'] ?? '',
            json['studentId']?['nombre'] ?? 'Alumno Desconocido',
            json['groupId']?['classroom'] ?? 'Aula Desconocida',
            json['status'] ?? 'active',
          )).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _eliminar(String id) async {
    try {
      await http.delete(Uri.parse('${dotenv.env['API_URL']}/api/enrollments/$id'));
      _fetchInscripciones();
    } catch (_) {}
  }

  void _abrirCrear() {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, barrierColor: Colors.black.withOpacity(0.45), builder: (_) => _CrearInscripcionModal(onGuardar: () => _fetchInscripciones()));
  }

  void _abrirEditar(_InscripcionData insc) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, barrierColor: Colors.black.withOpacity(0.45), builder: (_) => _CrearInscripcionModal(inscActual: insc, onGuardar: () => _fetchInscripciones()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              const Text('Inscripciones', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
              const Spacer(),
              _AddButton(label: 'Inscribir', onTap: _abrirCrear),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
          child: Text('${_inscripciones.length} registros', style: const TextStyle(color: Color(0xFF8A93A8), fontSize: 12)),
        ),
        Expanded(
          child: _isLoading 
            ? const Center(child: CircularProgressIndicator()) 
            : _inscripciones.isEmpty 
              ? const Center(child: Text("No hay inscripciones registradas", style: TextStyle(color: Color(0xFF8A93A8))))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _inscripciones.length,
                  itemBuilder: (_, i) => _InscripcionCard(
                    data: _inscripciones[i],
                    onEdit: () => _abrirEditar(_inscripciones[i]),
                    onDelete: () => _eliminar(_inscripciones[i].id),
                  ),
                ),
        ),
      ],
    );
  }
}

class _InscripcionCard extends StatelessWidget {
  final _InscripcionData data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _InscripcionCard({required this.data, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))]),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(color: const Color(0xFF81C784).withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.assignment_ind_rounded, color: Color(0xFF81C784), size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.studentName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF1A1A2E))),
                  const SizedBox(height: 3),
                  Text('Aula: ${data.groupName}', style: const TextStyle(color: Color(0xFF8A93A8), fontSize: 12)),
                  const SizedBox(height: 6),
                  _MiniChip(Icons.check_circle_outline, data.status.toUpperCase(), const Color(0xFF81C784)),
                ],
              ),
            ),
            Column(
              children: [
                _IconBtn(Icons.edit_rounded, const Color(0xFF4FC3F7), onEdit),
                const SizedBox(height: 6),
                _IconBtn(Icons.delete_rounded, const Color(0xFFE94560), onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CrearInscripcionModal extends StatefulWidget {
  final _InscripcionData? inscActual;
  final VoidCallback onGuardar;
  const _CrearInscripcionModal({this.inscActual, required this.onGuardar});
  @override
  State<_CrearInscripcionModal> createState() => _CrearInscripcionModalState();
}

class _CrearInscripcionModalState extends State<_CrearInscripcionModal> {
  String? _selectedStudent;
  String? _selectedGroup;
  List<dynamic> _students = [];
  List<dynamic> _groups = [];
  bool _isLoadingData = true;
  bool _guardando = false;

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
        setState(() {
          _students = jsonDecode(resS.body);
          _groups = jsonDecode(resG.body);
          _isLoadingData = false;
          if (widget.inscActual != null) {
            final stExists = _students.any((s) => s['_id'] == widget.inscActual!.studentId);
            final grExists = _groups.any((g) => g['_id'] == widget.inscActual!.groupId);
            if (stExists) _selectedStudent = widget.inscActual!.studentId;
            if (grExists) _selectedGroup = widget.inscActual!.groupId;
          }
        });
      }
    } catch (_) {}
  }

  void _guardar() async {
    if (_selectedStudent == null || _selectedGroup == null) return;
    setState(() => _guardando = true);
    try {
      final isEdit = widget.inscActual != null;
      final url = isEdit ? '${dotenv.env['API_URL']}/api/enrollments/${widget.inscActual!.id}' : '${dotenv.env['API_URL']}/api/enrollments';
      final request = isEdit ? http.put : http.post;

      await request(Uri.parse(url), headers: {'Content-Type': 'application/json'}, body: jsonEncode({
        'studentId': _selectedStudent,
        'groupId': _selectedGroup,
        'status': 'active',
      }));
    } catch (_) {}
    widget.onGuardar();
    if (mounted) Navigator.of(context).pop();
  }

  Widget _buildDropdown(String hint, List<dynamic> items, String? value, ValueChanged<String?> onChanged, String displayKey) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(16)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(color: Color(0xFF8A93A8))),
          value: value,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((item) {
            return DropdownMenuItem<String>(
              value: item['_id'],
              child: Text(item[displayKey] ?? 'Sin Nombre', style: const TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.w600)),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: const Color(0xFFE0E8F0), borderRadius: BorderRadius.circular(4)))),
            Row(
              children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF81C784).withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.assignment_ind_rounded, color: Color(0xFF81C784), size: 22)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.inscActual == null ? 'Nueva Inscripción' : 'Editar Inscripción', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
                    Text('Asignar alumno a grupo', style: const TextStyle(fontSize: 12, color: Color(0xFF8A93A8))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_isLoadingData)
              const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
            else ...[
              const Text('Alumno', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
              const SizedBox(height: 8),
              _buildDropdown('Seleccionar alumno', _students, _selectedStudent, (val) => setState(() => _selectedStudent = val), 'nombre'),
              const SizedBox(height: 16),
              const Text('Aula / Grupo', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
              const SizedBox(height: 8),
              _buildDropdown('Seleccionar aula', _groups, _selectedGroup, (val) => setState(() => _selectedGroup = val), 'classroom'),
              const SizedBox(height: 24),
              _BotonGuardar(label: widget.inscActual == null ? 'Inscribir' : 'Actualizar', color: const Color(0xFF81C784), guardando: _guardando, onTap: _guardar),
            ]
          ],
        ),
      ),
    );
  }
}