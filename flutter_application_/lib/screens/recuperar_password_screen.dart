import 'package:flutter/material.dart';
import '../widgets/pesquera_scaffold.dart';
import '../widgets/pesquera_style.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class RecuperarPasswordScreen extends StatefulWidget {
  const RecuperarPasswordScreen({super.key});

  @override
  State<RecuperarPasswordScreen> createState() =>
      _RecuperarPasswordScreenState();
}

class _RecuperarPasswordScreenState extends State<RecuperarPasswordScreen> {
  final correo = TextEditingController();
  bool enviando = false;

  @override
  void dispose() {
    correo.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!correo.text.contains('@')) {
      mostrarNotificacion(
        context,
        titulo: 'Correo inválido',
        mensaje: 'Escribe un correo electrónico válido.',
        exito: false,
      );
      return;
    }
    setState(() => enviando = true);
    final respuesta = await AuthService.solicitarRecuperacion(correo.text.trim());
    if (!mounted) return;
    setState(() => enviando = false);
    await mostrarNotificacion(
      context,
      titulo: respuesta['success'] == true ? 'Enlace solicitado' : 'No se pudo enviar',
      mensaje: respuesta['mensaje'].toString(),
      exito: respuesta['success'] == true,
    );
  }

  @override
  Widget build(BuildContext context) => PesqueraScaffold(
    child: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 330),
          child: Card(
            elevation: 12,
            shadowColor: Colors.black.withValues(alpha: .15),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(22, 26, 22, 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [PesqueraStyle.deepNavy, PesqueraStyle.navy],
                    ),
                  ),
                  child: const Column(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0x3354B6E9),
                        child: Icon(Icons.lock, color: Colors.white),
                      ),
                      SizedBox(height: 14),
                      Text(
                        'RECUPERAR CONTRASEÑA',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'TE ENVIAREMOS UN ENLACE SEGURO PARA CREAR UNA NUEVA CONTRASEÑA.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CORREO ELECTRÓNICO',
                        style: TextStyle(
                          color: PesqueraStyle.ink,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: correo,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'ejemplo@correo.com',
                          hintStyle: const TextStyle(fontSize: 10),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: enviando ? null : _enviar,
                          icon: enviando ? const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send, size: 15),
                          label: Text(enviando ? 'ENVIANDO...' : 'ENVIAR ENLACE'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton.icon(
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          ),
                          icon: const Icon(Icons.arrow_back, size: 15),
                          label: const Text(
                            'VOLVER AL INICIO DE SESIÓN',
                            style: TextStyle(fontSize: 9),
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
