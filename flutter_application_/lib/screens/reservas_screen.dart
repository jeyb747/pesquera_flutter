import 'package:flutter/material.dart';
import '../services/reserva_service.dart';
import '../widgets/pesquera_scaffold.dart';
import '../widgets/pesquera_style.dart';

class ReservasScreen extends StatefulWidget {
  const ReservasScreen({super.key});

  @override
  State<ReservasScreen> createState() => _ReservasScreenState();
}

class _ReservasScreenState extends State<ReservasScreen> {
  int step = 1;
  int personas = 2;
  DateTime? fecha;
  String? hora;
  final nombre = TextEditingController();
  final telefono = TextEditingController();
  final observaciones = TextEditingController();
  bool guardando = false;

  final horas = const [
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '6:00 PM',
    '7:00 PM',
    '8:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return PesqueraScaffold(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 46,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: _card(),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _card() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF4C8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.explore_outlined,
                color: Color(0xFF0A3D62),
                size: 34,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Reserva tu mesa',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PesqueraStyle.ink,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Disfruta de la mejor cocina de mar',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF2C3E50),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Container(width: 72, height: 4, color: const Color(0xFFF1C40F)),
            const SizedBox(height: 26),
            LinearProgressIndicator(
              value: step / 4,
              minHeight: 8,
              borderRadius: BorderRadius.circular(999),
              backgroundColor: Colors.grey.shade200,
              color: PesqueraStyle.navy,
            ),
            const SizedBox(height: 28),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: switch (step) {
                1 => _personas(),
                2 => _fecha(),
                3 => _hora(),
                _ => _contacto(),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _personas() {
    return Column(
      key: const ValueKey(1),
      children: [
        const _StepTitle('Cuantos comensales asistiran?'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _CounterButton(
              icon: Icons.remove,
              onTap: () => setState(() => personas = (personas - 1).clamp(1, 20)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                '$personas',
                style: const TextStyle(
                  color: Color(0xFF2C3E50),
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            _CounterButton(
              icon: Icons.add,
              onTap: () => setState(() => personas = (personas + 1).clamp(1, 20)),
            ),
          ],
        ),
        const SizedBox(height: 26),
        _primaryButton('Continuar', () => setState(() => step = 2)),
      ],
    );
  }

  Widget _fecha() {
    return Column(
      key: const ValueKey(2),
      children: [
        const _StepTitle('Selecciona la fecha'),
        OutlinedButton.icon(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 60)),
              initialDate: fecha ?? DateTime.now(),
            );
            if (picked != null) setState(() => fecha = picked);
          },
          icon: const Icon(Icons.calendar_month),
          label: Text(
            fecha == null
                ? 'Elegir fecha'
                : '${fecha!.day}/${fecha!.month}/${fecha!.year}',
          ),
        ),
        const SizedBox(height: 26),
        _primaryButton('Continuar', fecha == null ? null : () => setState(() => step = 3)),
      ],
    );
  }

  Widget _hora() {
    return Column(
      key: const ValueKey(3),
      children: [
        const _StepTitle('Selecciona el horario'),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: horas.map((value) {
            final selected = value == hora;
            return ChoiceChip(
              label: Text(value),
              selected: selected,
              selectedColor: const Color(0xFFF1C40F),
              onSelected: (_) => setState(() => hora = value),
            );
          }).toList(),
        ),
        const SizedBox(height: 26),
        _primaryButton('Continuar', hora == null ? null : () => setState(() => step = 4)),
      ],
    );
  }

  Widget _contacto() {
    return Column(
      key: const ValueKey(4),
      children: [
        const _StepTitle('Datos de contacto'),
        _input(nombre, 'Nombre completo', Icons.person_outline),
        const SizedBox(height: 13),
        _input(telefono, 'Telefono', Icons.phone_outlined,
            keyboardType: TextInputType.phone),
        const SizedBox(height: 13),
        _input(observaciones, 'Observaciones', Icons.notes_outlined, lines: 3),
        const SizedBox(height: 22),
        _primaryButton(
          guardando ? 'Guardando...' : 'Confirmar Reserva',
          guardando ? null : _guardarReserva,
          blue: true,
        ),
      ],
    );
  }

  Future<void> _guardarReserva() async {
    if (nombre.text.trim().isEmpty || telefono.text.trim().isEmpty) {
      mostrarNotificacion(context, titulo: 'Datos incompletos', mensaje: 'Completa nombre y telefono.', exito: false);
      return;
    }

    setState(() => guardando = true);
    final respuesta = await ReservaService.crear(
      nombre: nombre.text.trim(),
      telefono: telefono.text.trim(),
      fecha:
          '${fecha!.year.toString().padLeft(4, '0')}-${fecha!.month.toString().padLeft(2, '0')}-${fecha!.day.toString().padLeft(2, '0')}',
      hora: hora!,
      personas: personas,
      observaciones: observaciones.text.trim(),
    );
    setState(() => guardando = false);

    if (!mounted) return;

    await mostrarNotificacion(context, titulo: respuesta['success'] == true ? 'Reserva realizada' : 'No se pudo reservar', mensaje: respuesta['success'] == true ? 'Tu reserva fue confirmada correctamente.' : respuesta['mensaje'].toString(), exito: respuesta['success'] == true);

    if (respuesta['success'] == true) {
      setState(() {
        step = 1;
        personas = 2;
        fecha = null;
        hora = null;
        nombre.clear();
        telefono.clear();
        observaciones.clear();
      });
    }
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
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _primaryButton(String text, VoidCallback? onPressed, {bool blue = false}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: blue ? const Color(0xFF0A3D62) : const Color(0xFFF1C40F),
          foregroundColor: blue ? Colors.white : const Color(0xFF2C3E50),
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class _StepTitle extends StatelessWidget {
  final String text;

  const _StepTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF0A3D62),
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CounterButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onTap,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFF0A3D62),
        foregroundColor: Colors.white,
        fixedSize: const Size(48, 48),
      ),
    );
  }
}
