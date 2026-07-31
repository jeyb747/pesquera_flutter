import 'package:flutter/material.dart';
import '../models/domicilio.dart';
import '../models/reserva.dart';
import '../services/domicilio_service.dart';
import '../services/reserva_service.dart';
import '../services/session_service.dart';
import '../widgets/pesquera_scaffold.dart';
import 'login_screen.dart';
import 'menu_screen.dart';
import 'reservas_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  late Future<List<Reserva>> reservas;
  late Future<List<Domicilio>> domicilios;

  @override
  void initState() {
    super.initState();
    reservas = ReservaService.listar();
    domicilios = DomicilioService.listar();
  }

  @override
  Widget build(BuildContext context) {
    if (!SessionService.estaLogueado) {
      return PesqueraScaffold(
        child: _LoginRequired(
          onLogin: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          ),
        ),
      );
    }

    return PesqueraScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 42),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(
                      nombre: SessionService.nombre ?? 'Usuario',
                      correo: SessionService.correo ?? '',
                    ),
                    const SizedBox(height: 26),
                    _Section(
                      title: 'Mis reservas',
                      icon: Icons.calendar_month,
                      emptyText: 'No tienes reservas todavia.',
                      actionText: 'Reservar mesa',
                      onAction: () => _go(const ReservasScreen()),
                      future: reservas,
                      builder: (items) => Column(
                        children: items
                            .map((reserva) => _ReservaCard(reserva: reserva))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _Section(
                      title: 'Mis pedidos',
                      icon: Icons.local_shipping_outlined,
                      emptyText: 'Aun no has realizado pedidos.',
                      actionText: 'Hacer pedido',
                      onAction: () => _go(const MenuScreen()),
                      future: domicilios,
                      builder: (items) => Column(
                        children: items
                            .map((domicilio) => _DomicilioCard(domicilio: domicilio))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const PesqueraFooter(),
          ],
        ),
      ),
    );
  }

  void _go(Widget screen) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class _Header extends StatelessWidget {
  final String nombre;
  final String correo;

  const _Header({required this.nombre, required this.correo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0A3D62),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: const BoxDecoration(
              color: Color(0xFFF1C40F),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline, color: Color(0xFF0A3D62), size: 34),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (correo.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(correo, style: const TextStyle(color: Colors.white70)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section<T> extends StatelessWidget {
  final String title;
  final IconData icon;
  final String emptyText;
  final String actionText;
  final VoidCallback onAction;
  final Future<List<T>> future;
  final Widget Function(List<T>) builder;

  const _Section({
    required this.title,
    required this.icon,
    required this.emptyText,
    required this.actionText,
    required this.onAction,
    required this.future,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF0A3D62)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF0A3D62),
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                OutlinedButton(onPressed: onAction, child: Text(actionText)),
              ],
            ),
            const SizedBox(height: 18),
            FutureBuilder<List<T>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Text('No se pudo cargar la informacion: ${snapshot.error}');
                }

                final items = snapshot.data ?? [];
                if (items.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    child: Center(
                      child: Text(emptyText, style: const TextStyle(color: Colors.black54)),
                    ),
                  );
                }

                return builder(items);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ReservaCard extends StatelessWidget {
  final Reserva reserva;

  const _ReservaCard({required this.reserva});

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: '${reserva.fecha} - ${reserva.hora}',
      badge: reserva.estado,
      lines: [
        '${reserva.personas} personas',
        if (reserva.observaciones.isNotEmpty) reserva.observaciones,
      ],
    );
  }
}

class _DomicilioCard extends StatelessWidget {
  final Domicilio domicilio;

  const _DomicilioCard({required this.domicilio});

  @override
  Widget build(BuildContext context) {
    final progress = _progress(domicilio.estado);

    return _InfoCard(
      title: 'Pedido #${domicilio.pedidoId == 0 ? domicilio.id : domicilio.pedidoId}',
      badge: domicilio.estado,
      lines: [
        domicilio.direccion.isEmpty ? 'Direccion pendiente' : domicilio.direccion,
        'Total: \$${domicilio.totalFormateado}',
      ],
      footer: Column(
        children: [
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(999),
            color: const Color(0xFFF1C40F),
            backgroundColor: Colors.grey.shade200,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Recibido', style: TextStyle(fontSize: 12)),
              Text('En camino', style: TextStyle(fontSize: 12)),
              Text('Entregado', style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  double _progress(String estado) {
    final value = estado.toLowerCase();
    if (value == 'entregado') return 1;
    if (value == 'en camino') return 0.65;
    return 0.25;
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String badge;
  final List<String> lines;
  final Widget? footer;

  const _InfoCard({
    required this.title,
    required this.badge,
    required this.lines,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF2C3E50),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _Badge(text: badge),
            ],
          ),
          const SizedBox(height: 8),
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(line, style: const TextStyle(color: Colors.black54)),
            ),
          ),
          if (footer != null) footer!,
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;

  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    final value = text.toLowerCase();
    final color = value == 'entregado' || value == 'confirmada'
        ? Colors.green
        : value == 'cancelada'
            ? Colors.red
            : const Color(0xFFF1C40F);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text.isEmpty ? 'pendiente' : text,
        style: TextStyle(
          color: color == const Color(0xFFF1C40F) ? const Color(0xFF7A5B00) : color,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _LoginRequired extends StatelessWidget {
  final VoidCallback onLogin;

  const _LoginRequired({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline, size: 42, color: Color(0xFF0A3D62)),
                  const SizedBox(height: 14),
                  const Text(
                    'Inicia sesion para ver tu cuenta',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(onPressed: onLogin, child: const Text('Iniciar sesion')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
