import 'package:flutter/material.dart';
import 'package:flutter_application_1/alumno_page.dart';
import 'package:flutter_application_1/teacher_page.dart';
import 'dart:convert';
import 'package:flutter_application_1/http_logger.dart';
import 'inicio.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
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
  bool _isLoading = false;

  Future<void> login() async {
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingresa tu correo y contraseña"), backgroundColor: Color(0xFFE53935)),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final url = Uri.parse("${dotenv.env['API_URL']}/api/login");
      print("\n[FRONTEND - MAIN] Iniciando petición POST de Login a $url");
      print("[FRONTEND - MAIN] Enviando credenciales: ${emailController.text.trim()}");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      print("[FRONTEND - MAIN] Respuesta recibida. Status Code: ${response.statusCode}");
      print("[FRONTEND - MAIN] Payload del servidor: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String role = data["role"];

        if (role == "admin" || role == "coordinator") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InicioPage(role: role)));
        } else if (role == "teacher") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TeacherPage(role: role)));
        } else if (role == "student") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AlumnoPage(role: role)));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Correo o contraseña incorrectos"), backgroundColor: Color(0xFFE53935)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error de conexión al servidor"), backgroundColor: Color(0xFFE53935)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
             colors: [Color(0xFF1A1A2E), Color(0xFF0F3460)],
             begin: Alignment.topCenter,
             end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE94560).withOpacity(0.18),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(Icons.school_rounded, size: 48, color: Color(0xFFE94560)),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "SWAG APP",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Ingresa a tu portal universitario",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 48),

                  // Form Container
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Correo Electrónico", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF8A93A8))),
                        const SizedBox(height: 8),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0D1F1A)),
                          decoration: InputDecoration(
                            hintText: "ejemplo@swag.edu.mx",
                            hintStyle: const TextStyle(color: Color(0xFFB0C4BB), fontSize: 13, fontWeight: FontWeight.w500),
                            prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF8A93A8), size: 20),
                            filled: true,
                            fillColor: const Color(0xFFF6F8F7),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE94560), width: 1.5)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text("Contraseña", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF8A93A8))),
                        const SizedBox(height: 8),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0D1F1A)),
                          decoration: InputDecoration(
                            hintText: "••••••••",
                            hintStyle: const TextStyle(color: Color(0xFFB0C4BB), fontSize: 13, fontWeight: FontWeight.w500),
                            prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF8A93A8), size: 20),
                            filled: true,
                            fillColor: const Color(0xFFF6F8F7),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE94560), width: 1.5)),
                          ),
                        ),
                        const SizedBox(height: 32),
                        GestureDetector(
                          onTap: _isLoading ? null : login,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: _isLoading ? const Color(0xFFE94560).withOpacity(0.5) : const Color(0xFFE94560),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(color: const Color(0xFFE94560).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                              ],
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text('Entrar al Sistema', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                            ),
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
    );
  }
}
