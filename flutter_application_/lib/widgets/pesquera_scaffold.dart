import 'package:flutter/material.dart';
import '../models/carrito.dart';
import '../services/session_service.dart';
import '../screens/carrito_screen.dart';
import '../screens/domicilio_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/reservas_screen.dart';
import '../screens/contacto_screen.dart';
import '../screens/perfil_screen.dart';
import 'custom_navbar.dart';
import 'pesquera_style.dart';

class PesqueraScaffold extends StatelessWidget {
  final Widget child;

  const PesqueraScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.sizeOf(context).width < 820 ? 72 : 88,
        ),
        child: Navbar(
          cantidadCarrito: Carrito.items.length,
          nombreUsuario: SessionService.nombre,
          onInicio: () => _go(context, const HomeScreen()),
          onMenu: () => _go(context, const MenuScreen()),
          onReservas: () async {
            if (await pedirInicioSesion(context)) _go(context, const ReservasScreen());
          },
          onDomicilio: () async {
            if (await pedirInicioSesion(context)) _go(context, const DomicilioScreen());
          },
          onContacto: () => _go(context, const ContactoScreen()),
          onPerfil: () => _go(context, const PerfilScreen()),
          onCarrito: () => _go(context, const CarritoScreen()),
          onLogin: () => _go(context, const LoginScreen()),
          onCerrarSesion: () {
            SessionService.cerrar();
            mostrarNotificacion(context, titulo: 'Sesión cerrada', mensaje: 'Tu sesión se cerró correctamente.').then((_) {
              if (context.mounted) _go(context, const HomeScreen());
            });
          },
        ),
      ),
      body: WaveBackground(child: child),
      bottomNavigationBar: const PesqueraFooter(),
    );
  }

  void _go(BuildContext context, Widget screen) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}

Future<bool> pedirInicioSesion(BuildContext context) async {
  if (SessionService.estaLogueado) return true;
  await mostrarNotificacion(
    context,
    titulo: 'Inicia sesión para continuar',
    mensaje: 'Debes iniciar sesión para realizar reservas o pedidos.',
    exito: false,
  );
  if (context.mounted) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
  return false;
}

class PesqueraFooter extends StatelessWidget {
  const PesqueraFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      color: PesqueraStyle.deepNavy,
      child: const Text(
        '© 2026 La Pesquera - Todos los derechos reservados',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white70, fontSize: 13),
      ),
    );
  }
}
