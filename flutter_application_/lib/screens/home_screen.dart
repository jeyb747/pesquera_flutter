import 'package:flutter/material.dart';
import '../widgets/pesquera_scaffold.dart';
import 'reservas_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const azul = Color(0xFF0A3D62);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return PesqueraScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: isMobile ? 430 : 560,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/fondo.png', fit: BoxFit.cover),
                  Container(color: Colors.black.withOpacity(0.50)),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 820),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Bienvenido a La Pesquera',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobile ? 34 : 52,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Un lugar donde el mar y la buena mesa se encuentran.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobile ? 17 : 22,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 28),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ReservasScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Reserva',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 62),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: const Column(
                  children: [
                    Text(
                      'Sobre Nosotros',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: azul,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 18),
                    Text(
                      'En La Pesquera ofrecemos los sabores mas frescos del mar, preparados con recetas tradicionales y un toque moderno. Ven a disfrutar una experiencia unica.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF6C757D),
                        fontSize: 18,
                        height: 1.55,
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
}
