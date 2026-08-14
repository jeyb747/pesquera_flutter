import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class PesqueraStyle {
  static const navy = Color(0xFF124D73);
  static const deepNavy = Color(0xFF082F57);
  static const yellow = Color(0xFFF5C400);
  static const ink = Color(0xFF072F59);
  static const softBlue = Color(0xFFF7FBFD);

  static TextStyle title(double size) => GoogleFonts.cinzel(
        color: ink,
        fontSize: size,
        fontWeight: FontWeight.w700,
        letterSpacing: .2,
      );

  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(color: Color(0x16072F59), blurRadius: 20, offset: Offset(0, 8)),
    ],
  );
}

class WaveBackground extends StatelessWidget {
  final Widget child;
  const WaveBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(painter: _WavePainter(), child: child),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(PesqueraStyle.softBlue, BlendMode.srcOver);
    final paint = Paint()
      ..color = const Color(0x160A5B87)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    const gap = 24.0;
    const amplitude = 3.2;
    const wavelength = 34.0;
    for (double y = 12; y < size.height; y += gap) {
      final path = Path()..moveTo(0, y);
      for (double x = 0; x <= size.width; x += 2) {
        path.lineTo(x, y + math.sin(x / wavelength * math.pi * 2) * amplitude);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Future<void> mostrarNotificacion(
  BuildContext context, {
  required String titulo,
  required String mensaje,
  bool exito = true,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Icon(
        exito ? Icons.check_circle_outline : Icons.info_outline,
        color: exito ? const Color(0xFF198754) : PesqueraStyle.yellow,
        size: 42,
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(titulo, style: PesqueraStyle.title(21), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(mensaje, textAlign: TextAlign.center),
      ]),
      actionsAlignment: MainAxisAlignment.center,
      actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('ENTENDIDO'))],
    ),
  );
}
