import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final VoidCallback onInicio;
  final VoidCallback onMenu;
  final VoidCallback onReservas;
  final VoidCallback onDomicilio;
  final VoidCallback onCarrito;
  final VoidCallback onPerfil;
  final VoidCallback onLogin;
  final String? nombreUsuario;
  final int cantidadCarrito;
  final VoidCallback? onCerrarSesion;

  const Navbar({
    super.key,
    required this.onInicio,
    required this.onMenu,
    required this.onReservas,
    required this.onDomicilio,
    required this.onCarrito,
    required this.onPerfil,
    required this.onLogin,
    this.nombreUsuario,
    this.cantidadCarrito = 0,
    this.onCerrarSesion,
  });

  static const azul = Color(0xFF0A3D62);
  static const amarillo = Color(0xFFF1C40F);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 820;

    return Material(
      color: azul.withOpacity(0.96),
      elevation: 5,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: isMobile ? 72 : 88,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 14 : 34),
          child: Row(
            children: [
              InkWell(
                onTap: onInicio,
                borderRadius: BorderRadius.circular(40),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: isMobile ? 52 : 62,
                        height: isMobile ? 52 : 62,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.set_meal,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'La Pesquera',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 18 : 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (isMobile)
                _MobileMenu(
                  onInicio: onInicio,
                  onMenu: onMenu,
                  onReservas: onReservas,
                  onDomicilio: onDomicilio,
                  onPerfil: onPerfil,
                  onLogin: onLogin,
                  onCerrarSesion: onCerrarSesion,
                  hasUser: nombreUsuario != null && nombreUsuario!.isNotEmpty,
                )
              else ...[
                _NavLink(text: 'Inicio', onTap: onInicio),
                _NavLink(text: 'Menu', onTap: onMenu),
                _NavLink(text: 'Reservas', onTap: onReservas),
                _NavLink(text: 'Domicilio', onTap: onDomicilio),
                const SizedBox(width: 12),
                if (nombreUsuario != null && nombreUsuario!.isNotEmpty) ...[
                  TextButton.icon(
                    onPressed: onPerfil,
                    icon: const Icon(Icons.person_outline, size: 18),
                    label: Text(nombreUsuario!),
                    style: TextButton.styleFrom(
                      foregroundColor: amarillo,
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: onCerrarSesion,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Cerrar sesion'),
                  ),
                ] else
                  FilledButton.icon(
                    onPressed: onLogin,
                    icon: const Icon(Icons.person_outline, size: 18),
                    label: const Text('Login'),
                    style: FilledButton.styleFrom(
                      backgroundColor: amarillo,
                      foregroundColor: const Color(0xFF2C3E50),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
              ],
              _CartButton(count: cantidadCarrito, onPressed: onCarrito),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _NavLink({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(foregroundColor: Colors.white),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  final VoidCallback onInicio;
  final VoidCallback onMenu;
  final VoidCallback onReservas;
  final VoidCallback onDomicilio;
  final VoidCallback onPerfil;
  final VoidCallback onLogin;
  final VoidCallback? onCerrarSesion;
  final bool hasUser;

  const _MobileMenu({
    required this.onInicio,
    required this.onMenu,
    required this.onReservas,
    required this.onDomicilio,
    required this.onPerfil,
    required this.onLogin,
    required this.onCerrarSesion,
    required this.hasUser,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Menu',
      icon: const Icon(Icons.menu, color: Colors.white),
      onSelected: (value) {
        switch (value) {
          case 'inicio':
            onInicio();
            break;
          case 'menu':
            onMenu();
            break;
          case 'reservas':
            onReservas();
            break;
          case 'domicilio':
            onDomicilio();
            break;
          case 'perfil':
            onPerfil();
            break;
          case 'login':
            onLogin();
            break;
          case 'logout':
            onCerrarSesion?.call();
            break;
        }
      },
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'inicio', child: Text('Inicio')),
        const PopupMenuItem(value: 'menu', child: Text('Menu')),
        const PopupMenuItem(value: 'reservas', child: Text('Reservas')),
        const PopupMenuItem(value: 'domicilio', child: Text('Domicilio')),
        if (hasUser) const PopupMenuItem(value: 'perfil', child: Text('Mi cuenta')),
        PopupMenuItem(
          value: hasUser ? 'logout' : 'login',
          child: Text(hasUser ? 'Cerrar sesion' : 'Login'),
        ),
      ],
    );
  }
}

class _CartButton extends StatelessWidget {
  final int count;
  final VoidCallback onPressed;

  const _CartButton({required this.count, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        FilledButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.shopping_cart_outlined, size: 19),
          label: const Text('Carrito'),
          style: FilledButton.styleFrom(
            backgroundColor: Navbar.amarillo,
            foregroundColor: const Color(0xFF2C3E50),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
        ),
        Positioned(
          top: -8,
          right: -5,
          child: Container(
            constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
