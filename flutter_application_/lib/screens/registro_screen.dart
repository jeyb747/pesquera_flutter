import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/pesquera_scaffold.dart';
import '../widgets/pesquera_style.dart';
import 'login_screen.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final formKey = GlobalKey<FormState>();
  final nombre = TextEditingController();
  final numeroDocumento = TextEditingController();
  final correo = TextEditingController();
  final telefono = TextEditingController();
  final password = TextEditingController();
  String? tipoDocumento;
  bool ocultar = true;
  bool cargando = false;

  Future<void> crearCuenta() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => cargando = true);
    final respuesta = await AuthService.registro(
      nombre: nombre.text.trim(),
      tipoDocumento: tipoDocumento!,
      numeroDocumento: numeroDocumento.text.trim(),
      correo: correo.text.trim(),
      telefono: telefono.text.trim(),
      password: password.text,
    );
    setState(() => cargando = false);

    if (!mounted) return;

    await mostrarNotificacion(
      context,
      titulo: respuesta['success'] == true
          ? 'Cuenta creada'
          : 'No se pudo crear la cuenta',
      mensaje: respuesta['success'] == true
          ? 'Tu cuenta fue creada correctamente.'
          : respuesta['mensaje'].toString(),
      exito: respuesta['success'] == true,
    );

    if (respuesta['success'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PesqueraScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 84),
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 780),
                child: Card(
                  elevation: 14,
                  shadowColor: Colors.black.withValues(alpha: 0.18),
                  color: Colors.white.withValues(alpha: 0.96),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 56,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: PesqueraStyle.navy,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 62,
                              height: 44,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 22),
                          const Text(
                            'Crear Cuenta',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: PesqueraStyle.ink,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Registrate para poder reservar, pedir domicilio y usar el carrito de forma completa.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 10,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _input(
                            controller: nombre,
                            label: 'Nombre completo',
                            hint: 'Ingresa tu nombre completo',
                            icon: Icons.person_outline,
                            validator: _required,
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            initialValue: tipoDocumento,
                            decoration: _decoration(
                              'Tipo de documento',
                              'Selecciona tu tipo de documento',
                              Icons.badge_outlined,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: '1',
                                child: Text('Cedula de Ciudadania (C.C.)'),
                              ),
                              DropdownMenuItem(
                                value: '2',
                                child: Text('Cedula de Extranjeria (C.E.)'),
                              ),
                              DropdownMenuItem(
                                value: '3',
                                child: Text('Pasaporte'),
                              ),
                              DropdownMenuItem(value: '4', child: Text('NIT')),
                            ],
                            onChanged: (value) =>
                                setState(() => tipoDocumento = value),
                            validator: (value) => value == null
                                ? 'Selecciona tu tipo de documento'
                                : null,
                          ),
                          const SizedBox(height: 10),
                          _input(
                            controller: numeroDocumento,
                            label: 'Numero de documento',
                            hint: 'Ingresa tu numero de documento',
                            icon: Icons.numbers,
                            validator: (value) {
                              if ((value ?? '').trim().isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                              if (!RegExp(
                                r'^[a-zA-Z0-9]{5,15}$',
                              ).hasMatch(value!.trim())) {
                                return 'Usa entre 5 y 15 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          _input(
                            controller: correo,
                            label: 'Correo electronico',
                            hint: 'ejemplo@correo.com',
                            icon: Icons.mail_outline,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if ((value ?? '').trim().isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                              if (!value!.contains('@')) {
                                return 'Ingresa un correo valido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          _input(
                            controller: telefono,
                            label: 'Telefono',
                            hint: '3001234567',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if ((value ?? '').trim().isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                              if (!RegExp(
                                r'^[0-9]{7,10}$',
                              ).hasMatch(value!.trim())) {
                                return 'Usa entre 7 y 10 numeros';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: password,
                            obscureText: ocultar,
                            validator: _required,
                            decoration:
                                _decoration(
                                  'Contrasena',
                                  'Crea una contrasena segura',
                                  Icons.lock_outline,
                                ).copyWith(
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
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: cargando ? null : crearCuenta,
                              icon: cargando
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              label: const Text(
                                'Crear cuenta',
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              '¿Ya tienes cuenta? Inicia sesión',
                              style: TextStyle(
                                color: Color(0xFF0B3C5D),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 34),
          ],
        ),
      ),
    );
  }

  String? _required(String? value) {
    return (value ?? '').trim().isEmpty ? 'Este campo es obligatorio' : null;
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: _decoration(label, hint, icon),
    );
  }

  InputDecoration _decoration(String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: null,
      filled: true,
      fillColor: const Color(0xFFFDFDFD),
      isDense: true,
      labelStyle: const TextStyle(fontSize: 10, color: PesqueraStyle.ink),
      hintStyle: const TextStyle(fontSize: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFFF1C40F), width: 2),
      ),
    );
  }
}
