import 'package:flutter/material.dart';

class AlumnoPage extends StatelessWidget {

  final String role;

  const AlumnoPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel Alumno"),
      ),
      body: Center(
        child: Text(
          "Bienvenido $role",
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );

  }
}