import 'package:flutter/material.dart';
import 'main.dart';

class InicioPage extends StatelessWidget {

  final String role;

  const InicioPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF6C63FF),

            actions: [

              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                tooltip: "Cerrar sesión",
                onPressed: () {

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                    (route) => false,
                  );

                },
              )

            ],

            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Panel $role',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6C63FF), Color(0xFF48CAE4)],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.home_rounded,
                    size: 80,
                    color: Colors.white24,
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                _WelcomeCard(role: role),

                const SizedBox(height: 20),

                _QuickAccessGrid(),

                const SizedBox(height: 20),

                Text(
                  'Actividad Reciente',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3142),
                  ),
                ),

                const SizedBox(height: 12),

                _RecentActivityList(),

              ]),
            ),
          ),
        ],
      ),
    );
  }
}



class _WelcomeCard extends StatelessWidget {

  final String role;

  const _WelcomeCard({required this.role});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF48CAE4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Row(
        children: [

          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person_rounded, color: Colors.white, size: 32),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  'Bienvenido $role',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Qué bueno verte por aquí',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const Icon(Icons.waving_hand_rounded, color: Colors.white, size: 28),

        ],
      ),
    );
  }
}



class _QuickAccessGrid extends StatelessWidget {

  final List<_QuickItem> items = const [

    _QuickItem(icon: Icons.bar_chart_rounded, label: 'Estadísticas', color: Color(0xFF6C63FF)),
    _QuickItem(icon: Icons.notifications_rounded, label: 'Alertas', color: Color(0xFFFF6584)),
    _QuickItem(icon: Icons.settings_rounded, label: 'Ajustes', color: Color(0xFF43AA8B)),
    _QuickItem(icon: Icons.help_rounded, label: 'Ayuda', color: Color(0xFFF8961E)),

  ];

  @override
  Widget build(BuildContext context) {

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: items.map((item) => _QuickAccessTile(item: item)).toList(),
    );
  }
}



class _QuickItem {

  final IconData icon;
  final String label;
  final Color color;

  const _QuickItem({
    required this.icon,
    required this.label,
    required this.color,
  });
}



class _QuickAccessTile extends StatelessWidget {

  final _QuickItem item;

  const _QuickAccessTile({required this.item});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(item.icon, color: item.color, size: 26),
          ),

          const SizedBox(height: 6),

          Text(
            item.label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}



class _RecentActivityList extends StatelessWidget {

  final List<_ActivityItem> activities = const [

    _ActivityItem(icon: Icons.check_circle_rounded, title: 'Tarea completada', subtitle: 'Hace 5 minutos', color: Color(0xFF43AA8B)),
    _ActivityItem(icon: Icons.upload_rounded, title: 'Archivo subido', subtitle: 'Hace 1 hora', color: Color(0xFF6C63FF)),
    _ActivityItem(icon: Icons.message_rounded, title: 'Nuevo mensaje', subtitle: 'Hace 3 horas', color: Color(0xFFF8961E)),

  ];

  @override
  Widget build(BuildContext context) {

    return Column(
      children: activities.map((a) => _ActivityTile(item: a)).toList(),
    );
  }
}



class _ActivityItem {

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}



class _ActivityTile extends StatelessWidget {

  final _ActivityItem item;

  const _ActivityTile({required this.item});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.color, size: 22),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  item.subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),

        ],
      ),
    );
  }
}