import 'package:flutter/material.dart';
import '../widgets/pesquera_scaffold.dart';
import 'reservas_screen.dart';
import 'menu_screen.dart';
import '../widgets/pesquera_style.dart';
import '../services/session_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return PesqueraScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: isMobile ? 430 : 685,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/fondo.png', fit: BoxFit.cover),
                  Container(color: Colors.black.withValues(alpha: 0.56)),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 820),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'BIENVENIDO A LA\nPESQUERA',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobile ? 31 : 36,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Un lugar donde el mar y la buena mesa se encuentran.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobile ? 13 : 15,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 28),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 120,
                                  height: 42,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (!SessionService.estaLogueado) {
                                        await pedirInicioSesion(context);
                                        return;
                                      }
                                      if (context.mounted) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const ReservasScreen(),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('RESERVA'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  width: 120,
                                  height: 42,
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const MenuScreen(),
                                      ),
                                    ),
                                    child: const Text('MENÚ'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.transparent,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 70,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: const Column(
                    children: [
                      Text(
                        'Sobre Nosotros',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: PesqueraStyle.ink,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 18),
                      Text(
                        'En La Pesquera ofrecemos los sabores más frescos del mar, preparados con recetas tradicionales y un toque moderno. Ven a disfrutar una experiencia única.',
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
            ),
          ],
        ),
      ),
    );
  }
}
