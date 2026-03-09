import 'package:flutter/material.dart';
import 'package:flutter_application_1/alumno_page.dart';
import 'package:flutter_application_1/teacher_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'inicio.dart';

void main() {
  runApp(const EscuelaApp());
}

class EscuelaApp extends StatelessWidget {
  const EscuelaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    final url = Uri.parse("http://10.0.2.2:3000/api/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      }),
    );

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String role = data["role"];

      if (role == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InicioPage(role: role)),
        );
      } else if (role == "teacher") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
               TeacherPage(role: role),
          ),
        );
      } else if (role == "student") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AlumnoPage(role: role)),
        );
      } else if (role == "coordinator") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InicioPage(role: role)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Correo o contraseña incorrectos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.school, size: 100, color: Colors.indigo),

              const SizedBox(height: 20),

              const Text(
                "SWAG",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 40),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Correo",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: login,
                  child: const Text(
                    "Iniciar sesión",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
