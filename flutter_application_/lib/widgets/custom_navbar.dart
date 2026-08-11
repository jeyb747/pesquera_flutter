import 'package:flutter/material.dart';
import 'pesquera_style.dart';

class Navbar extends StatelessWidget {
  final VoidCallback onInicio;
  final VoidCallback onMenu;
  final VoidCallback onReservas;
  final VoidCallback onDomicilio;
  final VoidCallback onContacto;
  final VoidCallback onPerfil;
  final VoidCallback onCarrito;
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
    required this.onContacto,
    required this.onPerfil,
    required this.onCarrito,
    required this.onLogin,
    this.nombreUsuario,
    this.cantidadCarrito = 0,
    this.onCerrarSesion,
  });

  static const azul = PesqueraStyle.navy;
  static const amarillo = PesqueraStyle.yellow;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 1340;

    return Material(
      color: azul,
      elevation: 5,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: isMobile ? 68 : 72,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 14 : 22),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1320),
              child: Row(
                children: [
                  InkWell(
                    onTap: onInicio,
                    borderRadius: BorderRadius.circular(40),
                    child: Row(
                      children: [
                        Image.asset(
                          isMobile
                              ? 'assets/images/logo.png'
                              : 'assets/images/logo_horizontal.png',
                          width: isMobile ? 50 : 126,
                          height: isMobile ? 50 : 46,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.set_meal,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'La Pesquera',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 16 : 17,
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
                      onContacto: onContacto,
                      onPerfil: onPerfil,
                      onLogin: onLogin,
                      onCerrarSesion: onCerrarSesion,
                      hasUser:
                          nombreUsuario != null && nombreUsuario!.isNotEmpty,
                    )
                  else ...[
                    _NavLink(text: 'INICIO', onTap: onInicio),
                    _NavLink(text: 'MENÚ', onTap: onMenu),
                    _NavLink(text: 'Reservas', onTap: onReservas),
                    _NavLink(text: 'Domicilio', onTap: onDomicilio),
                    _NavLink(text: 'Contacto', onTap: onContacto),
                    if (nombreUsuario != null && nombreUsuario!.isNotEmpty)
                      _NavLink(text: 'Mis reservas', onTap: onPerfil),
                    const SizedBox(width: 12),
                    if (nombreUsuario != null && nombreUsuario!.isNotEmpty) ...[
                      Text(
                        nombreUsuario!,
                        style: const TextStyle(
                          color: amarillo,
                          fontWeight: FontWeight.w700,
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
                        child: const Text('CERRAR SESIÓN'),
                      ),
                    ] else
                      FilledButton.icon(
                        onPressed: onLogin,
                        icon: const Icon(Icons.person_outline, size: 18),
                        label: const Text('INGRESAR'),
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
                  _CartButton(
                    count: cantidadCarrito,
                    onPressed: onCarrito,
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

class _NavLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _NavLink({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(foregroundColor: Colors.white70),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
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
  final VoidCallback onContacto;
  final VoidCallback onPerfil;
  final VoidCallback onLogin;
  final VoidCallback? onCerrarSesion;
  final bool hasUser;

  const _MobileMenu({
    required this.onInicio,
    required this.onMenu,
    required this.onReservas,
    required this.onDomicilio,
    required this.onContacto,
    required this.onPerfil,
    required this.onLogin,
    required this.onCerrarSesion,
    required this.hasUser,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Menú',
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
          case 'contacto':
            onContacto();
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
        const PopupMenuItem(value: 'menu', child: Text('Menú')),
        const PopupMenuItem(value: 'reservas', child: Text('Reservas')),
        const PopupMenuItem(value: 'domicilio', child: Text('Domicilio')),
        const PopupMenuItem(value: 'contacto', child: Text('Contacto')),
        if (hasUser)
          const PopupMenuItem(value: 'perfil', child: Text('Mis reservas')),
        PopupMenuItem(
          value: hasUser ? 'logout' : 'login',
          child: Text(hasUser ? 'Cerrar sesión' : 'Ingresar'),
        ),
      ],
    );
  }
}

class _CartButton extends StatelessWidget {
  final int count;
  final VoidCallback onPressed;

  const _CartButton({
    required this.count,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        FilledButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.shopping_cart_outlined, size: 19),
          label: const Text('CARRITO'),
          style: FilledButton.styleFrom(
            backgroundColor: Navbar.amarillo,
            foregroundColor: const Color(0xFF2C3E50),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
          ),
        ),
        Positioned(
          top: -8,
          right: -5,
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 20,
              minHeight: 20,
            ),
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