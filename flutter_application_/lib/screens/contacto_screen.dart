import 'package:flutter/material.dart';
import '../widgets/pesquera_scaffold.dart';
import '../widgets/pesquera_style.dart';

class ContactoScreen extends StatelessWidget {
  const ContactoScreen({super.key});

  @override
  Widget build(BuildContext context) => PesqueraScaffold(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 34),
          child: Center(child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Container(
              padding: const EdgeInsets.all(30), decoration: PesqueraStyle.cardDecoration,
              child: Column(children: [
                const CircleAvatar(backgroundColor: Color(0xFFEAF6FC), child: Icon(Icons.chat_bubble_outline, color: PesqueraStyle.navy)),
                const SizedBox(height: 14), Text('CONTÁCTANOS', style: PesqueraStyle.title(28)),
                const SizedBox(height: 8), const Text('Estamos para ayudarte. Escríbenos y te responderemos por WhatsApp.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black45, fontSize: 12)),
                const SizedBox(height: 24),
                const Row(children: [Expanded(child: _Info(icon: Icons.location_on_outlined, title: 'UBICACIÓN', text: 'Cra. 79 #42B-07, Bogotá')), SizedBox(width: 12), Expanded(child: _Info(icon: Icons.chat_outlined, title: 'RESPUESTA RÁPIDA', text: 'Atención por WhatsApp'))]),
                const SizedBox(height: 22), const _Field(label: 'NOMBRE COMPLETO', hint: 'Ingresa tu nombre', icon: Icons.person_outline),
                const SizedBox(height: 12), const _Field(label: 'TELÉFONO CELULAR', hint: 'Ej: 3001234567', icon: Icons.phone_outlined),
                const SizedBox(height: 12), const _Field(label: '¿CÓMO PODEMOS AYUDARTE?', hint: 'Escribe tu mensaje aquí', lines: 3),
                const SizedBox(height: 16), SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => _mostrarAviso(context), icon: const Icon(Icons.chat), label: const Text('ENVIAR MENSAJE POR WHATSAPP'))),
              ]),
            ),
          )),
        ),
      );
}

void _mostrarAviso(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: const Icon(Icons.check_circle_outline, color: PesqueraStyle.navy, size: 40),
      content: const Text('Mensaje listo para enviar por WhatsApp.', textAlign: TextAlign.center),
      actionsAlignment: MainAxisAlignment.center,
      actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('ENTENDIDO'))],
    ),
  );
}

class _Info extends StatelessWidget { final IconData icon; final String title, text; const _Info({required this.icon, required this.title, required this.text}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFF8FBFD), border: Border.all(color: const Color(0xFFD7E5ED)), borderRadius: BorderRadius.circular(8)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, size: 17, color: PesqueraStyle.yellow), const SizedBox(height: 8), Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: PesqueraStyle.ink)), const SizedBox(height: 5), Text(text, style: const TextStyle(fontSize: 10, color: Colors.black54))])); }
class _Field extends StatelessWidget { final String label, hint; final IconData? icon; final int lines; const _Field({required this.label, required this.hint, this.icon, this.lines = 1}); @override Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 11, color: PesqueraStyle.ink, fontWeight: FontWeight.w700)), const SizedBox(height: 5), TextField(minLines: lines, maxLines: lines, decoration: InputDecoration(hintText: hint, prefixIcon: icon == null ? null : Icon(icon, size: 18), border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)), isDense: true))]); }
