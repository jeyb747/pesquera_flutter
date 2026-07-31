import 'package:flutter/material.dart';
import '../models/carrito.dart';
import '../services/session_service.dart';
import '../screens/carrito_screen.dart';
import '../screens/domicilio_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/perfil_screen.dart';
import '../screens/reservas_screen.dart';
import 'custom_navbar.dart';

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
          onReservas: () => _go(context, const ReservasScreen()),
          onDomicilio: () => _go(context, const DomicilioScreen()),
          onCarrito: () => _go(context, const CarritoScreen()),
          onPerfil: () => _go(context, const PerfilScreen()),
          onLogin: () => _go(context, const LoginScreen()),
          onCerrarSesion: () {
            SessionService.cerrar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sesion cerrada')),
            );
            _go(context, const HomeScreen());
          },
        ),
      ),
      body: child,
    );
  }

  void _go(BuildContext context, Widget screen) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}

class PesqueraFooter extends StatelessWidget {
  const PesqueraFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      color: const Color(0xFF2C3E50),
      child: const Text(
        '2026 La Pesquera - Todos los derechos reservados',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white70, fontSize: 13),
      ),
    );
  }
}
