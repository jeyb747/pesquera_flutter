import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/pesquera_scaffold.dart';
import '../widgets/pesquera_style.dart';
import 'menu_screen.dart';
import 'registro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final correoController = TextEditingController();
  final passwordController = TextEditingController();
  bool cargando = false;
  bool ocultar = true;

  Future<void> iniciarSesion() async {
    setState(() => cargando = true);
    final respuesta = await AuthService.login(
      correoController.text,
      passwordController.text,
    );
    setState(() => cargando = false);

    if (!mounted) return;

    if (respuesta['success'] == true) {
      await mostrarNotificacion(context, titulo: 'Sesión iniciada', mensaje: 'Bienvenido a La Pesquera.');
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MenuScreen()),
      );
    } else {
      mostrarNotificacion(context, titulo: 'No se pudo iniciar sesión', mensaje: respuesta['mensaje'].toString(), exito: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;

    return PesqueraScaffold(
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                if (wide)
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset('assets/images/restaurante.png',
                            fit: BoxFit.cover),
                        Container(color: Colors.black.withValues(alpha: 0.55)),
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(44),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Disfruta lo mejor del mar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: 14),
                                Text(
                                  'Pedidos rapidos, frescos y sin complicaciones.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Container(
                    color: const Color(0xFFF8F9FA),
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 430),
                        child: Card(
                          elevation: 14,
                          shadowColor: Colors.black.withValues(alpha: 0.18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/logo.png',
                                  width: 118,
                                  height: 118,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 18),
                                const Text(
                                  'Bienvenido',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Inicia sesion en La Pesquera',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(height: 26),
                                TextField(
                                  controller: correoController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    labelText: 'Correo electronico',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                TextField(
                                  controller: passwordController,
                                  obscureText: ocultar,
                                  decoration: InputDecoration(
                                    labelText: 'Contrasena',
                                    border: const OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      onPressed: () =>
                                          setState(() => ocultar = !ocultar),
                                      icon: Icon(
                                        ocultar
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: cargando ? null : iniciarSesion,
                                    child: cargando
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text(
                                            'Ingresar',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const RegistroScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'No tienes cuenta? Crea una aqui',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
