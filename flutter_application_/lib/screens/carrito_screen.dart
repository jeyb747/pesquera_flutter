import 'package:flutter/material.dart';
import '../models/carrito.dart';
import '../widgets/pesquera_scaffold.dart';
import 'domicilio_screen.dart';
import 'menu_screen.dart';
import '../widgets/pesquera_style.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  @override
  Widget build(BuildContext context) {
    return PesqueraScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 46),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                  children: [
                    const Text(
                      'Carrito de Compras',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF0A3D62),
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Revisa tus productos antes de finalizar tu pedido',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF2C3E50)),
                    ),
                    const SizedBox(height: 12),
                    Container(width: 72, height: 4, color: const Color(0xFFF1C40F)),
                    const SizedBox(height: 28),
                    Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(26),
                        child: Column(
                          children: [
                            if (Carrito.items.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Text('Tu carrito esta vacio.'),
                              )
                            else
                              ...Carrito.items.map(
                                (producto) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/${producto.imagen}',
                                      width: 58,
                                      height: 58,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    producto.nombre,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  subtitle: Text('\$${producto.precio}'),
                                  trailing: IconButton(
                                    onPressed: () {
                                      setState(() => Carrito.eliminar(producto));
                                    },
                                    icon: const Icon(Icons.delete_outline),
                                    tooltip: 'Eliminar',
                                  ),
                                ),
                              ),
                            const Divider(height: 34),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F9FB),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total del pedido',
                                          style: TextStyle(
                                            color: Color(0xFF2C3E50),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Incluye todos los productos agregados',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '\$${Carrito.total.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Color(0xFF0A3D62),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 22),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.center,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: Carrito.items.isEmpty
                                      ? null
                                      : () {
                                          setState(() => Carrito.items.clear());
                                        },
                                  icon: const Icon(Icons.delete_outline),
                                  label: const Text('Vaciar carrito'),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const MenuScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.arrow_back),
                                  label: const Text('Volver al menu'),
                                ),
                                ElevatedButton.icon(
                                  onPressed: Carrito.items.isEmpty
                                      ? null
                                  : () async {
                                          if (!await pedirInicioSesion(context)) return;
                                          if (!context.mounted) return;
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const DomicilioScreen(),
                                            ),
                                          );
                                        },
                                  icon: const Icon(Icons.credit_card),
                                  label: const Text('Pagar pedido'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
