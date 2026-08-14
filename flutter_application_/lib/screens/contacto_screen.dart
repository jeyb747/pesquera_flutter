import 'package:flutter/material.dart';
import '../widgets/pesquera_scaffold.dart';
import '../widgets/pesquera_style.dart';

class ContactoScreen extends StatelessWidget {
  const ContactoScreen({super.key});

  @override
  Widget build(BuildContext context) => PesqueraScaffold(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Container(
            padding: const EdgeInsets.all(34),
            decoration: PesqueraStyle.cardDecoration,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFEAF6FC),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: PesqueraStyle.navy,
                  ),
                ),
                const SizedBox(height: 12),
                Text('CONTÁCTANOS', style: PesqueraStyle.title(30)),
                const SizedBox(height: 8),
                const Text(
                  'ESTAMOS PARA AYUDARTE. ESCRÍBENOS Y TE RESPONDEREMOS POR WHATSAPP.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Colors.black45),
                ),
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Expanded(
                      child: _Info(
                        icon: Icons.location_on_outlined,
                        title: 'UBICACIÓN',
                        text: 'CRA. 79 #42B-07, BOGOTÁ',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _Info(
                        icon: Icons.chat_outlined,
                        title: 'RESPUESTA RÁPIDA',
                        text: 'ATENCIÓN POR WHATSAPP',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const _Field(
                  label: 'NOMBRE COMPLETO',
                  hint: 'INGRESA TU NOMBRE',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 12),
                const _Field(
                  label: 'TELÉFONO CELULAR',
                  hint: 'EJ: 3001234567',
                  icon: Icons.phone_outlined,
                ),
                const SizedBox(height: 12),
                const _Field(
                  label: '¿CÓMO PODEMOS AYUDARTE?',
                  hint: 'ESCRIBE TU MENSAJE AQUÍ',
                  lines: 3,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => mostrarNotificacion(
                      context,
                      titulo: 'Mensaje listo',
                      mensaje:
                          'Tu mensaje está listo para enviar por WhatsApp.',
                    ),
                    icon: const Icon(Icons.chat, size: 16),
                    label: const Text('ENVIAR MENSAJE POR WHATSAPP'),
                  ),
                ),
                const SizedBox(height: 18),
                const _LocationCard(),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _Info extends StatelessWidget {
  final IconData icon;
  final String title, text;
  const _Info({required this.icon, required this.title, required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: const Color(0xFFF8FBFD),
      border: Border.all(color: const Color(0xFFD7E5ED)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: PesqueraStyle.yellow),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: PesqueraStyle.ink,
          ),
        ),
        const SizedBox(height: 5),
        Text(text, style: const TextStyle(fontSize: 10, color: Colors.black54)),
      ],
    ),
  );
}

class _Field extends StatelessWidget {
  final String label, hint;
  final IconData? icon;
  final int lines;
  const _Field({
    required this.label,
    required this.hint,
    this.icon,
    this.lines = 1,
  });
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          color: PesqueraStyle.ink,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 6),
      TextField(
        minLines: lines,
        maxLines: lines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 11),
          prefixIcon: icon == null ? null : Icon(icon, size: 18),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          isDense: true,
        ),
      ),
    ],
  );
}

class _LocationCard extends StatelessWidget {
  const _LocationCard();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFF8FBFD),
      border: Border.all(color: const Color(0xFFD7E5ED)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('🗺 ENCUÉNTRANOS', style: PesqueraStyle.title(23)),
        const SizedBox(height: 8),
        const Text(
          'CRA. 79 #42B-07, ANTONIO NARIÑO, BOGOTÁ',
          style: TextStyle(fontSize: 10, color: Colors.black54),
        ),
      ],
    ),
  );
}

/*class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFE6EDF1), BlendMode.srcOver);
    final block = Paint()..color = const Color(0xFFDCE5E9);
    final park = Paint()..color = const Color(0xFFCFE7D5);
    final outline = Paint()
      ..color = const Color(0xFFC2D0D7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final blocks = [
      Rect.fromLTWH(8, 10, size.width * .22, size.height * .26),
      Rect.fromLTWH(size.width * .29, 8, size.width * .22, size.height * .30),
      Rect.fromLTWH(size.width * .70, 8, size.width * .25, size.height * .25),
      Rect.fromLTWH(
        size.width * .03,
        size.height * .65,
        size.width * .23,
        size.height * .25,
      ),
      Rect.fromLTWH(
        size.width * .72,
        size.height * .64,
        size.width * .22,
        size.height * .28,
      ),
    ];
    for (final item in blocks) {
      canvas.drawRect(item, block);
      canvas.drawRect(item, outline);
    }
    canvas.drawRect(
      Rect.fromLTWH(size.width * .70, 8, size.width * .25, size.height * .25),
      park,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * .03,
        size.height * .65,
        size.width * .23,
        size.height * .25,
      ),
      park,
    );
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.square;
    final roadLine = Paint()
      ..color = const Color(0xFFD2DBE1)
      ..strokeWidth = 1.4;
    final roads = [
      [Offset(-20, 26), Offset(size.width + 20, size.height * .66)],
      [Offset(0, size.height * .82), Offset(size.width, 30)],
      [
        Offset(size.width * .18, -15),
        Offset(size.width * .77, size.height + 15),
      ],
      [
        Offset(size.width * .57, -15),
        Offset(size.width * .10, size.height + 15),
      ],
      [
        Offset(-15, size.height * .48),
        Offset(size.width + 15, size.height * .48),
      ],
    ];
    for (final pair in roads) {
      canvas.drawLine(pair[0], pair[1], road);
      canvas.drawLine(pair[0], pair[1], roadLine);
    }
    final text = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    for (final label in const [
      ('Carrera 79C', .20, .18),
      ('Transversal 79C', .64, .70),
      ('Cra. 79', .74, .30),
      ('Parque', .77, .12),
    ]) {
      text.text = TextSpan(
        text: label.$1,
        style: const TextStyle(color: Color(0xFF66757F), fontSize: 9),
      );
      text.layout();
      text.paint(canvas, Offset(size.width * label.$2, size.height * label.$3));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapPin extends StatelessWidget {
  const _MapPin();

  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: 36,
        height: 12,
        margin: const EdgeInsets.only(top: 31),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: .16),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      const Icon(
        Icons.location_on,
        color: Color(0xFFE94235),
        size: 46,
        shadows: [
          Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      const Positioned(
        top: 12,
        child: CircleAvatar(radius: 4, backgroundColor: Colors.white),
      ),
    ],
  );
}*/
