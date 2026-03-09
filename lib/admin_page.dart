import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel Administrador"),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [

          ElevatedButton(
            onPressed: () {},
            child: const Text("Gestionar usuarios"),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {},
            child: const Text("Crear clases"),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {},
            child: const Text("Asignar aulas"),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {},
            child: const Text("Ver asistencia"),
          ),

        ],
      ),
    );
  }
}