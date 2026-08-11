import 'package:flutter/material.dart';
import '../models/carrito.dart';
import '../services/domicilio_service.dart';
import '../widgets/pesquera_scaffold.dart';
import '../widgets/pesquera_style.dart';

class DomicilioScreen extends StatefulWidget {
  const DomicilioScreen({super.key});

  @override
  State<DomicilioScreen> createState() => _DomicilioScreenState();
}

class _DomicilioScreenState extends State<DomicilioScreen> {
  final nombre = TextEditingController();
  final direccion = TextEditingController();
  final telefono = TextEditingController();
  final observaciones = TextEditingController();
  String? pago;
  bool guardando = false;

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
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(34),
                      child: Column(
                        children: [
                          const Text(
                            'Confirmar Domicilio',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: PesqueraStyle.ink,
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            'Finaliza tu pedido y recibe lo mejor del mar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF2C3E50),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: 72,
                            height: 4,
                            color: const Color(0xFFF1C40F),
                          ),
                          const SizedBox(height: 24),
                          _summary(),
                          const SizedBox(height: 22),
                          _cartProducts(),
                          const SizedBox(height: 20),
                          _input(nombre, 'Nombre completo', Icons.person),
                          const SizedBox(height: 13),
                          _input(direccion, 'Direccion de entrega', Icons.place),
                          const SizedBox(height: 13),
                          _input(telefono, 'Telefono celular', Icons.phone,
                              keyboardType: TextInputType.phone),
                          const SizedBox(height: 13),
                          DropdownButtonFormField<String>(
                            initialValue: pago,
                            decoration: InputDecoration(
                              labelText: 'Metodo de pago',
                              prefixIcon: const Icon(Icons.credit_card),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'efectivo',
                                child: Text('Efectivo al recibir'),
                              ),
                              DropdownMenuItem(
                                value: 'nequi',
                                child: Text('Transferencia Nequi'),
                              ),
                            ],
                            onChanged: (value) => setState(() => pago = value),
                          ),
                          const SizedBox(height: 13),
                          _input(
                            observaciones,
                            'Indicaciones o notas adicionales',
                            Icons.notes,
                            lines: 3,
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: guardando ? null : _guardarDomicilio,
                              child: const Text(
                                'Confirmar Pedido',
                                style: TextStyle(fontWeight: FontWeight.w900),
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
          ],
        ),
      ),
    );
  }

  Future<void> _guardarDomicilio() async {
    if (nombre.text.trim().isEmpty ||
        direccion.text.trim().isEmpty ||
        telefono.text.trim().isEmpty ||
        pago == null) {
      mostrarNotificacion(context, titulo: 'Datos incompletos', mensaje: 'Completa todos los datos del domicilio.', exito: false);
      return;
    }

    setState(() => guardando = true);
    final respuesta = await DomicilioService.crear(
      nombre: nombre.text.trim(),
      direccion: direccion.text.trim(),
      telefono: telefono.text.trim(),
      pago: pago!,
      observaciones: observaciones.text.trim(),
      productos: Carrito.items,
      total: Carrito.total,
    );
    setState(() => guardando = false);

    if (!mounted) return;

    await mostrarNotificacion(context, titulo: respuesta['success'] == true ? 'Pedido realizado' : 'No se pudo confirmar', mensaje: respuesta['success'] == true ? 'Tu pedido fue confirmado correctamente.' : respuesta['mensaje'].toString(), exito: respuesta['success'] == true);

    if (respuesta['success'] == true) {
      setState(() {
        Carrito.items.clear();
        nombre.clear();
        direccion.clear();
        telefono.clear();
        observaciones.clear();
        pago = null;
      });
    }
  }

  Widget _summary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              label: 'Productos',
              value: '${Carrito.items.length}',
            ),
          ),
          Container(width: 1, height: 46, color: Colors.grey.shade300),
          Expanded(
            child: _SummaryItem(
              label: 'Total',
              value: '\$${Carrito.total.toStringAsFixed(0)}',
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartProducts() {
    if (Carrito.items.isEmpty) {
      return const Text(
        'No hay productos en el carrito.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black54),
      );
    }

    return Column(
      children: Carrito.items
          .map(
            (producto) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(producto.nombre),
              trailing: Text(
                '\$${producto.precio}',
                style: const TextStyle(
                  color: Color(0xFF0A3D62),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _input(
    TextEditingController controller,
    String label,
    IconData icon, {
    int lines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      minLines: lines,
      maxLines: lines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF2C3E50),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF0A3D62),
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
